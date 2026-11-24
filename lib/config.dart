import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

/// ====== CONFIGURATION DE L'API ======
///
/// - Émulateur Android : 10.0.2.2 désigne le PC (déjà géré automatiquement).
/// - Vrai téléphone Android : mettez l'adresse IP de votre PC, par exemple
///   '192.168.1.15' (commande `ipconfig` sous Windows). Le téléphone et le PC
///   doivent être sur le même Wi-Fi.
/// - Chrome / Windows : localhost.
const String? kHoteApiManuel = null; // ex : '192.168.1.15'

String get kHote {
  if (kHoteApiManuel != null) return kHoteApiManuel!;
  if (kIsWeb) return 'localhost';
  if (Platform.isAndroid) return '10.0.2.2';
  return 'localhost';
}

String get kBaseUrl => 'http://$kHote/api-test/public';
