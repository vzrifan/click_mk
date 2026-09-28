import 'package:dio/dio.dart';

class ApiException implements Exception {
  const ApiException({required this.message, this.statusCode, this.code});

  final String message;
  final int? statusCode;
  final String? code;

  factory ApiException.fromDioException(DioException exception) {
    final response = exception.response;

    if (response != null) {
      final statusCode = response.statusCode;
      final message = _extractMessage(response.data);

      return ApiException(
        message: message,
        statusCode: statusCode,
        code: exception.type.name,
      );
    }

    return ApiException(
      message: _messageFromDioException(exception),
      code: exception.type.name,
    );
  }

  static String _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      final message = data['message'];

      if (message is String && message.isNotEmpty) {
        return message;
      }

      final error = data['error'];

      if (error is String && error.isNotEmpty) {
        return error;
      }
    }

    return 'Terjadi kesalahan pada server.';
  }

  static String _messageFromDioException(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Koneksi ke server timeout.';

      case DioExceptionType.connectionError:
        return 'Tidak dapat terhubung ke server.';

      case DioExceptionType.cancel:
        return 'Permintaan dibatalkan.';

      case DioExceptionType.badCertificate:
        return 'Sertifikat server tidak valid.';

      case DioExceptionType.badResponse:
        return 'Server mengembalikan respons yang tidak valid.';

      case DioExceptionType.unknown:
        return 'Terjadi kesalahan yang tidak diketahui.';

      case DioExceptionType.transformTimeout:
        return 'Terjadi kesalahan saat memproses data dari server.';
    }
  }

  @override
  String toString() {
    return 'ApiException('
        'message: $message, '
        'statusCode: $statusCode, '
        'code: $code'
        ')';
  }
}
