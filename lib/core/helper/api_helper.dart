import 'package:dio/dio.dart';
import 'package:ghire/core/helper/popup_helper.dart';

class ApiHandler {
  static T handleResponse<T>(Response response) {
    final data = Map<String, dynamic>.from(response.data);

    final message = data['message'];

    if (message != null && message.toString().isNotEmpty) {
      PopupHelper.success(message);
    }

    return data as T;
  }

  static Never handleError(dynamic error) {
    if (error is DioException) {
      final data = error.response?.data;

      if (data is Map<String, dynamic>) {
        PopupHelper.error(data['message'] ?? 'Something went wrong');
      } else {
        PopupHelper.error(error.message ?? 'Something went wrong');
      }
    } else {
      PopupHelper.error(error.toString());
    }

    throw error;
  }
}
