import 'package:flutter/material.dart';

import 'models/scan.dart';
import 'features/welcome/welcome_screen.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/register_screen.dart';
import 'features/home/home_screen.dart';
import 'features/analyze/camera_screen.dart';
import 'features/analyze/result_screen.dart';
import 'features/history/history_screen.dart';
import 'features/profile/profile_screen.dart';

/// أسماء المسارات (Named Routes) في مكان واحد.
class Routes {
  static const welcome = '/welcome';
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';
  static const camera = '/camera';
  static const result = '/result';
  static const history = '/history';
  static const profile = '/profile';

  /// مولّد المسارات — يتعامل مع المسارات التي تحتاج وسائط (arguments).
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case welcome:
        return _page(const WelcomeScreen(), settings);
      case login:
        return _page(const LoginScreen(), settings);
      case register:
        return _page(const RegisterScreen(), settings);
      case home:
        return _page(const HomeScreen(), settings);
      case camera:
        return _page(const CameraScreen(), settings);
      case history:
        return _page(const HistoryScreen(), settings);
      case profile:
        return _page(const ProfileScreen(), settings);
      case result:
        final scan = settings.arguments as Scan;
        return _page(ResultScreen(scan: scan), settings);
      default:
        return null;
    }
  }

  static MaterialPageRoute _page(Widget child, RouteSettings settings) =>
      MaterialPageRoute(builder: (_) => child, settings: settings);
}
