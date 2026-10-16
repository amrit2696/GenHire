import 'package:dio/dio.dart';
import 'package:ghire/core/helper/api_helper.dart';
import 'package:ghire/core/network/api.dart';

class JobDetailsRepo {
  static final Api _api = Api();
  // late final Dio _dio;

  //---------------------------------------
  // final Dio _dio = Dio(
  //   BaseOptions(
  //     baseUrl: 'http://171.16.3.49/RMS_api/api',
  //     connectTimeout: const Duration(seconds: 30),
  //     receiveTimeout: const Duration(seconds: 30),
  //     sendTimeout: const Duration(seconds: 30),
  //     headers: {
  //       'Content-Type': Headers.jsonContentType,
  //       'Accept': Headers.jsonContentType,
  //     },
  //   ),
  // );

  // Future<Map<String, dynamic>> saveSelection({
  //   required String token,
  //   required Map<String, dynamic> body,
  // }) async {
  //   try {
  //     final response = await _dio.post<Map<String, dynamic>>(
  //       '/recruiter/SelectionAdd',
  //       data: body,
  //       options: Options(
  //         headers: {
  //           'Authorization': 'Bearer $token',
  //           'Content-Type': Headers.jsonContentType,
  //           'Accept': Headers.jsonContentType,
  //         },
  //       ),
  //     );

  //     return ApiHandler.handleResponse<Map<String, dynamic>>(response);
  //   } on DioException catch (error) {
  //     ApiHandler.handleError(error);
  //     rethrow;
  //   } catch (error) {
  //     rethrow;
  //   }
  // }
  //---------------------------------------

  Future<Map<String, dynamic>> saveSelection({
    required String token,
    required Map<String, dynamic> body,
  }) async {
    try {
      // final response = await _dio.post(
      // 'http://171.16.3.49/RMS_api/recruiter/SelectionAdd',
      final response = await _api.makeRequest.post(
        '/recruiter/SelectionAdd',
        data: body,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      return ApiHandler.handleResponse<Map<String, dynamic>>(response);
    } catch (error) {
      ApiHandler.handleError(error);
      rethrow;
    }
  }
}
