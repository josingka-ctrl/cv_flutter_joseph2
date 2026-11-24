import 'package:shared_preferences/shared_preferences.dart';

/// Garde l'utilisateur connecté entre deux lancements de l'application.
class Session {
  static const _kEmail = 'session_email';

  static Future<void> enregistrer(String email) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_kEmail, email);
  }

  static Future<String?> email() async {
    final p = await SharedPreferences.getInstance();
    return p.getString(_kEmail);
  }

  static Future<void> effacer() async {
    final p = await SharedPreferences.getInstance();
    await p.remove(_kEmail);
  }
}
