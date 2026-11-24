import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/main_shell.dart';
import 'services/session.dart';

void main() {
  runApp(const CvApp());
}

class CvApp extends StatelessWidget {
  const CvApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CURRICULUM VITAE JOSEPH',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1565C0)),
      ),
      home: const _Demarrage(),
    );
  }
}

/// Si une session existe, on va directement à l'application.
class _Demarrage extends StatelessWidget {
  const _Demarrage();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: Session.email(),
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        return snap.data != null ? const MainShell() : const LoginPage();
      },
    );
  }
}
