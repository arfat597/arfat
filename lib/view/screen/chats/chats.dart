import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studentsystem/controller/chats/chats_controller.dart';
import 'package:studentsystem/core/class/handlingdata.dart';
import 'package:studentsystem/core/constens/AppColar.dart';
import 'package:studentsystem/view/widget/Home/CustomAppBar_home.dart';
import 'package:studentsystem/view/widget/Home/CustomDrawer_home.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ChatsController());

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColar.white,
        appBar: const CustomappbarHome(),
        drawer: const CustomdrawerHome(),
        body: SafeArea(
          child: GetBuilder<ChatsController>(
            builder: (controller) {
              return HandlingdataRequest(
                statusRequeste: controller.statusRequeste,
                widget: _buildBody(context, controller),
              );
            },
          ),
        ),
      ),
    );
  }

  /// الجسم الرئيسي: يعرض رسالة عدم وجود مجموعة أو صفحة الدردشة
  Widget _buildBody(BuildContext context, ChatsController controller) {
    // التحقق: إذا لم يكن لديه مجموعة ومشرف
    if (!controller.hasGroupAndSupervisor) {
      return _buildNoGroupWidget();
    }

    // لديه مجموعة ومشرف → عرض الدردشة
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title & Description
          const Text(
            "المحادثة",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B3B70),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "محادثة مباشرة مع المشرف الأكاديمي",
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),

          // Main Chat Card
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: Colors.grey.shade200,
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  // Chat Header
                  _buildChatHeader(controller),

                  // Messages List
                  _buildMessageList(context, controller),

                  // Chat Input - فقط إذا كان الطالب قائد المجموعة
                  if (controller.isGroupLeader) _buildChatInput(controller),

                  // إذا لم يكن قائد المجموعة، عرض رسالة
                  if (!controller.isGroupLeader) _buildNotLeaderBanner(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============ Chat Header ============
  Widget _buildChatHeader(ChatsController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: AppColar.primaryAPP,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // Avatar with white border
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.6), width: 1),
                ),
                child: const CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 18,
                  child: Text(
                    "د",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Supervisor Name
              Text(
                controller.supervisorName,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  // ============ Message List ============
  Widget _buildMessageList(BuildContext context, ChatsController controller) {
    return Expanded(
      child: Container(
        color: const Color(0xFFF9FAFB),
        child: controller.messagesList.isEmpty
            // إذا لا توجد رسائل، اترك الصفحة فارغة
            ? const SizedBox.shrink()
            : Scrollbar(
                controller: controller.scrollController,
                thumbVisibility: true,
                child: ListView.builder(
                  controller: controller.scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  itemCount: controller.messagesList.length,
                  itemBuilder: (context, index) {
                    final message = controller.messagesList[index];
                    // رسائل الطالب = أزرق، رسائل المشرف = أبيض
                    final isStudent = message['sender_role'] == 'student';

                    return _buildMessageBubble(context, message, isStudent);
                  },
                ),
              ),
      ),
    );
  }

  // ============ Message Bubble ============
  Widget _buildMessageBubble(BuildContext context, Map<String, dynamic> message, bool isStudent) {
    final text = message['message_text'] ?? "";
    final timeStr = message['created_at'] != null
        ? _formatTime(message['created_at'].toString())
        : "";
    final messageStatus = message['message_status']?.toString() ?? 'sent';

    return Align(
      // رسائل الطالب على اليمين (RTL)، رسائل المشرف على اليسار
      alignment: isStudent ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.72,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          // الطالب = أزرق، المشرف = أبيض
          color: isStudent ? AppColar.primaryAPP : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: isStudent ? null : Border.all(color: Colors.grey.shade200, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: TextStyle(
                color: isStudent ? Colors.white : Colors.black87,
                fontSize: 14.5,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // الوقت
                Text(
                  timeStr,
                  style: TextStyle(
                    color: isStudent ? Colors.white.withOpacity(0.75) : Colors.grey.shade500,
                    fontSize: 10,
                  ),
                ),
                // حالة الرسالة - فقط لرسائل الطالب
                if (isStudent) ...[
                  const SizedBox(width: 4),
                  _buildMessageStatusIcon(messageStatus),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ============ Message Status Icon ============
  Widget _buildMessageStatusIcon(String status) {
    switch (status) {
      case 'read':
        // ✓✓ مقروءة - أزرق فاتح
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.done_all, size: 14, color: Color(0xFF93C5FD)),
          ],
        );
      case 'delivered':
        // ✓✓ تم التوصيل - أبيض
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.done_all, size: 14, color: Colors.white70),
          ],
        );
      case 'sent':
      default:
        // ✓ تم الإرسال - أبيض
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.done, size: 14, color: Colors.white70),
          ],
        );
    }
  }

  // ============ Chat Input ============
  Widget _buildChatInput(ChatsController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade100)),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
      ),
      child: Row(
        children: [
          // Send Button (Light blue background, white send icon pointing top-left in RTL)
          GestureDetector(
            onTap: controller.sendMessage,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF93C5FD), // Light blue color matching design
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.send,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Input Text Field
          Expanded(
            child: Container(
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300, width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TextField(
                  controller: controller.messageTextController,
                  onSubmitted: (_) => controller.sendMessage(),
                  decoration: const InputDecoration(
                    hintText: "اكتب رسالتك هنا...",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Attachment Icon
          IconButton(
            icon: const Icon(Icons.attach_file, color: Colors.grey, size: 22),
            onPressed: () {
              // Future extension logic
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  // ============ Not Leader Banner ============
  Widget _buildNotLeaderBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7ED),
        border: Border(top: BorderSide(color: Colors.orange.shade200)),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.orange.shade700, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "فقط قائد المجموعة يمكنه إرسال الرسائل",
              style: TextStyle(
                color: Colors.orange.shade800,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============ No Group/Supervisor Fallback Widget ============
  Widget _buildNoGroupWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.group_off_outlined,
                size: 64,
                color: Color(0xFF94A3B8),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "لا يمكن عرض هذه الصفحة حالياً",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B3B70),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "لأنك لست ضمن مجموعة في الوقت الحالي.\nيرجى الانضمام إلى مجموعة وتعيين مشرف أكاديمي لتفعيل المحادثة.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============ Time Formatter ============
  String _formatTime(String dateStr) {
    try {
      final dateTime = DateTime.parse(dateStr).toLocal();
      final hour = dateTime.hour.toString().padLeft(2, '0');
      final minute = dateTime.minute.toString().padLeft(2, '0');
      return "$hour:$minute";
    } catch (e) {
      return "";
    }
  }
}
