import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'api_config.dart';

/// يحفظ ويستعيد عنوان خادم XAMPP (المضيف/IP) الذي يضبطه المستخدم من شاشة الإعدادات.
class SettingsService {
  SettingsService._();
  static final SettingsService instance = SettingsService._();

  static const _hostKey = 'server_host';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// يُستدعى مرة عند إقلاع التطبيق لتحميل المضيف المحفوظ إلى [ApiConfig].
  Future<void> load() async {
    try {
      final saved = await _storage.read(key: _hostKey);
      if (saved != null && saved.trim().isNotEmpty) {
        ApiConfig.serverHost = saved.trim();
      }
    } catch (_) {
      // في حال فشل التخزين الآمن نكمل بالقيمة الافتراضية.
    }
  }

  /// يحفظ المضيف الجديد ويطبّقه فوراً على [ApiConfig].
  Future<void> saveHost(String host) async {
    final value = host.trim();
    ApiConfig.serverHost = value;
    await _storage.write(key: _hostKey, value: value);
  }
}
