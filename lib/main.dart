import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/app_theme.dart';
import 'core/settings_service.dart';
import 'routes.dart';
import 'services/auth_service.dart';
import 'features/welcome/welcome_screen.dart';
import 'features/home/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // تحميل عنوان الخادم المحفوظ (IP جهاز XAMPP) قبل أي طلب.
  await SettingsService.instance.load();
  runApp(const DermalyzeApp());
}

class DermalyzeApp extends StatelessWidget {
  const DermalyzeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dermalyze AI',
      theme: AppTheme.light,
      // التعريب + RTL يتكفّل بهما flutter_localizations تلقائياً.
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar'), Locale('en')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      onGenerateRoute: Routes.onGenerateRoute,
      home: const AuthGate(),
    );
  }
}

/// بوابة الدخول: تحاول الدخول التلقائي ثم تعرض Home أو Welcome.
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  late final Future<bool> _autoLogin;

  @override
  void initState() {
    super.initState();
    _autoLogin = AuthService.instance.tryAutoLogin();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _autoLogin,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        // نستمع لتغيّر حالة الدخول (مثلاً عند انتهاء التوكن لاحقاً).
        return ValueListenableBuilder<bool>(
          valueListenable: AuthService.instance.isLoggedIn,
          builder: (context, loggedIn, _) =>
              loggedIn ? const HomeScreen() : const WelcomeScreen(),
        );
      },
    );
  }
}
