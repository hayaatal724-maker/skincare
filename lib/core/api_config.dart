/// إعدادات الاتصال بالباك إند (Dermalyze AI / DermAI).
///
/// عنوان الخادم (IP جهاز XAMPP) أصبح قابلاً للضبط من داخل التطبيق
/// عبر شاشة الإعدادات، ويُحفظ تلقائياً (انظر [SettingsService]).
class ApiConfig {
  /// القيمة الافتراضية إن لم يضبط المستخدم شيئاً بعد.
  /// - جهاز Android حقيقي: IPv4 لجهاز XAMPP (شغّل `ipconfig`)، مثل 192.168.1.20
  /// - محاكي Android: 10.0.2.2
  /// - Flutter Web / Chrome: localhost
  /// يمكن أن يتضمن منفذاً عند الحاجة، مثل: 192.168.1.20:8080
  static const String defaultHost = '192.168.1.20';

  /// المضيف الحالي (يُحمَّل من التخزين عند الإقلاع، ويُحدَّث من شاشة الإعدادات).
  static String _host = defaultHost;

  static String get serverHost => _host;
  static set serverHost(String value) {
    final v = value.trim();
    if (v.isNotEmpty) _host = v;
  }

  /// أصل السيرفر (بروتوكول + مضيف).
  static String get serverOrigin => 'http://$_host';

  /// المسار الأساسي لكل نقاط الـ API.
  /// ملاحظة: الباك إند منشور تحت /backend/ (تأكدنا أن http://localhost/backend/ يعمل).
  static String get baseUrl => '$serverOrigin/backend/api';

  /// رابط فحص صحة الخادم (صفحة index.php) — يُستخدم في "اختبار الاتصال".
  static String get healthUrl => '$serverOrigin/backend/';

  /// الباك إند يعيد `image_path` كمسار نسبي (/backend/uploads/..).
  /// هذه الدالة تبني الرابط الكامل لعرض الصورة في التطبيق.
  static String imageUrl(String path) =>
      path.startsWith('http') ? path : '$serverOrigin$path';

  // مهلات الطلبات
  static const Duration requestTimeout = Duration(seconds: 30);
  static const Duration analyzeTimeout = Duration(seconds: 90); // التحليل أبطأ
}
