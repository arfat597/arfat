import 'package:studentsystem/core/class/statusRequest.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// نموذج النتيجة الموحد
class ApiResponse<T> {
  final statusRequest status;
  final T? data;
  final String? error;

  ApiResponse({required this.status, this.data, this.error});
}

// كلاس SupabaseCrud المبسط والمعدل
class SupabaseCrud {
  final SupabaseClient _client = Supabase.instance.client;

  // دالة لتحويل Map<String, dynamic> → Map<String, Object>
  Map<String, Object> _convertMap(Map<String, dynamic> map) {
    return map.map((key, value) => MapEntry(key, value as Object));
  }

  // ================= REALTIME SUBSCRIPTION =================
  RealtimeChannel subscribeToChanges({
    required String channelName,
    required String table,
    required String columnFilter,
    required dynamic valueFilter,
    required void Function(PostgresChangePayload payload) onChange,
  }) {
    final channel = _client.channel(channelName);

    channel
        .onPostgresChanges(
          event: PostgresChangeEvent.all, // INSERT + UPDATE + DELETE
          schema: 'public',
          table: table,
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: columnFilter,
            value: valueFilter,
          ),
          callback: onChange,
        )
        .subscribe();

    return channel;
  }

  // ================= INSERT =================
  Future<ApiResponse<Map<String, dynamic>>> insert({
    required String table,
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await _client
          .from(table)
          .insert(_convertMap(data))
          .select()
          .single();
      return ApiResponse(status: statusRequest.success, data: response);
    } catch (e) {
      return ApiResponse(
        status: statusRequest.serverExecption,
        error: e.toString(),
      );
    }
  }

  // ================= UPDATE =================
  Future<ApiResponse<Map<String, dynamic>>> update({
    required String table,
    required Map<String, dynamic> match,
    required Map<String, dynamic> newData,
  }) async {
    try {
      final response = await _client
          .from(table)
          .update(_convertMap(newData))
          .match(_convertMap(match))
          .select()
          .single();
      return ApiResponse(status: statusRequest.success, data: response);
    } catch (e) {
      return ApiResponse(
        status: statusRequest.serverExecption,
        error: e.toString(),
      );
    }
  }

  // ================= DELETE =================
  Future<ApiResponse<void>> delete({
    required String table,
    required Map<String, dynamic> match,
  }) async {
    try {
      await _client.from(table).delete().match(_convertMap(match));
      return ApiResponse(status: statusRequest.success);
    } catch (e) {
      return ApiResponse(
        status: statusRequest.serverExecption,
        error: e.toString(),
      );
    }
  }

  // ================= SELECT ALL =================
  Future<ApiResponse<List<Map<String, dynamic>>>> selectAll({
    required String table,
  }) async {
    try {
      final response = await _client.from(table).select();
      return ApiResponse(
        status: statusRequest.success,
        data: List<Map<String, dynamic>>.from(response),
      );
    } catch (e) {
      return ApiResponse(
        status: statusRequest.serverExecption,
        error: e.toString(),
      );
    }
  }

  // ================= SELECT WHERE =================
  Future<ApiResponse<List<Map<String, dynamic>>>> selectWhere({
    required String table,
    required Map<String, dynamic> match,
    List<String>? notNullColumns,
    Map<String, dynamic>? lessThan, // باراميتر جديد
  }) async {
    try {
      var query = _client.from(table).select().match(_convertMap(match));

      if (notNullColumns != null) {
        for (var column in notNullColumns) {
          query = query.not(column, "is", null);
        }
      }

      if (lessThan != null) {
        lessThan.forEach((column, value) {
          query = query.lt(column, value);
        });
      }

      final response = await query;
      return ApiResponse(
        status: statusRequest.success,
        data: List<Map<String, dynamic>>.from(response),
      );
    } catch (e) {
      return ApiResponse(
        status: statusRequest.serverExecption,
        error: e.toString(),
      );
    }
  }

  // ================= SELECT ONE =================
  Future<ApiResponse<Map<String, dynamic>?>> selectOne({
    required String table,
    required Map<String, dynamic> match,
  }) async {
    try {
      final response = await _client
          .from(table)
          .select()
          .match(_convertMap(match))
          .maybeSingle();
      return ApiResponse(status: statusRequest.success, data: response);
    } catch (e) {
      return ApiResponse(
        status: statusRequest.serverExecption,
        error: e.toString(),
      );
    }
  }
}
