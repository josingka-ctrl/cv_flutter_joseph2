import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/membre.dart';
import '../services/api_service.dart';
import '../widgets/membre_avatar.dart';

/// Formulaire d'ajout (membre == null) ou de modification d'un membre.
class MemberFormPage extends StatefulWidget {
  final Membre? membre;
  const MemberFormPage({super.key, this.membre});

  @override
  State<MemberFormPage> createState() => _MemberFormPageState();
}

class _MemberFormPageState extends State<MemberFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nom, _postnom, _prenom, _lieu, _date, _parente;
  File? _image;
  bool _chargement = false;

  bool get _edition => widget.membre != null;

  @override
  void initState() {
    super.initState();
    final m = widget.membre;
    _nom = TextEditingController(text: m?.nom);
    _postnom = TextEditingController(text: m?.postnom);
    _prenom = TextEditingController(text: m?.prenom);
    _lieu = TextEditingController(text: m?.lieuNaissance);
    _date = TextEditingController(text: m?.dateNaissance);
    _parente = TextEditingController(text: m?.parente);
  }

  @override
  void dispose() {
    for (final c in [_nom, _postnom, _prenom, _lieu, _date, _parente]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _choisirImage(ImageSource source) async {
    final x = await ImagePicker()
        .pickImage(source: source, maxWidth: 1000, imageQuality: 85);
    if (x != null) setState(() => _image = File(x.path));
  }

  void _menuImage() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Wrap(children: [
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Choisir dans la galerie'),
            onTap: () {
              Navigator.pop(ctx);
              _choisirImage(ImageSource.gallery);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_camera),
            title: const Text('Prendre une photo'),
            onTap: () {
              Navigator.pop(ctx);
              _choisirImage(ImageSource.camera);
            },
          ),
        ]),
      ),
    );
  }

  Future<void> _choisirDate() async {
    final initiale = DateTime.tryParse(_date.text) ?? DateTime(2000);
    final d = await showDatePicker(
      context: context,
      initialDate: initiale.isAfter(DateTime.now()) ? DateTime.now() : initiale,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (d != null) {
      _date.text =
          '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
    }
  }

  Future<void> _enregistrer() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _chargement = true);
    final m = Membre(
      nom: _nom.text.trim(),
      postnom: _postnom.text.trim(),
      prenom: _prenom.text.trim(),
      lieuNaissance: _lieu.text.trim(),
      dateNaissance: _date.text.trim(),
      parente: _parente.text.trim(),
    );
    try {
      if (_edition) {
        await ApiService.modifierMembre(widget.membre!.id!, m, image: _image);
      } else {
        await ApiService.creerMembre(m, image: _image);
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(_edition ? 'Membre modifié' : 'Membre ajouté')));
      Navigator.pop(context, true);
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => _chargement = false);
    }
  }

  String? _obligatoire(String? v, {int max = 50}) {
    if (v == null || v.trim().isEmpty) return 'Champ obligatoire';
    if (v.trim().length > max) return '$max caractères maximum';
    return null;
  }

  Widget _champ(TextEditingController c, String label, IconData icone,
      {int max = 50}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: c,
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(
            labelText: label,
            prefixIcon: Icon(icone),
            border: const OutlineInputBorder()),
        validator: (v) => _obligatoire(v, max: max),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(_edition ? 'Modifier le membre' : 'Ajouter un membre')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _menuImage,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    _image != null
                        ? CircleAvatar(
                            radius: 54, backgroundImage: FileImage(_image!))
                        : MembreAvatar(
                            url: widget.membre?.imageUrl, radius: 54),
                    const CircleAvatar(
                        radius: 16, child: Icon(Icons.camera_alt, size: 16)),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              const Text('Touchez pour changer la photo (facultatif)',
                  style: TextStyle(color: Colors.grey, fontSize: 12)),
              const SizedBox(height: 20),
              _champ(_nom, 'Nom', Icons.badge),
              _champ(_postnom, 'Postnom', Icons.badge_outlined),
              _champ(_prenom, 'Prénom', Icons.person),
              _champ(_lieu, 'Lieu de naissance', Icons.location_city, max: 100),
              Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: TextFormField(
                  controller: _date,
                  readOnly: true,
                  onTap: _choisirDate,
                  decoration: const InputDecoration(
                    labelText: 'Date de naissance (AAAA-MM-JJ)',
                    prefixIcon: Icon(Icons.cake),
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => (v == null || v.isEmpty)
                      ? 'Choisissez une date'
                      : null,
                ),
              ),
              _champ(_parente, 'Lien de parenté (Père, Mère, Frère…)',
                  Icons.family_restroom),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton.icon(
                  onPressed: _chargement ? null : _enregistrer,
                  icon: _chargement
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.save),
                  label: Text(_edition ? 'Enregistrer' : 'Ajouter'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
