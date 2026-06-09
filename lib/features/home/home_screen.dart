import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_theme.dart';
import '../../routes.dart';
import '../../services/auth_service.dart';
import '../history/history_screen.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  late final List<Widget> _tabs = const [
    _HomeTab(),
    HistoryScreen(embedded: true),
    ProfileScreen(embedded: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: IndexedStack(index: _index, children: _tabs),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        backgroundColor: Colors.white,
        indicatorColor: AppColors.primaryContainer,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'الرئيسية'),
          NavigationDestination(icon: Icon(Icons.history), selectedIcon: Icon(Icons.history), label: 'السجل'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'حسابي'),
        ],
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    final user = AuthService.instance.currentUser;
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Text('مرحباً 👋',
                style: GoogleFonts.notoSansArabic(fontSize: 16, color: AppColors.onSurfaceVariant)),
            const SizedBox(height: 4),
            Text(user?.fullName ?? 'مستخدم',
                style: GoogleFonts.notoSansArabic(
                    fontSize: 28, fontWeight: FontWeight.w900, color: AppColors.onSurface)),
            const SizedBox(height: 32),

            // البطاقة الرئيسية: ابدأ تحليلاً
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryDark],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 24, offset: const Offset(0, 10)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.auto_awesome, color: Colors.white, size: 36),
                  const SizedBox(height: 16),
                  Text('حلّل بشرتك الآن',
                      style: GoogleFonts.notoSansArabic(
                          color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('التقط صورة لبشرتك ودع الذكاء الاصطناعي يقدّم لك استشارة مخصصة حسب حالتك والطقس.',
                      style: GoogleFonts.notoSansArabic(
                          color: Colors.white.withOpacity(0.9), fontSize: 14, height: 1.6)),
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    onPressed: () => Navigator.pushNamed(context, Routes.camera),
                    icon: const Icon(Icons.camera_alt_outlined),
                    label: Text('تحليل بشرتي',
                        style: GoogleFonts.notoSansArabic(fontWeight: FontWeight.bold)),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary,
                      minimumSize: const Size(double.infinity, 52),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            Text('روابط سريعة',
                style: GoogleFonts.notoSansArabic(
                    fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _quickCard(
                    context,
                    icon: Icons.history,
                    title: 'سجل الفحوصات',
                    color: AppColors.tertiary,
                    onTap: () => Navigator.pushNamed(context, Routes.history),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _quickCard(
                    context,
                    icon: Icons.person_outline,
                    title: 'ملفي الشخصي',
                    color: AppColors.primary,
                    onTap: () => Navigator.pushNamed(context, Routes.profile),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _quickCard(BuildContext context,
      {required IconData icon, required String title, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 12),
            Text(title,
                style: GoogleFonts.notoSansArabic(
                    fontWeight: FontWeight.bold, color: AppColors.onSurface, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
