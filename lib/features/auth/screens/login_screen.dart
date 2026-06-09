import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/api_client.dart';
import '../../../routes.dart';
import '../../../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false;
  bool _loading = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // 🎨 الألوان
  final Color surfaceColor = const Color(0xFFFFFbFA);
  final Color primaryColor = const Color(0xFF9C4250);
  final Color primaryContainer = const Color(0xFFFFD9DE);
  final Color onPrimaryFixedVariant = const Color(0xFF7D2B3A);
  final Color tertiaryColor = const Color(0xFF775930);
  final Color onSurface = const Color(0xFF201A1B);
  final Color onSurfaceVariant = const Color(0xFF534345);
  final Color outlineVariant = const Color(0xFFD8C2C4);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      _showError('يرجى إدخال البريد وكلمة المرور.');
      return;
    }
    setState(() => _loading = true);
    try {
      await AuthService.instance.login(email, password);
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, Routes.home, (_) => false);
    } on ApiException catch (e) {
      _showError(e.message);
    } catch (_) {
      _showError('حدث خطأ غير متوقع. حاول مجدداً.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: primaryColor),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool isDesktop = size.width > 900;

    return Scaffold(
      backgroundColor: surfaceColor,
      body: Stack(
        children: [
          if (isDesktop)
            Positioned(
              top: 0,
              left: 0,
              bottom: 0,
              width: size.width / 2,
              child: Opacity(
                opacity: 0.2,
                child: ColorFiltered(
                  colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.saturation),
                  child: Image.network(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuBB7A8TMDEs3By19Ua8QG_57lT9K1TbySYXEVm_NYUt2BCy95pA2iuNIKS3JvsMzvllNBGcUVUW1TMwEseCvkwi9jR_5FTe1KwMmoz89xdPG_uuutfbFpHsQ9r55a5ElLWVBrDsuhz_mGTkJu-E4rq11wSR9xZkiLewtTQRAd0oesWCQI6NXjNe3_Gb0dhiR3CFFIEPClZNBLWu0J6qnC5VPopl6cSXwtO6JyHBNTXLbLNMVSRYSAkGr84nQNpu4A1QL62qF-pwzzU',
                    fit: BoxFit.cover,
                    color: surfaceColor,
                    colorBlendMode: BlendMode.multiply,
                    errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                  ),
                ),
              ),
            ),

          // الدوائر الضبابية
          Positioned(
            top: -size.width * 0.1,
            left: -size.width * 0.05,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
              child: Container(
                width: size.width * 0.4,
                height: size.width * 0.4,
                decoration: BoxDecoration(color: primaryColor.withOpacity(0.05), shape: BoxShape.circle),
              ),
            ),
          ),
          Positioned(
            bottom: -size.width * 0.1,
            right: -size.width * 0.05,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
              child: Container(
                width: size.width * 0.3,
                height: size.width * 0.3,
                decoration: BoxDecoration(color: tertiaryColor.withOpacity(0.05), shape: BoxShape.circle),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                _buildHeader(isDesktop),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: size.height - 100),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 24),
                          SizedBox(
                            width: 1200,
                            child: isDesktop
                                ? Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 48),
                                          child: _buildEditorialContent(),
                                        ),
                                      ),
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: _buildLoginCard(isDesktop),
                                        ),
                                      ),
                                    ],
                                  )
                                : Center(child: _buildLoginCard(isDesktop)),
                          ),
                          const SizedBox(height: 48),
                          _buildFooter(isDesktop),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isDesktop) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.medical_services_outlined, color: primaryColor, size: 32),
              const SizedBox(width: 8),
              Text(
                'DermAI',
                style: GoogleFonts.notoSansArabic(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: primaryColor,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          if (isDesktop)
            Text(
              'وصول سريري آمن',
              style: GoogleFonts.notoSansArabic(
                color: onSurfaceVariant,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEditorialContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(color: primaryContainer, borderRadius: BorderRadius.circular(24)),
          child: Text(
            'ذكاء اصطناعي متقدم للأمراض الجلدية',
            style: GoogleFonts.notoSansArabic(
              color: onPrimaryFixedVariant,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'رعاية دقيقة لصحة بشرتك.',
          style: GoogleFonts.notoSansArabic(
            fontSize: 48,
            fontWeight: FontWeight.w900,
            color: onSurface,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'احصل على تحليل احترافي للبشرة وتتبع التاريخ المرضي. رؤى آمنة وسريرية مدعومة بالبيانات في متناول يدك.',
          style: GoogleFonts.notoSansArabic(color: onSurfaceVariant, fontSize: 18, height: 1.6),
        ),
      ],
    );
  }

  Widget _buildLoginCard(bool isDesktop) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 448),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: Colors.white.withOpacity(0.4)),
        boxShadow: [
          BoxShadow(color: primaryColor.withOpacity(0.06), blurRadius: 48, offset: const Offset(0, 8)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              crossAxisAlignment: isDesktop ? CrossAxisAlignment.start : CrossAxisAlignment.center,
              children: [
                Text('تسجيل الدخول', style: GoogleFonts.notoSansArabic(fontSize: 30, fontWeight: FontWeight.bold, color: onSurface)),
                const SizedBox(height: 8),
                Text('أدخل بياناتك للمتابعة', style: GoogleFonts.notoSansArabic(color: onSurfaceVariant, fontSize: 14)),
                const SizedBox(height: 40),

                _buildLabel('البريد الإلكتروني'),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _emailController,
                  hint: 'example@email.com',
                  icon: Icons.alternate_email,
                  isEmail: true,
                ),
                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildLabel('كلمة المرور'),
                    Text('نسيت كلمة السر؟', style: GoogleFonts.notoSansArabic(fontSize: 12, fontWeight: FontWeight.bold, color: primaryColor)),
                  ],
                ),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _passwordController,
                  hint: '••••••••••••',
                  icon: Icons.lock_outline,
                  isPassword: true,
                ),
                const SizedBox(height: 32),

                // زر الدخول
                Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [primaryColor, primaryContainer],
                    ),
                    boxShadow: [BoxShadow(color: primaryColor.withOpacity(0.2), blurRadius: 12, offset: const Offset(0, 4))],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: _loading ? null : _submit,
                      child: Center(
                        child: _loading
                            ? const SizedBox(
                                width: 24, height: 24,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                              )
                            : Text(
                                'تسجيل الدخول إلى DermAI',
                                style: GoogleFonts.notoSansArabic(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Divider(color: outlineVariant.withOpacity(0.2)),
                const SizedBox(height: 32),

                // إنشاء حساب
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('جديد في الشبكة؟ ', style: GoogleFonts.notoSansArabic(color: onSurfaceVariant, fontSize: 14)),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, Routes.register),
                      child: Text('إنشاء حساب جديد', style: GoogleFonts.notoSansArabic(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 14)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(text, style: GoogleFonts.notoSansArabic(fontSize: 12, fontWeight: FontWeight.w600, color: onSurfaceVariant));
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool isEmail = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: outlineVariant.withOpacity(0.3)),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))],
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword && !_isPasswordVisible,
        keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
        textAlign: TextAlign.right,
        style: GoogleFonts.notoSansArabic(color: onSurface),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.notoSansArabic(color: onSurfaceVariant.withOpacity(0.3), fontSize: 14),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          prefixIcon: Icon(icon, color: onSurfaceVariant.withOpacity(0.5)),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(_isPasswordVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: onSurfaceVariant.withOpacity(0.5)),
                  onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildFooter(bool isDesktop) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Flex(
        direction: isDesktop ? Axis.horizontal : Axis.vertical,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 6, height: 6, decoration: BoxDecoration(color: primaryColor, shape: BoxShape.circle)),
              const SizedBox(width: 8),
              Text('حالة النظام: يعمل - نسخة 2.4.0', style: GoogleFonts.notoSansArabic(color: onSurfaceVariant.withOpacity(0.7), fontSize: 12)),
            ],
          ),
          SizedBox(height: isDesktop ? 0 : 16),
          Wrap(
            spacing: 24,
            children: [
              Text('بروتوكول الخصوصية', style: GoogleFonts.notoSansArabic(color: onSurfaceVariant.withOpacity(0.7), fontSize: 12)),
              Text('شروط الخدمة', style: GoogleFonts.notoSansArabic(color: onSurfaceVariant.withOpacity(0.7), fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}
