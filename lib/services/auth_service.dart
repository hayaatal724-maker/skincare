import 'package:flutter/foundation.dart';

import '../core/api_client.dart';
import '../models/user.dart';

/// خدمة المصادقة — singleton.
/// تدير التسجيل/الدخول/الخروج وتخزين التوكن والمستخدم الحالي.
/// [isLoggedIn] يستخدمه AuthGate للتبديل بين Welcome و Home بدون حزمة state.
class AuthService {
  AuthService._() {
    // عند بطلان التوكن (401) سجّل الخروج محلياً تلقائياً.
    ApiClient.instance.onUnauthorized = _onUnauthorized;
  }
  static final AuthService instance = AuthService._();

  final ApiClient _api = ApiClient.instance;

  User? currentUser;
  final ValueNotifier<bool> isLoggedIn = ValueNotifier<bool>(false);

  void _onUnauthorized() {
    currentUser = null;
    isLoggedIn.value = false;
  }

  /// تسجيل الدخول.
  Future<void> login(String email, String password) async {
    final res = await _api.postJson('/login.php', {
      'email': email.trim(),
      'password': password,
    });
    await _saveSession(res);
  }

  /// إنشاء حساب جديد.
  Future<void> register({
    required String fullName,
    required String email,
    required String password,
    String? skinType,
  }) async {
    final res = await _api.postJson('/register.php', {
      'full_name': fullName.trim(),
      'email': email.trim(),
      'password': password,
      if (skinType != null && skinType.isNotEmpty) 'skin_type': skinType,
    });
    await _saveSession(res);
  }

  Future<void> _saveSession(Map<String, dynamic> res) async {
    final token = res['token']?.toString();
    if (token != null) await _api.saveToken(token);
    if (res['user'] is Map) {
      currentUser = User.fromJson(Map<String, dynamic>.from(res['user']));
    }
    isLoggedIn.value = true;
  }

  /// تسجيل الخروج (يحاول إبلاغ السيرفر ثم يمسح محلياً على كل حال).
  Future<void> logout() async {
    try {
      await _api.postJson('/logout.php', {}, auth: true);
    } catch (_) {
      // نتجاهل أخطاء السيرفر — المهم المسح المحلي.
    }
    await _api.clearToken();
    currentUser = null;
    isLoggedIn.value = false;
  }

  /// محاولة دخول تلقائي عند الإقلاع: إن وُجد توكن صالح نجلب الملف الشخصي.
  Future<bool> tryAutoLogin() async {
    final token = await _api.getToken();
    if (token == null) return false;
    try {
      final res = await _api.get('/profile.php');
      if (res['user'] is Map) {
        currentUser = User.fromJson(Map<String, dynamic>.from(res['user']));
      }
      isLoggedIn.value = true;
      return true;
    } catch (_) {
      await _api.clearToken();
      isLoggedIn.value = false;
      return false;
    }
  }

  /// تحديث الملف الشخصي.
  Future<void> updateProfile({required String fullName, String? skinType}) async {
    final res = await _api.postJson('/profile.php', {
      'full_name': fullName.trim(),
      'skin_type': skinType ?? '',
    }, auth: true);
    if (res['user'] is Map) {
      currentUser = User.fromJson(Map<String, dynamic>.from(res['user']));
    }
  }

  /// جلب الملف الشخصي (مع عدد الفحوصات).
  Future<User> fetchProfile() async {
    final res = await _api.get('/profile.php');
    final user = User.fromJson(Map<String, dynamic>.from(res['user']));
    currentUser = user;
    return user;
  }
}
