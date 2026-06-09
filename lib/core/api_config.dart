/// إعدادات الاتصال بالباك إند (Dermalyze AI / DermAI).
///
/// ★★★ المكان الوحيد الذي تحتاج تغييره عند نقل المشروع لجهاز آخر ★★★
/// ضع هنا عنوان IP الخاص بجهاز XAMPP على الشبكة المحلية.
class ApiConfig {
  /// عنوان جهاز XAMPP على الشبكة.
  /// - جهاز Android حقيقي: ضع IPv4 لجهاز XAMPP (شغّل `ipconfig` على ويندوز)، مثل 192.168.1.20
  /// - محاكي Android: استخدم 10.0.2.2
  /// - Flutter Web / Chrome: استخدم localhost
  static const String serverHost = '192.168.1.20';

  /// أصل السيرفر (بروتوكول + مضيف).
  static const String serverOrigin = 'http://$serverHost';

  /// المسار الأساسي لكل نقاط الـ API.
  /// ملاحظة: الباك إند منشور تحت /backend/ (تأكدنا أن http://localhost/backend/ يعمل).
  static const String baseUrl = '$serverOrigin/backend/api';

  /// الباك إند يعيد `image_path` كمسار نسبي (/backend/uploads/..).
  /// هذه الدالة تبني الرابط الكامل لعرض الصورة في التطبيق.
  static String imageUrl(String path) =>
      path.startsWith('http') ? path : '$serverOrigin$path';

  // مهلات الطلبات
  static const Duration requestTimeout = Duration(seconds: 30);
  static const Duration analyzeTimeout = Duration(seconds: 90); // التحليل أبطأ
}
