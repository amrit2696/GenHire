import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class Api {
  static final Api _instance = Api._internal();

  late final Dio _dio;

  factory Api() {
    return _instance;
  }

  Api._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'http://171.16.3.49/RMS_api/api',
        // baseUrl: 'https://rms.geniushrtech.com/RMSAPI/api',

        // baseUrl: 'http://171.16.3.49/RMS_api/api',
        // connectTimeout: const Duration(seconds: 30),
        // receiveTimeout: const Duration(seconds: 30),
        // sendTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: false,
      ),
    );
  }

  Dio get makeRequest => _dio;
}
