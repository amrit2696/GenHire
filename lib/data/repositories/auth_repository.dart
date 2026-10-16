import 'package:dio/dio.dart';
import 'package:ghire/core/network/api.dart';
import 'package:ghire/core/network/api_handler.dart';

class AuthRepository {
  static final Api _api = Api();

  // ------------------------------------------------------------
  // Login
  // ------------------------------------------------------------

  static Future<Map<String, dynamic>> loginUser({
    required Map<String, dynamic> body,
  }) async {
    try {
      final response = await _api.makeRequest.post('/auth/login', data: body);

      return ApiHandler.handleResponse<Map<String, dynamic>>(response);
    } catch (error) {
      return ApiHandler.handleError(error);
    }
  }

  // ------------------------------------------------------------
  // Register
  // ------------------------------------------------------------

  static Future<Map<String, dynamic>> registerUser({
    required Map<String, dynamic> body,
  }) async {
    try {
      final response = await _api.makeRequest.post('/auth/signup', data: body);

      return ApiHandler.handleResponse<Map<String, dynamic>>(response);
    } catch (error) {
      return ApiHandler.handleError(error);
    }
  }

  // ------------------------------------------------------------
  // Send OTP
  // ------------------------------------------------------------

  static Future<Map<String, dynamic>> sendOtp({
    required Map<String, dynamic> body,
  }) async {
    try {
      final response = await _api.makeRequest.post('/auth/sendOtp', data: body);

      return ApiHandler.handleResponse<Map<String, dynamic>>(response);
    } catch (error) {
      return ApiHandler.handleError(error);
    }
  }

  // ------------------------------------------------------------
  // Verify OTP
  // ------------------------------------------------------------

  static Future<Map<String, dynamic>> verifyOtp({
    required Map<String, dynamic> body,
  }) async {
    try {
      final response = await _api.makeRequest.post(
        '/auth/verifyOtp',
        data: body,
      );

      return ApiHandler.handleResponse<Map<String, dynamic>>(response);
    } catch (error) {
      return ApiHandler.handleError(error);
    }
  }
}
