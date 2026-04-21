import 'dart:ui';
import 'package:flutter/material.dart';

void main() {
  runApp(const DermAcademyApp());
}

class DermAcademyApp extends StatelessWidget {
  const DermAcademyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ديرم أكاديمي',
      theme: ThemeData(
        useMaterial3: true,
        // تحديد الألوان الأساسية بناءً على تصميم Tailwind
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFB02F56),
          primary: const Color(0xFFB02F56),
          secondary: const Color(0xFF76565C),
          surface: const Color(0xFFFFF0F1), // surface-container-low
        ),
      ),
      // جعل اتجاه التطبيق من اليمين لليسار (RTL) لأن اللغة عربية
      builder: (context, child) {
        return Directionality(textDirection: TextDirection.rtl, child: child!);
      },
      home: const WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // الألوان المستخدمة في التصميم
    const Color primaryColor = Color(0xFFB02F56);
    const Color secondaryColor = Color(0xFF76565C);
    const Color backgroundColor = Color(0xFFFFF0F1);
    const Color onSurfaceColor = Color(0xFF25191B);
    const Color onSurfaceVariant = Color(0xFF544345);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          // 1. الخلفية التجريدية (Abstract Background Orbs)
          Positioned(
            top: -50,
            right: -50,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            left: -80,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
              child: Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  color: secondaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),

          // 2. المحتوى الرئيسي
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(height: 40),

                          // --- الجزء العلوي: اللوجو والنصوص ---
                          Column(
                            children: [
                              // اللوجو (Gradient Box)
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(32),
                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [primaryColor, secondaryColor],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: primaryColor.withOpacity(0.15),
                                      blurRadius: 40,
                                      offset: const Offset(0, 12),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons
                                      .medical_services_outlined, // استبدال أيقونة clinical_notes
                                  color: Colors.white,
                                  size: 36,
                                ),
                              ),
                              const SizedBox(height: 24),

                              // النصوص
                              Text(
                                'مرحباً بك',
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.w900,
                                  color: primaryColor,
                                  letterSpacing: -1,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'رؤى سريرية احترافية لصحة بشرتك.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: onSurfaceVariant,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 40),

                          // --- الجزء الأوسط: بطاقة الصورة (Hero Visualization) ---
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 380),
                              child: AspectRatio(
                                aspectRatio: 4 / 5,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(40),
                                    boxShadow: [
                                      BoxShadow(
                                        color: primaryColor.withOpacity(0.08),
                                        blurRadius: 64,
                                        offset: const Offset(0, 32),
                                      ),
                                    ],
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.5),
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(40),
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        // الصورة
                                        Image.network(
                                          'https://lh3.googleusercontent.com/aida-public/AB6AXuDC3zDtIWWE8yA1Cn7Hz_acGMYTeXW8L-J87YRaz6sXD5XwK-0KtZw2fgGmErHSTTUCNOg3Lx6aFlP2rmGXvgmJBcbEHIFCFG329I0zTY72BmPBVMytTcLEEVqbTAnINtWQbHZZ8sH2uNXqdG3YG58Of83JDgylAUPIPeraoVXImIDbU5f8ivX75eo8wWpwiSqG6kv6dxw1nnqJ_MILEXX1Z7xFKIpwyGoHwPRwebaqRfKnOTsbeGjPuG4euIATqGUINjasRrjv2Eo',
                                          fit: BoxFit.cover,
                                        ),

                                        // التدرج اللوني فوق الصورة
                                        Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.bottomCenter,
                                              end: Alignment.topCenter,
                                              colors: [
                                                primaryColor.withOpacity(0.3),
                                                Colors.transparent,
                                              ],
                                            ),
                                          ),
                                        ),

                                        // تأثير الزجاج (Glassmorphism Card)
                                        Positioned(
                                          bottom: 24,
                                          left: 24,
                                          right: 24,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                            child: BackdropFilter(
                                              filter: ImageFilter.blur(
                                                sigmaX: 24,
                                                sigmaY: 24,
                                              ),
                                              child: Container(
                                                padding: const EdgeInsets.all(
                                                  16,
                                                ),
                                                color: Colors.white.withOpacity(
                                                  0.7,
                                                ),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: 40,
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                        color: const Color(
                                                          0xFFFFD9DF,
                                                        ), // secondary-container
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: const Icon(
                                                        Icons.auto_awesome,
                                                        color: Color(
                                                          0xFF321118,
                                                        ),
                                                        size: 20,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 16),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Text(
                                                            'تشخيص الذكاء الاصطناعي',
                                                            style: TextStyle(
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: primaryColor
                                                                  .withOpacity(
                                                                    0.7,
                                                                  ),
                                                              letterSpacing:
                                                                  1.5,
                                                            ),
                                                          ),
                                                          Text(
                                                            'جاهز للتحليل',
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  onSurfaceColor,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 40),

                          // --- الجزء السفلي: الأزرار والفوتر ---
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 24,
                            ),
                            child: Column(
                              children: [
                                // زر "ابدأ الآن"
                                Container(
                                  width: double.infinity,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24),
                                    gradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [primaryColor, secondaryColor],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: primaryColor.withOpacity(0.12),
                                        blurRadius: 24,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(24),
                                      onTap: () {
                                        // سينتقل لشاشة الكاميرا لاحقاً
                                      },
                                      child: const Center(
                                        child: Text(
                                          'ابدأ الآن',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // زر تسجيل الدخول
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'هل لديك حساب؟',
                                      style: TextStyle(
                                        color: onSurfaceVariant,
                                        fontSize: 14,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {},
                                      child: Text(
                                        'تسجيل الدخول',
                                        style: TextStyle(
                                          color: primaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),

                                // الفوتر (شارات الأمان والدقة)
                                Opacity(
                                  opacity: 0.4,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.verified_user_outlined,
                                        size: 14,
                                      ),
                                      const SizedBox(width: 4),
                                      const Text(
                                        'بيانات آمنة',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Container(
                                        width: 4,
                                        height: 4,
                                        decoration: const BoxDecoration(
                                          color: Colors.grey,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      const Icon(
                                        Icons.analytics_outlined,
                                        size: 14,
                                      ),
                                      const SizedBox(width: 4),
                                      const Text(
                                        'دقة سريرية',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
