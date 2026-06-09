import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/api_client.dart';
import '../../core/app_theme.dart';
import '../../routes.dart';
import '../../services/scan_service.dart';

/// شاشة التحميل أثناء استدعاء /analyze.php — ثم تنتقل لشاشة النتيجة.
class AnalyzingScreen extends StatefulWidget {
  final File image;
  final double? latitude;
  final double? longitude;

  const AnalyzingScreen({
    super.key,
    required this.image,
    this.latitude,
    this.longitude,
  });

  @override
  State<AnalyzingScreen> createState() => _AnalyzingScreenState();
}

class _AnalyzingScreenState extends State<AnalyzingScreen> {
  String? _error;

  @override
  void initState() {
    super.initState();
    _run();
  }

  Future<void> _run() async {
    try {
      final scan = await ScanService.instance.analyze(
        widget.image,
        lat: widget.latitude,
        lon: widget.longitude,
      );
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, Routes.result, arguments: scan);
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } catch (_) {
      if (mounted) setState(() => _error = 'حدث خطأ أثناء التحليل. حاول مجدداً.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: _error == null ? _loading() : _errorView(),
        ),
      ),
    );
  }

  Widget _loading() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CircularProgressIndicator(color: AppColors.primary),
        const SizedBox(height: 32),
        Text('جاري تحليل بشرتك...',
            style: GoogleFonts.notoSansArabic(
                fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
        const SizedBox(height: 12),
        Text('يقوم الذكاء الاصطناعي بفحص الصورة ودمج بيانات الطقس لإعداد استشارتك. قد يستغرق هذا بضع ثوانٍ.',
            textAlign: TextAlign.center,
            style: GoogleFonts.notoSansArabic(
                color: AppColors.onSurfaceVariant, fontSize: 14, height: 1.6)),
      ],
    );
  }

  Widget _errorView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.error_outline, size: 64, color: AppColors.error),
        const SizedBox(height: 16),
        Text('تعذّر إكمال التحليل',
            style: GoogleFonts.notoSansArabic(
                fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
        const SizedBox(height: 8),
        Text(_error!,
            textAlign: TextAlign.center,
            style: GoogleFonts.notoSansArabic(color: AppColors.onSurfaceVariant, fontSize: 14)),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('رجوع', style: GoogleFonts.notoSansArabic()),
            ),
            const SizedBox(width: 12),
            FilledButton(
              onPressed: () {
                setState(() => _error = null);
                _run();
              },
              style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
              child: Text('إعادة المحاولة', style: GoogleFonts.notoSansArabic()),
            ),
          ],
        ),
      ],
    );
  }
}
