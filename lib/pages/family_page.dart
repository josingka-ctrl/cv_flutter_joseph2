import 'package:flutter/material.dart';
import '../models/membre.dart';
import '../services/api_service.dart';
import '../widgets/membre_avatar.dart';
import 'member_form_page.dart';

class FamilyPage extends StatefulWidget {
  const FamilyPage({super.key});

  @override
  State<FamilyPage> createState() => _FamilyPageState();
}

class _FamilyPageState extends State<FamilyPage> {
  late Future<List<Membre>> _futur;

  @override
  void initState() {
    super.initState();
    _futur = ApiService.listerMembres();
  }

  Future<void> _recharger() async {
    setState(() => _futur = ApiService.listerMembres());
    await _futur.catchError((_) => <Membre>[]);
  }

  Future<void> _ouvrirFormulaire([Membre? membre]) async {
    final modifie = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => MemberFormPage(membre: membre)),
    );
    if (modifie == true) _recharger();
  }

  Future<void> _supprimer(Membre m) async {
    final confirme = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer ce membre ?'),
        content: Text('${m.nomComplet} sera supprimé définitivement.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Annuler')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Supprimer')),
        ],
      ),
    );
    if (confirme != true || m.id == null) return;
    try {
      await ApiService.supprimerMembre(m.id!);
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Membre supprimé')));
      _recharger();
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Membre>>(
        future: _futur,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.cloud_off, size: 56, color: Colors.grey),
                    const SizedBox(height: 12),
                    Text('${snap.error}', textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: _recharger,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Réessayer'),
                    ),
                  ],
                ),
              ),
            );
          }
          final membres = snap.data ?? [];
          return RefreshIndicator(
            onRefresh: _recharger,
            child: membres.isEmpty
                ? ListView(children: const [
                    SizedBox(height: 160),
                    Center(
                        child: Text(
                            'Aucun membre pour le moment.\nAppuyez sur + pour en ajouter.',
                            textAlign: TextAlign.center)),
                  ])
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 88),
                    itemCount: membres.length,
                    itemBuilder: (context, i) {
                      final m = membres[i];
                      return Card(
                        elevation: 2,
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          leading: MembreAvatar(url: m.imageUrl),
                          title: Text(m.nomComplet,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(
                              '${m.parente}\nNé(e) le ${m.dateNaissance} à ${m.lieuNaissance}'),
                          isThreeLine: true,
                          onTap: () => _ouvrirFormulaire(m),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                tooltip: 'Modifier',
                                icon: const Icon(Icons.edit),
                                onPressed: () => _ouvrirFormulaire(m),
                              ),
                              IconButton(
                                tooltip: 'Supprimer',
                                icon: const Icon(Icons.delete,
                                    color: Colors.redAccent),
                                onPressed: () => _supprimer(m),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _ouvrirFormulaire(),
        icon: const Icon(Icons.person_add),
        label: const Text('Ajouter'),
      ),
    );
  }
}
