import 'package:flutter/material.dart';
import '../data.dart';
import '../widgets/avatar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Widget _section(BuildContext context, String titre, IconData icone,
      List<Widget> enfants) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Icon(icone, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 8),
              Text(titre, style: Theme.of(context).textTheme.titleLarge),
            ]),
            const Divider(),
            ...enfants,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Column(
          children: [
            const Avatar(asset: Profil.photo, radius: 60),
            const SizedBox(height: 12),
            Text(Profil.nom,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(Profil.titre,
                textAlign: TextAlign.center,
                style: TextStyle(color: cs.primary, fontSize: 16)),
            const SizedBox(height: 12),
            const Text(Profil.resume, textAlign: TextAlign.center),
            const SizedBox(height: 16),
          ],
        ),
        _section(context, 'Formation', Icons.school, [
          for (final f in formations)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(f.diplome,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text('${f.etablissement}\n${f.periode}'),
              isThreeLine: true,
            ),
        ]),
        _section(context, 'Expériences', Icons.work, [
          for (final e in experiences)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(e.titre,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text('${e.lieu} • ${e.periode}\n${e.description}'),
              isThreeLine: true,
            ),
        ]),
        _section(context, 'Compétences techniques', Icons.code, [
          for (final c in competencesTechniques.entries)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(c.key),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                      value: c.value,
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(4)),
                ],
              ),
            ),
        ]),
        _section(context, 'Langues', Icons.language, [
          for (final l in langues.entries)
            ListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              title: Text(l.key),
              trailing: Text(l.value),
            ),
        ]),
        _section(context, 'Centres d\'intérêt', Icons.favorite, [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [for (final c in centresInteret) Chip(label: Text(c))],
          ),
        ]),
      ],
    );
  }
}
