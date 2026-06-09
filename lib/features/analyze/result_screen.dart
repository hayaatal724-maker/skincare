import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/api_config.dart';
import '../../core/app_theme.dart';
import '../../models/scan.dart';
import '../../routes.dart';

class ResultScreen extends StatelessWidget {
  final Scan scan;
  const ResultScreen({super.key, required this.scan});

  @override
  Widget build(BuildContext context) {
    final pct = scan.confidencePercent;
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.onSurface,
        title: Text('نتيجة التحليل',
            style: GoogleFonts.notoSansArabic(fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // الصورة
              if (scan.imagePath.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.network(
                    ApiConfig.imageUrl(scan.imagePath),
                    width: double.infinity,
                    height: 220,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 220,
                      color: AppColors.surfaceContainerLow,
                      child: const Icon(Icons.broken_image_outlined, size: 48),
                    ),
                  ),
                ),
              const SizedBox(height: 24),

              // الحالة + الثقة
              Text('الحالة المرجّحة',
                  style: GoogleFonts.notoSansArabic(
                      color: AppColors.onSurfaceVariant, fontSize: 14)),
              const SizedBox(height: 4),
              Text(scan.condition,
                  style: GoogleFonts.notoSansArabic(
                      fontSize: 26, fontWeight: FontWeight.w900, color: AppColors.primary)),
              const SizedBox(height: 16),

              if (pct != null) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('درجة الثقة',
                        style: GoogleFonts.notoSansArabic(
                            color: AppColors.onSurfaceVariant, fontSize: 13)),
                    Text('${pct.toStringAsFixed(0)}%',
                        style: GoogleFonts.notoSansArabic(
                            fontWeight: FontWeight.bold, color: AppColors.onSurface)),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: (pct / 100).clamp(0, 1),
                    minHeight: 10,
                    backgroundColor: AppColors.primaryContainer.withOpacity(0.4),
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // بطاقة الطقس
              if (scan.hasWeather) _weatherCard(),

              // الاستشارة
              Text('الاستشارة',
                  style: GoogleFonts.notoSansArabic(
                      fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  scan.consultation.isEmpty ? 'لا توجد استشارة متاحة.' : scan.consultation,
                  style: GoogleFonts.notoSansArabic(
                      color: AppColors.onSurface, fontSize: 15, height: 1.8),
                ),
              ),
              const SizedBox(height: 16),
              Text('⚠️ هذا التحليل لأغراض تعليمية ولا يغني عن استشارة طبيب مختص.',
                  style: GoogleFonts.notoSansArabic(
                      color: AppColors.onSurfaceVariant, fontSize: 12, height: 1.6)),
              const SizedBox(height: 24),

              FilledButton(
                onPressed: () =>
                    Navigator.pushNamedAndRemoveUntil(context, Routes.home, (_) => false),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size(double.infinity, 54),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text('العودة للرئيسية',
                    style: GoogleFonts.notoSansArabic(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _weatherCard() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.tertiaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.wb_sunny_outlined, color: AppColors.onTertiaryContainer),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('بيانات الطقس وقت الفحص',
                    style: GoogleFonts.notoSansArabic(
                        fontWeight: FontWeight.bold, color: AppColors.onTertiaryContainer, fontSize: 13)),
                const SizedBox(height: 4),
                Text(_weatherText(),
                    style: GoogleFonts.notoSansArabic(
                        color: AppColors.onSurfaceVariant, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _weatherText() {
    final parts = <String>[];
    if (scan.temperature != null) parts.add('الحرارة ${scan.temperature!.toStringAsFixed(0)}°م');
    if (scan.humidity != null) parts.add('الرطوبة ${scan.humidity!.toStringAsFixed(0)}%');
    if (scan.weatherDescription != null) parts.add(scan.weatherDescription!);
    return parts.isEmpty ? 'غير متوفرة' : parts.join(' • ');
  }
}
