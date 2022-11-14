import 'dart:convert';

class WebViewMacOSException implements Exception {
  String code;
  String message;
  Object? details;

  WebViewMacOSException({
    this.code = "",
    this.message = "",
    this.details,
  });

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'message': message,
      'details': details,
    };
  }

  factory WebViewMacOSException.fromMap(Map<String, dynamic> map) {
    return WebViewMacOSException(
      code: map['code'] ?? '',
      message: map['message'] ?? '',
      details: map['details'],
    );
  }

  String toJson() => json.encode(toMap());
}
