import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'api_config.dart';

/// استثناء موحّد لأخطاء الـ API (يحمل رسالة عربية جاهزة للعرض).
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final bool isUnauthorized;
  ApiException(this.message, {this.statusCode, this.isUnauthorized = false});

  @override
  String toString() => message;
}

/// عميل HTTP موحّد — singleton.
/// يدير توكن الجلسة، يرفقه تلقائياً، ويوحّد قراءة ردود الباك إند
/// التي تأتي دائماً بالشكل: { success, message, ...data }.
class ApiClient {
  ApiClient._();
  static final ApiClient instance = ApiClient._();

  static const _tokenKey = 'auth_token';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// يُستدعى عند انتهاء/بطلان التوكن (401) كي يعيد التطبيق المستخدم لشاشة الدخول.
  void Function()? onUnauthorized;

  String? _cachedToken;

  // ---------- إدارة التوكن ----------
  Future<String?> getToken() async {
    _cachedToken ??= await _storage.read(key: _tokenKey);
    return _cachedToken;
  }

  Future<void> saveToken(String token) async {
    _cachedToken = token;
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<void> clearToken() async {
    _cachedToken = null;
    await _storage.delete(key: _tokenKey);
  }

  Future<Map<String, String>> _headers({bool json = true, bool auth = true}) async {
    final h = <String, String>{'Accept': 'application/json'};
    if (json) h['Content-Type'] = 'application/json';
    if (auth) {
      final t = await getToken();
      if (t != null) h['Authorization'] = 'Bearer $t';
    }
    return h;
  }

  Uri _uri(String path) => Uri.parse('${ApiConfig.baseUrl}$path');

  // ---------- الطلبات ----------
  Future<Map<String, dynamic>> postJson(
    String path,
    Map<String, dynamic> body, {
    bool auth = false,
  }) async {
    try {
      final res = await http
          .post(_uri(path), headers: await _headers(auth: auth), body: jsonEncode(body))
          .timeout(ApiConfig.requestTimeout);
      return _process(res);
    } on SocketException {
      throw ApiException('تعذّر الاتصال بالسيرفر. تأكد من تشغيل XAMPP ومن صحة عنوان IP.');
    } on HttpException {
      throw ApiException('خطأ في الاتصال بالشبكة.');
    } on FormatException {
      throw ApiException('رد غير متوقع من السيرفر.');
    }
  }

  Future<Map<String, dynamic>> get(String path) async {
    try {
      final res = await http
          .get(_uri(path), headers: await _headers(json: false))
          .timeout(ApiConfig.requestTimeout);
      return _process(res);
    } on SocketException {
      throw ApiException('تعذّر الاتصال بالسيرفر. تأكد من تشغيل XAMPP ومن صحة عنوان IP.');
    }
  }

  /// رفع صورة (multipart). الحقل اسمه `image` بالضبط كما يتوقّع الباك إند.
  Future<Map<String, dynamic>> postMultipart(
    String path, {
    required File image,
    Map<String, String> fields = const {},
  }) async {
    try {
      final req = http.MultipartRequest('POST', _uri(path));
      final t = await getToken();
      if (t != null) req.headers['Authorization'] = 'Bearer $t';
      req.fields.addAll(fields);
      req.files.add(await http.MultipartFile.fromPath('image', image.path));

      final streamed = await req.send().timeout(ApiConfig.analyzeTimeout);
      final res = await http.Response.fromStream(streamed);
      return _process(res);
    } on SocketException {
      throw ApiException('تعذّر الاتصال بالسيرفر. تأكد من تشغيل XAMPP ومن صحة عنوان IP.');
    }
  }

  // ---------- توحيد معالجة الرد ----------
  Map<String, dynamic> _process(http.Response res) {
    if (res.statusCode == 401) {
      clearToken();
      onUnauthorized?.call();
      throw ApiException('انتهت الجلسة، يرجى تسجيل الدخول من جديد.',
          statusCode: 401, isUnauthorized: true);
    }

    Map<String, dynamic> body;
    try {
      body = jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;
    } catch (_) {
      throw ApiException('رد غير صالح من السيرفر (${res.statusCode}).',
          statusCode: res.statusCode);
    }

    final success = body['success'] == true;
    if (!success || res.statusCode >= 400) {
      throw ApiException(
        (body['message'] ?? 'حدث خطأ غير متوقع.').toString(),
        statusCode: res.statusCode,
      );
    }
    return body;
  }
}
