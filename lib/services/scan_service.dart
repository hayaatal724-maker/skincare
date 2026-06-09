import 'dart:io';

import '../core/api_client.dart';
import '../models/scan.dart';

/// خدمة الفحوصات — singleton. التحليل وجلب السجل.
class ScanService {
  ScanService._();
  static final ScanService instance = ScanService._();

  final ApiClient _api = ApiClient.instance;

  /// تحليل صورة بشرة. [lat]/[lon] اختياريان (للطقس).
  Future<Scan> analyze(File image, {double? lat, double? lon}) async {
    final fields = <String, String>{};
    if (lat != null) fields['latitude'] = lat.toString();
    if (lon != null) fields['longitude'] = lon.toString();

    final res = await _api.postMultipart('/analyze.php', image: image, fields: fields);
    return Scan.fromJson(Map<String, dynamic>.from(res['scan']));
  }

  /// سجل كل الفحوصات (الأحدث أولاً).
  Future<List<Scan>> getScans() async {
    final res = await _api.get('/scans.php');
    final list = (res['scans'] as List?) ?? [];
    return list
        .map((e) => Scan.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  /// تفاصيل فحص واحد.
  Future<Scan> getScan(int id) async {
    final res = await _api.get('/scans.php?id=$id');
    return Scan.fromJson(Map<String, dynamic>.from(res['scan']));
  }
}
