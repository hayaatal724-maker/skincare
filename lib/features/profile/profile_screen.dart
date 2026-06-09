import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/api_client.dart';
import '../../core/app_theme.dart';
import '../../models/user.dart';
import '../../routes.dart';
import '../../services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  final bool embedded;
  const ProfileScreen({super.key, this.embedded = false});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<User> _future;

  @override
  void initState() {
    super.initState();
    _future = AuthService.instance.fetchProfile();
  }

  Future<void> _logout() async {
    await AuthService.instance.logout();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, Routes.welcome, (_) => false);
  }

  Future<void> _editName(User user) async {
    final controller = TextEditingController(text: user.fullName);
    final newName = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('تعديل الاسم', style: GoogleFonts.notoSansArabic()),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'الاسم الكامل'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('إلغاء', style: GoogleFonts.notoSansArabic())),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
            child: Text('حفظ', style: GoogleFonts.notoSansArabic()),
          ),
        ],
      ),
    );
    if (newName == null || newName.isEmpty) return;
    try {
      await AuthService.instance.updateProfile(fullName: newName, skinType: user.skinType);
      setState(() => _future = AuthService.instance.fetchProfile());
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message), backgroundColor: AppColors.primary),
        );
      }
    }
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
        title: Text('الملف الشخصي',
            style: GoogleFonts.notoSansArabic(fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: FutureBuilder<User>(
          future: _future,
          builder: (context, snap) {
            if (snap.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator(color: AppColors.primary));
            }
            final user = snap.data ?? AuthService.instance.currentUser;
            if (user == null) {
              return Center(
                child: Text('تعذّر تحميل البيانات',
                    style: GoogleFonts.notoSansArabic(color: AppColors.onSurfaceVariant)),
              );
            }
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  CircleAvatar(
                    radius: 44,
                    backgroundColor: AppColors.primaryContainer,
                    child: Text(
                      user.fullName.isNotEmpty ? user.fullName.characters.first : '؟',
                      style: GoogleFonts.notoSansArabic(
                          fontSize: 36, fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(user.fullName,
                      style: GoogleFonts.notoSansArabic(
                          fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
                  Text(user.email,
                      style: GoogleFonts.notoSansArabic(color: AppColors.onSurfaceVariant, fontSize: 14)),
                  const SizedBox(height: 32),

                  _infoTile(Icons.spa_outlined, 'نوع البشرة', user.skinType ?? 'غير محدد'),
                  _infoTile(Icons.analytics_outlined, 'عدد الفحوصات', '${user.scansCount ?? 0}'),
                  _infoTile(Icons.badge_outlined, 'رقم المستخدم', '${user.id}'),
                  const SizedBox(height: 24),

                  OutlinedButton.icon(
                    onPressed: () => _editName(user),
                    icon: const Icon(Icons.edit_outlined),
                    label: Text('تعديل الاسم', style: GoogleFonts.notoSansArabic()),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      minimumSize: const Size(double.infinity, 52),
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () => Navigator.pushNamed(context, Routes.settings),
                    icon: const Icon(Icons.dns_outlined),
                    label: Text('إعدادات الخادم (IP)', style: GoogleFonts.notoSansArabic()),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.tertiary,
                      minimumSize: const Size(double.infinity, 52),
                      side: const BorderSide(color: AppColors.tertiary),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: _logout,
                    icon: const Icon(Icons.logout),
                    label: Text('تسجيل الخروج', style: GoogleFonts.notoSansArabic(fontWeight: FontWeight.bold)),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.error,
                      minimumSize: const Size(double.infinity, 52),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _infoTile(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(width: 12),
          Text(label,
              style: GoogleFonts.notoSansArabic(color: AppColors.onSurfaceVariant, fontSize: 14)),
          const Spacer(),
          Text(value,
              style: GoogleFonts.notoSansArabic(
                  color: AppColors.onSurface, fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }
}
