import 'dart:ui';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // للتحكم في إظهار وإخفاء كلمة المرور
  bool _isPasswordVisible = false;

  // الألوان الأساسية المستخرجة من التصميم
  final Color primaryColor = const Color(0xFF9C4250);
  final Color primaryContainer = const Color(0xFFFFD9DE);
  final Color tertiaryColor = const Color(0xFF775930);
  final Color backgroundColor = const Color(0xFFFFFBFA);
  final Color onSurface = const Color(0xFF201A1B);
  final Color onSurfaceVariant = const Color(0xFF534345);

  @override
  Widget build(BuildContext context) {
    // نستخدم MediaQuery لجعل التصميم متجاوباً
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Directionality(
        textDirection: TextDirection.rtl, // لضمان اتجاه من اليمين لليسار
        child: Stack(
          children: [
            // 1. الدوائر الخلفية الضبابية (Abstract Background)
            Positioned(
              top: -size.width * 0.1,
              left: -size.width * 0.05,
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                child: Container(
                  width: size.width * 0.8,
                  height: size.width * 0.8,
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.05),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -size.width * 0.1,
              right: -size.width * 0.05,
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
                child: Container(
                  width: size.width * 0.6,
                  height: size.width * 0.6,
                  decoration: BoxDecoration(
                    color: tertiaryColor.withOpacity(0.05),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),

            // 2. المحتوى الرئيسي (Scrollable)
            SafeArea(
              child: CustomScrollView(
                slivers: [
                  // الهيدر (Brand Header)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.medical_services_outlined, color: primaryColor, size: 32),
                              const SizedBox(width: 8),
                              Text(
                                'DermAI',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w900,
                                  color: primaryColor,
                                ),
                              ),
                            ],
                          ),
                          // يظهر فقط على الشاشات الكبيرة
                          if (size.width > 600)
                            Text(
                              'وصول سريري آمن',
                              style: TextStyle(
                                color: onSurfaceVariant,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),

                  // المحتوى (نصوص + بطاقة تسجيل الدخول)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // النصوص الترحيبية والمعلومات (تظهر فوق البطاقة في الموبايل)
                          _buildEditorialContent(),
                          
                          const SizedBox(height: 40),
                          
                          // بطاقة تسجيل الدخول (Login Card)
                          _buildLoginCard(),

                          const SizedBox(height: 40),

                          // الفوتر (Footer)
                          _buildFooter(),
                          const SizedBox(height: 24),
                        ],
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

  // ويدجت النصوص الطبية
  Widget _buildEditorialContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: primaryContainer,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'ذكاء اصطناعي متقدم للأمراض الجلدية',
            style: TextStyle(
              color: const Color(0xFF7D2B3A),
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
        const SizedBox(height: 16),
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w900,
              color: onSurface,
              fontFamily: 'Noto Sans Arabic', // تأكد من إضافته في pubspec.yaml
              height: 1.2,
            ),
            children: [
              const TextSpan(text: 'رعاية دقيقة\n'),
              WidgetSpan(
                child: ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [primaryColor, const Color(0xFF7D2B3A)],
                  ).createShader(bounds),
                  child: const Text(
                    'لصحة بشرتك.',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      color: Colors.white, // يجب أن يكون أبيض ليظهر التدرج
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'احصل على تحليل احترافي للبشرة وتتبع التاريخ المرضي. رؤى آمنة وسريرية مدعومة بالبيانات في متناول يدك.',
          style: TextStyle(
            color: onSurfaceVariant,
            fontSize: 14,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  // بطاقة تسجيل الدخول مع تأثير الزجاج
  Widget _buildLoginCard() {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 450),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(40),
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
            padding: const EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'تسجيل الدخول',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'أدخل بيانات اعتمادك السريرية للمتابعة',
                  style: TextStyle(color: onSurfaceVariant, fontSize: 14),
                ),
                const SizedBox(height: 32),

                // حقل البريد الإلكتروني
                Text(
                  'البريد الإلكتروني الطبي',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                _buildTextField(
                  hintText: 'dr.smith@hospital.org',
                  icon: Icons.alternate_email,
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 24),

                // حقل كلمة المرور
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'مفتاح الأمان',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: onSurfaceVariant,
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Text(
                        'نسيت كلمة السر؟',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _buildTextField(
                  hintText: '••••••••••••',
                  icon: Icons.lock_outline,
                  isPassword: true,
                ),

                const SizedBox(height: 32),

                // زر تسجيل الدخول
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
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.2),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {},
                      child: const Center(
                        child: Text(
                          'تسجيل الدخول إلى DermAI',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),
                const Divider(color: Color(0x1A857375)), // outline-variant / 10%
                const SizedBox(height: 24),

                // إنشاء حساب جديد
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'جديد في الشبكة السريرية؟ ',
                      style: TextStyle(color: onSurfaceVariant, fontSize: 12),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Text(
                        'إنشاء حساب جديد',
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
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

  // ويدجت مساعدة لبناء حقول الإدخال
  Widget _buildTextField({
    required String hintText,
    required IconData icon,
    bool isPassword = false,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD8C2C4).withOpacity(0.3)),
      ),
      child: TextField(
        obscureText: isPassword && !_isPasswordVisible,
        keyboardType: keyboardType,
        style: TextStyle(color: onSurface),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: onSurfaceVariant.withOpacity(0.3), fontSize: 14),
          prefixIcon: Icon(icon, color: onSurfaceVariant.withOpacity(0.5)),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    color: onSurfaceVariant.withOpacity(0.5),
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  // الفوتر
  Widget _buildFooter() {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 16,
      runSpacing: 16,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 6, height: 6, decoration: BoxDecoration(color: primaryColor, shape: BoxShape.circle)),
            const SizedBox(width: 6),
            Text('حالة النظام: يعمل - نسخة 2.4.0', style: TextStyle(color: onSurfaceVariant.withOpacity(0.5), fontSize: 10)),
          ],
        ),
        Text('بروتوكول الخصوصية', style: TextStyle(color: onSurfaceVariant.withOpacity(0.5), fontSize: 10)),
        Text('شروط الخدمة', style: TextStyle(color: onSurfaceVariant.withOpacity(0.5), fontSize: 10)),
      ],
    );
  }
}