import '../config.dart';

class Membre {
  final int? id;
  final String nom, postnom, prenom, lieuNaissance, dateNaissance, parente;
  final String? imageUrl;

  const Membre({
    this.id,
    required this.nom,
    required this.postnom,
    required this.prenom,
    required this.lieuNaissance,
    required this.dateNaissance,
    required this.parente,
    this.imageUrl,
  });

  String get nomComplet => '$prenom $nom $postnom';

  factory Membre.fromJson(Map<String, dynamic> j) {
    return Membre(
      id: int.tryParse('${j['id']}'),
      nom: '${j['nom'] ?? ''}',
      postnom: '${j['postnom'] ?? ''}',
      prenom: '${j['prenom'] ?? ''}',
      lieuNaissance: '${j['lieu_naissance'] ?? ''}',
      dateNaissance: '${j['date_naissance'] ?? ''}',
      parente: '${j['parente'] ?? ''}',
      imageUrl: _corrigerUrl(j['image_url'] as String?),
    );
  }

  /// Le serveur peut renvoyer "localhost" : on le remplace par l'hôte réel
  /// (utile avec l'émulateur Android où localhost = l'émulateur lui-même).
  static String? _corrigerUrl(String? url) {
    if (url == null || url.isEmpty) return null;
    final u = Uri.tryParse(url);
    if (u == null) return url;
    if (u.host == 'localhost' || u.host == '127.0.0.1') {
      return u.replace(host: kHote).toString();
    }
    return url;
  }

  Map<String, String> toFields() => {
        'nom': nom,
        'postnom': postnom,
        'prenom': prenom,
        'lieu_naissance': lieuNaissance,
        'date_naissance': dateNaissance,
        'parente': parente,
      };
}
