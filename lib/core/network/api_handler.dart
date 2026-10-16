import 'package:dio/dio.dart';
import 'package:ghire/core/helper/popup_helper.dart';

class ApiHandler {
  static T handleResponse<T>(Response response) {
    final responseData = response.data;

    if (responseData is! Map) {
      throw Exception('Invalid server response');
    }

    final data = Map<String, dynamic>.from(responseData);

    final message = data['Message'] ?? data['message'];

    if (message != null && message.toString().isNotEmpty) {
      PopupHelper.success(message.toString());
    }

    return data as T;
  }

  static Never handleError(dynamic error) {
    if (error is DioException) {
      final data = error.response?.data;

      if (data is Map) {
        final message = data['Message'] ?? data['message'];

        PopupHelper.error(message?.toString() ?? 'Something went wrong');
      } else {
        PopupHelper.error(error.message ?? 'Something went wrong');
      }
    } else {
      PopupHelper.error(error.toString());
    }

    throw error;
  }
}
