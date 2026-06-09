import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../../core/api_config.dart';
import '../../core/app_theme.dart';
import '../../core/settings_service.dart';

/// شاشة إعدادات الخادم: يدخل المستخدم IP جهاز XAMPP، يختبر الاتصال، ثم يحفظ.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final TextEditingController _controller =
      TextEditingController(text: ApiConfig.serverHost);

  bool _testing = false;
  bool _saving = false;
  // نتيجة الاختبار: null = لم يُختبر، true = نجح، false = فشل
  bool? _testOk;
  String _testMessage = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get _host => _controller.text.trim();

  Future<void> _testConnection() async {
    if (_host.isEmpty) {
      setState(() {
        _testOk = false;
        _testMessage = 'أدخل عنوان الخادم أولاً.';
      });
      return;
    }
    setState(() {
      _testing = true;
      _testOk = null;
      _testMessage = '';
    });
    try {
      final res = await http
          .get(Uri.parse('http://$_host/backend/'))
          .timeout(const Duration(seconds: 10));
      final body = jsonDecode(utf8.decode(res.bodyBytes));
      if (res.statusCode == 200 && body is Map && body['success'] == true) {
        setState(() {
          _testOk = true;
          _testMessage = 'الاتصال ناجح ✅  (${body['api'] ?? 'الـ API يعمل'})';
        });
      } else {
        setState(() {
          _testOk = false;
          _testMessage = 'استجاب الخادم لكن بشكل غير متوقع (كود ${res.statusCode}).';
        });
      }
    } on SocketException {
      setState(() {
        _testOk = false;
        _testMessage = 'تعذّر الوصول للخادم. تأكد من تشغيل XAMPP ومن أنك على نفس الشبكة.';
      });
    } on FormatException {
      setState(() {
        _testOk = false;
        _testMessage = 'وصل ردّ لكنه ليس بصيغة JSON. تحقق من المسار /backend/.';
      });
    } catch (e) {
      setState(() {
        _testOk = false;
        _testMessage = 'فشل الاختبار: $e';
      });
    } finally {
      if (mounted) setState(() => _testing = false);
    }
  }

  Future<void> _save() async {
    if (_host.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('أدخل عنوان الخادم أولاً.'), backgroundColor: AppColors.primary),
      );
      return;
    }
    setState(() => _saving = true);
    await SettingsService.instance.saveHost(_host);
    if (!mounted) return;
    setState(() => _saving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم حفظ عنوان الخادم.'), backgroundColor: Colors.green),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.onSurface,
        title: Text('إعدادات الخادم',
            style: GoogleFonts.notoSansArabic(fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.dns_outlined, color: AppColors.primary, size: 28),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text('عنوان جهاز XAMPP',
                        style: GoogleFonts.notoSansArabic(
                            fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'أدخل عنوان IP للجهاز الذي يعمل عليه الخادم (XAMPP) على نفس الشبكة. '
                'مثال: 192.168.1.20 — وللمحاكي استخدم 10.0.2.2.',
                style: GoogleFonts.notoSansArabic(
                    color: AppColors.onSurfaceVariant, fontSize: 13, height: 1.7),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: _controller,
                keyboardType: TextInputType.url,
                textAlign: TextAlign.left,
                textDirection: TextDirection.ltr,
                style: GoogleFonts.robotoMono(color: AppColors.onSurface),
                decoration: InputDecoration(
                  labelText: 'IP / المضيف',
                  hintText: '192.168.1.20',
                  prefixIcon: const Icon(Icons.lan_outlined),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: AppColors.outlineVariant.withOpacity(0.4)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: AppColors.outlineVariant.withOpacity(0.4)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppColors.primary, width: 2),
                  ),
                ),
                onChanged: (_) {
                  if (_testOk != null) setState(() => _testOk = null);
                },
              ),
              const SizedBox(height: 8),
              Text('سيتصل التطبيق بـ:  ${'http://'}$_host/backend/api',
                  style: GoogleFonts.robotoMono(
                      color: AppColors.onSurfaceVariant, fontSize: 11)),
              const SizedBox(height: 20),

              // نتيجة الاختبار
              if (_testOk != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: (_testOk! ? Colors.green : AppColors.error).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: (_testOk! ? Colors.green : AppColors.error).withOpacity(0.4)),
                  ),
                  child: Row(
                    children: [
                      Icon(_testOk! ? Icons.check_circle_outline : Icons.error_outline,
                          color: _testOk! ? Colors.green : AppColors.error),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(_testMessage,
                            style: GoogleFonts.notoSansArabic(
                                color: AppColors.onSurface, fontSize: 13, height: 1.6)),
                      ),
                    ],
                  ),
                ),

              OutlinedButton.icon(
                onPressed: _testing ? null : _testConnection,
                icon: _testing
                    ? const SizedBox(
                        width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.wifi_tethering),
                label: Text(_testing ? 'جاري الاختبار...' : 'اختبار الاتصال',
                    style: GoogleFonts.notoSansArabic()),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  minimumSize: const Size(double.infinity, 52),
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: _saving ? null : _save,
                icon: const Icon(Icons.save_outlined),
                label: Text('حفظ',
                    style: GoogleFonts.notoSansArabic(fontWeight: FontWeight.bold)),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
