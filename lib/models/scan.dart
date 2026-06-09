/// نموذج الفحص.
///
/// ★ نقطة مهمة: الباك إند يعيد الفحص بشكلين مختلفين:
///  - analyze.php  (متداخل): condition / confidence / consultation + weather:{...}
///  - scans.php    (صفوف DB مسطّحة): cv_detected_condition / cv_confidence_score /
///                  nlp_consultation_text + الحقول temperature/humidity/.. على المستوى الأعلى
/// لذلك fromJson يقرأ كلا الاسمين.
class Scan {
  final int id;
  final String imagePath;
  final String? scanDate;
  final String condition;
  final double? confidence;
  final String consultation;

  // بيانات الطقس
  final double? temperature;
  final double? humidity;
  final double? uvIndex;
  final String? weatherDescription;

  const Scan({
    required this.id,
    required this.imagePath,
    this.scanDate,
    required this.condition,
    this.confidence,
    required this.consultation,
    this.temperature,
    this.humidity,
    this.uvIndex,
    this.weatherDescription,
  });

  bool get hasWeather => temperature != null || weatherDescription != null;

  /// نسبة الثقة كنسبة مئوية (0..100) أو null.
  double? get confidencePercent =>
      confidence == null ? null : (confidence! * 100);

  factory Scan.fromJson(Map<String, dynamic> j) {
    // الطقس قد يكون متداخلاً تحت weather أو مسطّحاً على المستوى الأعلى.
    final Map<String, dynamic> w =
        (j['weather'] is Map) ? Map<String, dynamic>.from(j['weather']) : j;

    return Scan(
      id: (j['id'] as num?)?.toInt() ?? 0,
      imagePath: (j['image_path'] ?? '').toString(),
      scanDate: j['scan_date']?.toString(),
      condition:
          (j['condition'] ?? j['cv_detected_condition'] ?? 'غير محدد').toString(),
      confidence: _toDouble(j['confidence'] ?? j['cv_confidence_score']),
      consultation:
          (j['consultation'] ?? j['nlp_consultation_text'] ?? '').toString(),
      temperature: _toDouble(w['temperature']),
      humidity: _toDouble(w['humidity']),
      uvIndex: _toDouble(w['uv_index']),
      weatherDescription:
          (w['description'] ?? j['weather_description'])?.toString(),
    );
  }

  static double? _toDouble(dynamic v) {
    if (v == null) return null;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString());
  }
}
