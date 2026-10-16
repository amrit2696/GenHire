import 'package:dio/dio.dart';
import 'package:ghire/core/helper/api_helper.dart';
import 'package:ghire/core/network/api.dart';
import 'package:ghire/modules/dashboard/models/client_option_model.dart';
import 'package:ghire/modules/dashboard/models/dashboard_model.dart';

class DashboardRepository {
  static final Api _api = Api();

  // static const String baseUrl = 'http://171.16.3.49/RMS_api/api';
  // static const String baseUrl = 'https://rms.geniushrtech.com/RMSAPI/api';

  Future<DashboardModel> getDashboard({
    required String token,
    required int recruiterId,
  }) async {
    try {
      final response = await _api.makeRequest.post(
        '/home/view',
        data: {
          'FinYear': '2026-2027',
          'Month': '%',
          'RecruiterId': recruiterId,
          'Op': 1,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      final data = ApiHandler.handleResponse<Map<String, dynamic>>(response);

      return DashboardModel.fromJson(data);
    } catch (error) {
      ApiHandler.handleError(error);
    }
  }

  Future<List<ClientOptionModel>> getClientList({
    required String token,
    required int recruiterId,
  }) async {
    try {
      final response = await _api.makeRequest.post(
        '/home/ddl',
        data: {'Op': '1', 'RecruiterId': recruiterId.toString()},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      final data = ApiHandler.handleResponse<Map<String, dynamic>>(response);

      final rawList = data['Data'];

      if (rawList is! List) {
        return [];
      }

      return rawList
          .map(
            (item) =>
                ClientOptionModel.fromJson(Map<String, dynamic>.from(item)),
          )
          .toList();
    } catch (error) {
      ApiHandler.handleError(error);
    }
  }

  Future<List<ClientOptionModel>> getDropdownList({
    required String token,
    required int recruiterId,
    required int op,
    String clientId = '',
  }) async {
    try {
      final response = await _api.makeRequest.post(
        '/home/ddl',
        data: {
          'Op': op.toString(),
          'RecruiterId': recruiterId.toString(),
          'ClientId': clientId,
          'Param1': '',
          'Param2': '',
          'Param3': '',
          'Param4': '',
          'Param5': '',
          'Param6': '',
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      final data = ApiHandler.handleResponse<Map<String, dynamic>>(response);
      final rawList = data['Data'];

      if (rawList is! List) return [];

      return rawList
          .map(
            (item) =>
                ClientOptionModel.fromJson(Map<String, dynamic>.from(item)),
          )
          .toList();
    } catch (error) {
      ApiHandler.handleError(error);
    }
  }

  //------------------------save job data------------------------------
  // As given. See the note below about the host.
  // static const String saveUrl = 'http://171.16.3.49/RMS_api/api/recruiter/save';

  Future<Map<String, dynamic>> saveMandate({
    required String token,
    required Map<String, dynamic> body,
  }) async {
    try {
      final response = await _api.makeRequest.post(
        '/recruiter/MandateAdd',
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
    }
  }
}
