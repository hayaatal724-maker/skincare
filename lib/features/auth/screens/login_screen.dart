import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false;

  // 🎨 الألوان المستخرجة بدقة من ملف الـ Tailwind Config
  final Color surfaceColor = const Color(0xFFFFFbFA);
  final Color primaryColor = const Color(0xFF9C4250);
  final Color primaryDark = const Color(0xFF7D2B3A); // للـ Gradient
  final Color primaryContainer = const Color(0xFFFFD9DE);
  final Color onPrimaryFixedVariant = const Color(0xFF7D2B3A);
  final Color tertiaryColor = const Color(0xFF775930);
  final Color onSurface = const Color(0xFF201A1B);
  final Color onSurfaceVariant = const Color(0xFF534345);
  final Color surfaceContainerLow = const Color(0xFFFCF0F1);
  final Color outlineVariant = const Color(0xFFD8C2C4);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool isDesktop = size.width > 900; // نقطة التحول للشاشات الكبيرة

    return Scaffold(
      backgroundColor: surfaceColor,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Stack(
          children: [
            // --- 1. الصورة الخلفية الجمالية (تظهر فقط في الشاشات الكبيرة على اليسار) ---
            if (isDesktop)
              Positioned(
                top: 0,
                left: 0,
                bottom: 0,
                width: size.width / 2,
                child: Opacity(
                  opacity: 0.2, // opacity-20
                  child: ColorFiltered(
                    colorFilter: const ColorFilter.mode(
                      Colors.grey,
                      BlendMode.saturation, // grayscale effect
                    ),
                    child: Image.network(
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuBB7A8TMDEs3By19Ua8QG_57lT9K1TbySYXEVm_NYUt2BCy95pA2iuNIKS3JvsMzvllNBGcUVUW1TMwEseCvkwi9jR_5FTe1KwMmoz89xdPG_uuutfbFpHsQ9r55a5ElLWVBrDsuhz_mGTkJu-E4rq11wSR9xZkiLewtTQRAd0oesWCQI6NXjNe3_Gb0dhiR3CFFIEPClZNBLWu0J6qnC5VPopl6cSXwtO6JyHBNTXLbLNMVSRYSAkGr84nQNpu4A1QL62qF-pwzzU',
                      fit: BoxFit.cover,
                      color: surfaceColor,
                      colorBlendMode: BlendMode.multiply, // mix-blend-multiply
                    ),
                  ),
                ),
              ),

            // --- 2. الدوائر الضبابية الملونة (Abstract Background Elements) ---
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

            // --- 3. المحتوى الرئيسي ---
            SafeArea(
              child: Column(
                children: [
                  _buildHeader(isDesktop),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: size.height - 100, // الارتفاع الكلي ناقص الهيدر
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 24),
                            // هيكل شبكي (Grid) ينقسم لعمودين في الشاشات الكبيرة وعمود واحد في الموبايل
                            SizedBox(
                              width: 1200, // max-w-[1200px]
                              child: isDesktop
                                  ? Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        // العمود الأيمن: النصوص الترويجية
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 48), // pl-12
                                            child: _buildEditorialContent(),
                                          ),
                                        ),
                                        // العمود الأيسر: بطاقة تسجيل الدخول
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: _buildLoginCard(isDesktop),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Center(
                                      child: _buildLoginCard(isDesktop), // في الموبايل نعرض البطاقة فقط في المنتصف
                                    ),
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
      ),
    );
  }

  // ==========================================
  // الويدجتس المساعدة (Helper Widgets)
  // ==========================================

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
        // شارة (Badge)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: primaryContainer,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Text(
            'ذكاء اصطناعي متقدم للأمراض الجلدية',
            style: GoogleFonts.notoSansArabic(
              color: onPrimaryFixedVariant,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5, // tracking-widest
            ),
          ),
        ),
        const SizedBox(height: 16),
        // العنوان الرئيسي مع التدرج اللوني
        RichText(
          text: TextSpan(
            style: GoogleFonts.notoSansArabic(
              fontSize: 48, // text-5xl
              fontWeight: FontWeight.w900,
              color: onSurface,
              height: 1.1,
            ),
            children: [
              const TextSpan(text: 'رعاية دقيقة\n'),
              WidgetSpan(
                child: ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [primaryColor, primaryDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds),
                  child: Text(
                    'لصحة بشرتك.',
                    style: GoogleFonts.notoSansArabic(
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // النص الوصفي
        Text(
          'احصل على تحليل احترافي للبشرة وتتبع التاريخ المرضي. رؤى آمنة وسريرية مدعومة بالبيانات في متناول يدك.',
          style: GoogleFonts.notoSansArabic(
            color: onSurfaceVariant,
            fontSize: 18,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 32),
        // بطاقات الميزات (HIPAA & Smart Diagnosis)
        Row(
          children: [
            Expanded(child: _buildFeatureCard(Icons.verified_user_outlined, primaryColor, 'متوافق مع HIPAA', 'بياناتك الطبية مشفرة ومحمية ببروتوكولات قياسية عالمية.')),
            const SizedBox(width: 16),
            Expanded(child: _buildFeatureCard(Icons.biotech_outlined, tertiaryColor, 'تشخيص ذكي', 'مدرب على أكثر من 500 ألف صورة سريرية للفحص الجلدي الدقيق.')),
          ],
        ),
      ],
    );
  }

  Widget _buildFeatureCard(IconData icon, Color iconColor, String title, String desc) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor),
          const SizedBox(height: 8),
          Text(title, style: GoogleFonts.notoSansArabic(fontWeight: FontWeight.bold, color: onSurface, fontSize: 14)),
          const SizedBox(height: 4),
          Text(desc, style: GoogleFonts.notoSansArabic(color: onSurfaceVariant, fontSize: 12, height: 1.5)),
        ],
      ),
    );
  }

  Widget _buildLoginCard(bool isDesktop) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 448), // max-w-md
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(40), // rounded-[2.5rem]
        border: Border.all(color: Colors.white.withOpacity(0.4)),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.06),
            blurRadius: 48,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Padding(
            padding: const EdgeInsets.all(40.0), // p-8 md:p-10
            child: Column(
              crossAxisAlignment: isDesktop ? CrossAxisAlignment.start : CrossAxisAlignment.center,
              children: [
                Text('تسجيل الدخول', style: GoogleFonts.notoSansArabic(fontSize: 30, fontWeight: FontWeight.bold, color: onSurface)),
                const SizedBox(height: 8),
                Text('أدخل بيانات اعتمادك السريرية للمتابعة', style: GoogleFonts.notoSansArabic(color: onSurfaceVariant, fontSize: 14)),
                const SizedBox(height: 40),

                // حقل الإيميل
                _buildLabel('البريد الإلكتروني الطبي'),
                const SizedBox(height: 8),
                _buildTextField(hint: 'dr.smith@hospital.org', icon: Icons.alternate_email, isEmail: true),
                const SizedBox(height: 24),

                // حقل كلمة السر
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildLabel('مفتاح الأمان'),
                    Text('نسيت كلمة السر؟', style: GoogleFonts.notoSansArabic(fontSize: 12, fontWeight: FontWeight.bold, color: primaryColor)),
                  ],
                ),
                const SizedBox(height: 8),
                _buildTextField(hint: '••••••••••••', icon: Icons.lock_outline, isPassword: true),
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
                      onTap: () {},
                      child: Center(
                        child: Text(
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
                    Text('جديد في الشبكة السريرية؟ ', style: GoogleFonts.notoSansArabic(color: onSurfaceVariant, fontSize: 14)),
                    Text('إنشاء حساب جديد', style: GoogleFonts.notoSansArabic(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 14)),
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

  Widget _buildTextField({required String hint, required IconData icon, bool isPassword = false, bool isEmail = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: outlineVariant.withOpacity(0.3)),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))],
      ),
      child: TextField(
        obscureText: isPassword && !_isPasswordVisible,
        keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
        textAlign: TextAlign.right,
        style: GoogleFonts.notoSansArabic(color: onSurface),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.notoSansArabic(color: onSurfaceVariant.withOpacity(0.3), fontSize: 14),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          // الأيقونة اليمين (في النظام العربي prefix يكون على اليمين)
          prefixIcon: Icon(icon, color: onSurfaceVariant.withOpacity(0.5)),
          // زر العين على اليسار
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
              Text('بوابة الدعم', style: GoogleFonts.notoSansArabic(color: onSurfaceVariant.withOpacity(0.7), fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}