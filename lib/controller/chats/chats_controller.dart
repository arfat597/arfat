import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:studentsystem/core/class/SupabaseCrud.dart';
import 'package:studentsystem/core/class/statusRequest.dart';
import 'package:studentsystem/core/servieces/servieces.dart';

class ChatsController extends GetxController {
  final Myservieces myservieces = Get.find();
  final SupabaseCrud supabaseCrud = SupabaseCrud();
  final SupabaseClient client = Supabase.instance.client;

  statusRequest statusRequeste = statusRequest.none;

  int? chatId;
  int? supervisorId;
  String supervisorName = "د. خالد أحمد السالم";
  String supervisorEmail = "";
  String studentName = "";
  int? studentId;
  int? groupId;

  // متغيرات جديدة للتحقق من القائد والمجموعة
  bool isGroupLeader = false;
  bool hasGroupAndSupervisor = false;

  List<Map<String, dynamic>> messagesList = [];
  final TextEditingController messageTextController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  RealtimeChannel? _messagesSubscription;

  Future<void> loadChatData() async {
    statusRequeste = statusRequest.loding;
    update();

    try {
      final studentIdStr = myservieces.sharedPref.getString("id");
      studentName = myservieces.sharedPref.getString("name") ?? "طالب";
      final groupIdStr = myservieces.sharedPref.getString("idgroup");
      final leaderIdStr = myservieces.sharedPref.getString("leaderid");

      if (studentIdStr == null) {
        statusRequeste = statusRequest.faliure;
        update();
        return;
      }
      studentId = int.tryParse(studentIdStr);

      // 1. Fetch student and supervisor details from student_group_view
      final response = await supabaseCrud.selectOne(
        table: "student_group_view",
        match: {"stud_id": studentId},
      );

      if (response.status == statusRequest.success && response.data != null) {
        final data = response.data!;
        if (data['sprvsr_name'] != null) {
          supervisorName = "د. ${data['sprvsr_name']}";
        }
        supervisorEmail = data['sprvsr_email'] ?? "";

        final gId = data['group_id'];
        if (gId != null) {
          groupId = int.tryParse(gId.toString());
        }

        // التحقق من قائد المجموعة
        final leaderId = data['group_led_id'];
        if (leaderId != null && studentId != null) {
          isGroupLeader = leaderId.toString() == studentId.toString();
        }
      } else {
        // Fallback to shared preferences if group view fails
        if (groupIdStr != null) {
          groupId = int.tryParse(groupIdStr);
        }
      }

      // التحقق من القائد عبر الكاش كبديل
      if (!isGroupLeader && leaderIdStr != null && studentIdStr != null) {
        isGroupLeader = leaderIdStr == studentIdStr;
      }

      // التحقق: هل الطالب ضمن مجموعة؟
      if (groupId == null) {
        hasGroupAndSupervisor = false;
        statusRequeste = statusRequest.success;
        update();
        return;
      }

      // 2. Fetch the supervisor ID from the groups table
      final groupRes = await supabaseCrud.selectOne(
        table: "groups",
        match: {"group_id": groupId},
      );

      if (groupRes.status == statusRequest.success && groupRes.data != null) {
        supervisorId = groupRes.data!['id_sprvsr'];
      }

      // التحقق: هل لديه مشرف؟
      if (supervisorId == null) {
        hasGroupAndSupervisor = false;
        statusRequeste = statusRequest.success;
        update();
        return;
      }

      // الطالب لديه مجموعة ومشرف
      hasGroupAndSupervisor = true;

      // 3. Locate or create a chat
      final chatRes = await supabaseCrud.selectOne(
        table: "chats",
        match: {"id_group": groupId, "id_sprvsr": supervisorId},
      );

      if (chatRes.status == statusRequest.success && chatRes.data != null) {
        chatId = chatRes.data!['chat_id'];
      } else {
        // Create new chat
        final insertRes = await supabaseCrud.insert(
          table: "chats",
          data: {
            "id_group": groupId,
            "id_sprvsr": supervisorId,
            "last_message": "بدأت المحادثة",
            "last_message_time": DateTime.now().toUtc().toIso8601String(),
          },
        );

        if (insertRes.status == statusRequest.success &&
            insertRes.data != null) {
          chatId = insertRes.data!['chat_id'];
        }
      }

      if (chatId != null) {
        // 4. Fetch message history
        await fetchMessages();
        // 5. Setup realtime updates
        setupRealtime();
        // 6. تحديث حالة الرسائل إلى مقروءة
        await markMessagesAsRead();
        statusRequeste = statusRequest.success;
      } else {
        statusRequeste = statusRequest.faliure;
      }
    } catch (e) {
      statusRequeste = statusRequest.serverExecption;
      debugPrint("Error loading chat: $e");
    }

    update();
  }

