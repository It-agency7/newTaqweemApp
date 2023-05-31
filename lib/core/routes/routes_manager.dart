import 'package:flutter/material.dart';

import '../../features/auth/presentation/screens/login.dart';
import '../../features/auth/presentation/screens/register.dart';

class RoutesManager {
  // static const String splash = '/';
  static const String login = '/';
  static const String register = '/register';
  static const String home = '/home';
  static const String notes = '/notes';
  static const String addNote = '/notes/addNote';
  static const String holidays = '/holidays';
  static const String profile = '/profile';
  static const String editProfile='/editProfile';
}

class RoutesGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesManager.login:
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => const LoginScreen(),
          transitionDuration: const Duration(milliseconds: 250),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOut, 
                ),
              ),
              child: child,
            );
          },
        );
      case RoutesManager.register:
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => const RegisterScreen(),
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (_, animation, __, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOut,
                ),
              ),
              child: FadeTransition(
                opacity: Tween<double>(
                  begin: 0.0,
                  end: 1.0,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOut,
                  ),
                ),
                child: child,
              ),
            );
          },
        );
      default:
        return undefinedRoute();
    }
  }

  static Route<dynamic> undefinedRoute() {
    return MaterialPageRoute(
        builder: (_) => Scaffold(
              appBar: AppBar(
                title: const Text(
                  'StringsManager.noRouteFound',
                ),
              ),
              body: const Center(
                child: Text('StringsManager.noRouteFound'),
              ),
            ));
  } //static function that return undefined route
}
