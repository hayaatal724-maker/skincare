import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../core/api_config.dart';
import '../../core/app_theme.dart';
import '../../models/scan.dart';
import '../../routes.dart';
import '../../services/scan_service.dart';

class HistoryScreen extends StatefulWidget {
  /// عند true تُعرض داخل التبويب السفلي (بدون زر رجوع).
  final bool embedded;
  const HistoryScreen({super.key, this.embedded = false});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late Future<List<Scan>> _future;

  @override
  void initState() {
    super.initState();
    _future = ScanService.instance.getScans();
  }

  Future<void> _refresh() async {
    setState(() => _future = ScanService.instance.getScans());
    await _future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: !widget.embedded,
        foregroundColor: AppColors.onSurface,
        title: Text('سجل الفحوصات',
            style: GoogleFonts.notoSansArabic(fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: FutureBuilder<List<Scan>>(
          future: _future,
          builder: (context, snap) {
            if (snap.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator(color: AppColors.primary));
            }
            if (snap.hasError) {
              return _message(Icons.error_outline, 'تعذّر تحميل السجل', '${snap.error}');
            }
            final scans = snap.data ?? [];
            if (scans.isEmpty) {
              return _message(Icons.history, 'لا توجد فحوصات بعد',
                  'ابدأ بأول تحليل لبشرتك من الشاشة الرئيسية.');
            }
            return RefreshIndicator(
              onRefresh: _refresh,
              child: ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: scans.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) => _scanCard(scans[i]),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _scanCard(Scan scan) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => Navigator.pushNamed(context, Routes.result, arguments: scan),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.outlineVariant.withOpacity(0.4)),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: scan.imagePath.isEmpty
                  ? _thumbPlaceholder()
                  : Image.network(
                      ApiConfig.imageUrl(scan.imagePath),
                      width: 64, height: 64, fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _thumbPlaceholder(),
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(scan.condition,
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.notoSansArabic(
                          fontWeight: FontWeight.bold, color: AppColors.onSurface, fontSize: 15)),
                  const SizedBox(height: 4),
                  Text(_formatDate(scan.scanDate),
                      style: GoogleFonts.notoSansArabic(
                          color: AppColors.onSurfaceVariant, fontSize: 12)),
                ],
              ),
            ),
            if (scan.confidencePercent != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('${scan.confidencePercent!.toStringAsFixed(0)}%',
                    style: GoogleFonts.notoSansArabic(
                        color: AppColors.onPrimaryContainer, fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_left, color: AppColors.onSurfaceVariant),
          ],
        ),
      ),
    );
  }

  Widget _thumbPlaceholder() => Container(
        width: 64, height: 64,
        color: AppColors.surfaceContainerLow,
        child: const Icon(Icons.image_outlined, color: AppColors.onSurfaceVariant),
      );

  String _formatDate(String? raw) {
    if (raw == null) return '';
    final dt = DateTime.tryParse(raw);
    if (dt == null) return raw;
    return DateFormat('yyyy/MM/dd – HH:mm', 'ar').format(dt);
  }

  Widget _message(IconData icon, String title, String sub) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: AppColors.primary.withOpacity(0.5)),
            const SizedBox(height: 16),
            Text(title,
                style: GoogleFonts.notoSansArabic(
                    fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
            const SizedBox(height: 8),
            Text(sub,
                textAlign: TextAlign.center,
                style: GoogleFonts.notoSansArabic(color: AppColors.onSurfaceVariant, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