  Future<void> fetchMessages() async {
    if (chatId == null) return;
    try {
      final msgRes = await supabaseCrud.selectWhere(
        table: "messages",
        match: {"id_chat": chatId},
      );

      if (msgRes.status == statusRequest.success && msgRes.data != null) {
        messagesList = List<Map<String, dynamic>>.from(msgRes.data!);
        messagesList.sort((a, b) {
          final aTime =
              DateTime.tryParse(a['created_at']?.toString() ?? '') ??
              DateTime.now();
          final bTime =
              DateTime.tryParse(b['created_at']?.toString() ?? '') ??
              DateTime.now();
          return aTime.compareTo(bTime);
        });
        update();
        scrollToBottom();
        // تحديث حالة الرسائل عند جلب رسائل جديدة
        await markMessagesAsRead();
      }
    } catch (e) {
      debugPrint("Error fetching messages: $e");
    }
  }

  /// تحديث حالة الرسائل المرسلة من المشرف إلى "مقروءة"
  Future<void> markMessagesAsRead() async {
    if (chatId == null || studentId == null) return;
    try {
      // تحديث جميع الرسائل المرسلة من المشرف والتي لم تُقرأ بعد
      final unreadMessages = messagesList
          .where(
            (msg) =>
                msg['sender_role'] == 'supervisor' &&
                (msg['message_status'] == 'sent' ||
                    msg['message_status'] == 'delivered' ||
                    msg['message_status'] == null) &&
                msg['message_id'] != null,
          )
          .toList();

      for (var msg in unreadMessages) {
        await supabaseCrud.update(
          table: "messages",
          match: {"message_id": msg['message_id']},
          newData: {"message_status": "read", "is_read": true},
        );
        // تحديث محلياً
        msg['message_status'] = 'read';
        msg['is_read'] = true;
      }
      if (unreadMessages.isNotEmpty) {
        update();
      }
    } catch (e) {
      debugPrint("Error marking messages as read: $e");
    }
  }

  void setupRealtime() {
    if (chatId == null) return;
    try {
      _messagesSubscription = supabaseCrud.subscribeToChanges(
        channelName: "chat_messages_channel_$chatId",
        table: "messages",
        columnFilter: "id_chat",
        valueFilter: chatId!,
        onChange: (payload) {
          fetchMessages();
        },
      );
    } catch (e) {
      debugPrint("Error subscribing to realtime messages: $e");
    }
  }

  Future<void> sendMessage() async {
    final text = messageTextController.text.trim();
    if (text.isEmpty || chatId == null || studentId == null) return;

    messageTextController.clear();

    try {
      final insertRes = await supabaseCrud.insert(
        table: "messages",
        data: {
          "id_chat": chatId,
          "sender_id": studentId,
          "sender_role": "student",
          "message_text": text,
          "is_read": false,
          "message_status": "sent",
          "created_at": DateTime.now().toUtc().toIso8601String(),
        },
      );

      if (insertRes.status == statusRequest.success) {
        // Update last message details in chat
        await supabaseCrud.update(
          table: "chats",
          match: {"chat_id": chatId},
          newData: {
            "last_message": text,
            "last_message_time": DateTime.now().toUtc().toIso8601String(),
          },
        );
        fetchMessages();
      } else {
        Get.snackbar(
          "خطأ",
          "فشل في إرسال الرسالة",
          backgroundColor: Colors.red.shade100,
        );
      }
    } catch (e) {
      debugPrint("Error sending message: $e");
    }
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void onInit() {
    super.onInit();
    loadChatData();
  }

  @override
  void onClose() {
    if (_messagesSubscription != null) {
      try {
        client.removeChannel(_messagesSubscription!);
      } catch (e) {
        debugPrint("Error cleaning up realtime channel: $e");
      }
    }
    messageTextController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
