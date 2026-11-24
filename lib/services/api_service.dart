import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config.dart';
import '../models/membre.dart';

class ApiException implements Exception {
  final String message;
  ApiException(this.message);
  @override
  String toString() => message;
}

class ApiService {
  static const _timeout = Duration(seconds: 15);
  static const _jsonHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Uri _uri(String path) => Uri.parse('$kBaseUrl$path');

  /// Décode la réponse et lève ApiException si success == false.
  static Map<String, dynamic> _traiter(http.Response r) {
    Map<String, dynamic> body;
    try {
      body = jsonDecode(utf8.decode(r.bodyBytes)) as Map<String, dynamic>;
    } catch (_) {
      throw ApiException(
          'Réponse invalide du serveur (code ${r.statusCode}). Vérifiez l\'URL de l\'API.');
    }
    if (r.statusCode >= 200 && r.statusCode < 300 && body['success'] == true) {
      return body;
    }
    final errors = body['errors'];
    if (errors is Map && errors.isNotEmpty) {
      throw ApiException(errors.values.join('\n'));
    }
    throw ApiException('${body['message'] ?? 'Erreur ${r.statusCode}'}');
  }

  static Future<T> _proteger<T>(Future<T> Function() action) async {
    try {
      return await action().timeout(_timeout);
    } on ApiException {
      rethrow;
    } on TimeoutException {
      throw ApiException(
          'Le serveur ne répond pas. Vérifiez que XAMPP (Apache + MySQL) est démarré.');
    } on SocketException {
      throw ApiException(
          'Connexion impossible au serveur. Vérifiez XAMPP et l\'adresse de l\'API ($kBaseUrl).');
    } on http.ClientException {
      throw ApiException(
          'Connexion impossible au serveur. Vérifiez XAMPP et l\'adresse de l\'API ($kBaseUrl).');
    }
  }

  // ---------- Comptes ----------

  static Future<Map<String, dynamic>> login(String email, String password) {
    return _proteger(() async {
      final r = await http.post(_uri('/accounts/login'),
          headers: _jsonHeaders,
          body: jsonEncode({'email': email, 'password': password}));
      return _traiter(r)['data'] as Map<String, dynamic>;
    });
  }

  static Future<Map<String, dynamic>> register(String email, String password) {
    return _proteger(() async {
      final r = await http.post(_uri('/accounts/register'),
          headers: _jsonHeaders,
          body: jsonEncode({'email': email, 'password': password}));
      return _traiter(r)['data'] as Map<String, dynamic>;
    });
  }

  // ---------- Membres de famille ----------

  static Future<List<Membre>> listerMembres() {
    return _proteger(() async {
      final r = await http.get(_uri('/famille-membres'), headers: _jsonHeaders);
      final data = _traiter(r)['data'];
      if (data is List) {
        return data
            .map((e) => Membre.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return <Membre>[];
    });
  }

  static Future<Membre> creerMembre(Membre m, {File? image}) {
    return _proteger(() async {
      http.Response r;
      if (image != null) {
        r = await _multipart('POST', '/famille-membres', m, image);
      } else {
        r = await http.post(_uri('/famille-membres'),
            headers: _jsonHeaders, body: jsonEncode(m.toFields()));
      }
      return Membre.fromJson(_traiter(r)['data'] as Map<String, dynamic>);
    });
  }

  /// Sans nouvelle image : PUT JSON (l'image actuelle est conservée).
  /// Avec nouvelle image : POST multipart sur /famille-membres/{id}.
  static Future<Membre> modifierMembre(int id, Membre m, {File? image}) {
    return _proteger(() async {
      http.Response r;
      if (image != null) {
        r = await _multipart('POST', '/famille-membres/$id', m, image);
      } else {
        r = await http.put(_uri('/famille-membres/$id'),
            headers: _jsonHeaders, body: jsonEncode(m.toFields()));
      }
      return Membre.fromJson(_traiter(r)['data'] as Map<String, dynamic>);
    });
  }

  static Future<void> supprimerMembre(int id) {
    return _proteger(() async {
      final r =
          await http.delete(_uri('/famille-membres/$id'), headers: _jsonHeaders);
      _traiter(r);
    });
  }

  static Future<http.Response> _multipart(
      String method, String path, Membre m, File image) async {
    final req = http.MultipartRequest(method, _uri(path));
    req.headers['Accept'] = 'application/json';
    req.fields.addAll(m.toFields());
    req.files.add(await http.MultipartFile.fromPath('image', image.path));
    final streamed = await req.send();
    return http.Response.fromStream(streamed);
  }
}
