import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  Future<void> _ouvrir(BuildContext context, Uri uri) async {
    bool ok = false;
    try {
      ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {}
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Impossible d\'ouvrir ce lien')),
      );
    }
  }

  Widget _ligne(BuildContext context,
      {required IconData icone,
      required String titre,
      required String valeur,
      Uri? uri}) {
    return Card(
      child: ListTile(
        leading: Icon(icone, color: Theme.of(context).colorScheme.primary),
        title: Text(titre),
        subtitle: Text(valeur),
        trailing: uri != null ? const Icon(Icons.open_in_new, size: 18) : null,
        onTap: uri == null ? null : () => _ouvrir(context, uri),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        _ligne(context,
            icone: Icons.phone,
            titre: 'Téléphone',
            valeur: Contacts.telephone,
            uri: Uri(
                scheme: 'tel',
                path: Contacts.telephone.replaceAll(' ', ''))),
        _ligne(context,
            icone: Icons.email,
            titre: 'E-mail',
            valeur: Contacts.email,
            uri: Uri(scheme: 'mailto', path: Contacts.email)),
        _ligne(context,
            icone: Icons.location_on,
            titre: 'Adresse',
            valeur: Contacts.adresse),
        _ligne(context,
            icone: Icons.business_center,
            titre: 'LinkedIn',
            valeur: Contacts.linkedin,
            uri: Uri.parse(Contacts.linkedin)),
        _ligne(context,
            icone: Icons.code,
            titre: 'GitHub',
            valeur: Contacts.github,
            uri: Uri.parse(Contacts.github)),
        _ligne(context,
            icone: Icons.facebook,
            titre: 'Facebook',
            valeur: Contacts.facebook,
            uri: Uri.parse(Contacts.facebook)),
      ],
    );
  }
}
