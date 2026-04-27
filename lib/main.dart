import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const DermalyzeApp());
}

class DermalyzeApp extends StatelessWidget {
  const DermalyzeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dermalyze AI',
      // دعم اللغة العربية والاتجاه من اليمين لليسار
      locale: const Locale('ar', 'SA'),
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
      theme: ThemeData(
        useMaterial3: true,
        textTheme: GoogleFonts.cairoTextTheme(),
      ),
      home: const WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  // الألوان المستخرجة من تصميمك
  static const Color primary = Color(0xFF7C5360);
  static const Color primaryContainer = Color(0xFFF2BDCD);
  static const Color onPrimaryContainer = Color(0xFF724A57);
  static const Color tertiaryContainer = Color(0xFFB6D3AF);
  static const Color onTertiaryContainer = Color(0xFF435C3F);
  static const Color onSurface = Color(0xFF1F1B1B);
  static const Color onSurfaceVariant = Color(0xFF504447);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. الخلفية (صورة + تأثيرات وتدرجات لونية)
          Positioned.fill(
            child: Image.network(
              'https://lh3.googleusercontent.com/aida-public/AB6AXuDi44GA79YSa24MdKnR5kXaTxOSbS9shB3-ndx6U1RxI7ALl4RctvHyH0YqCJlAzyNIOZj97c0g8VN4RT1AU5ApwQ83ujP2tpoljarPTYxPFniHQiVNYePvQoxfzQEW9Vi_liU8IZskm-WB2iWpbd1IUW6snlCsuz6VDQvX9EVyyPwwwoK1Q5_rs-1nAYb3s_6RsWkqkUM6fn0pgZR4a5NRtr1bZ7sUEx1avuUGxcH9pL0vhdz3j9dyBOIzTzvl_7bREDpMo66I0gs',
              fit: BoxFit.cover,
              color: Colors.white.withOpacity(0.4),
              colorBlendMode: BlendMode.lighten,
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.white.withOpacity(0.95),
                    const Color(0xFFFFF8F8).withOpacity(0.7),
                    const Color(0xFFFFF8F8).withOpacity(0.3),
                  ],
                ),
              ),
            ),
          ),

          // 2. المحتوى الرئيسي
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  
                  // اللوجو (Spa Icon) الزجاجي
                  ClipOval(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.5),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white.withOpacity(0.6)),
                          boxShadow: [
                            BoxShadow(
                              color: primaryContainer.withOpacity(0.2),
                              blurRadius: 32,
                              offset: const Offset(0, 8),
                            )
                          ],
                        ),
                        child: const Icon(
                          Icons.spa_rounded,
                          color: primary,
                          size: 32,
                        ),
                      ),
                    ),
                  ),

                  const Spacer(), // لدفع البطاقة إلى الأسفل

                  // البطاقة الزجاجية السفلية (Glassmorphism Card)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(32),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(color: Colors.white.withOpacity(0.7)),
                          boxShadow: [
                            BoxShadow(
                              color: primaryContainer.withOpacity(0.15),
                              blurRadius: 40,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // العنوان
                            RichText(
                              text: TextSpan(
                                style: GoogleFonts.cairo(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  height: 1.2,
                                  color: onSurface,
                                ),
                                children: const [
                                  TextSpan(text: 'عناية ذكية،\n'),
                                  TextSpan(
                                    text: 'تتكيف مع بيئتك.',
                                    style: TextStyle(color: primary),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),

                            // الوصف
                            Text(
                              'ندمج بين قوة الذكاء الاصطناعي في تحليل البشرة وبيانات المناخ والموقع الجغرافي لنقدم لكِ روتين عناية دقيق ومخصص لكِ تماماً.',
                              style: GoogleFonts.cairo(
                                fontSize: 16,
                                height: 1.6,
                                color: onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 24),

                            // الـ Chips (التحليل الذكي والمناخ)
                            Row(
                              children: [
                                _buildChip(
                                  icon: Icons.auto_awesome,
                                  label: 'تحليل ذكي',
                                  bgColor: tertiaryContainer.withOpacity(0.3),
                                  borderColor: tertiaryContainer.withOpacity(0.5),
                                  textColor: onTertiaryContainer,
                                ),
                                const SizedBox(width: 8),
                                _buildChip(
                                  icon: Icons.thermostat,
                                  label: 'مزامنة المناخ',
                                  bgColor: primaryContainer.withOpacity(0.3),
                                  borderColor: primaryContainer.withOpacity(0.5),
                                  textColor: onPrimaryContainer,
                                ),
                              ],
                            ),
                            const SizedBox(height: 32),

                            // زر "ابدأ الرحلة"
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryContainer,
                                foregroundColor: onPrimaryContainer,
                                minimumSize: const Size(double.infinity, 56),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'ابدأ الرحلة',
                                    style: GoogleFonts.cairo(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(Icons.arrow_back, size: 20),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),

                            // زر "تسجيل الدخول"
                            OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                foregroundColor: onSurfaceVariant,
                                side: const BorderSide(color: tertiaryContainer, width: 2),
                                minimumSize: const Size(double.infinity, 56),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'تسجيل الدخول',
                                style: GoogleFonts.cairo(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ويدجت مساعدة لإنشاء الـ Chips
  Widget _buildChip({
    required IconData icon,
    required String label,
    required Color bgColor,
    required Color borderColor,
    required Color textColor,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: textColor),
              const SizedBox(width: 6),
              Text(
                label,
                style: GoogleFonts.cairo(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}