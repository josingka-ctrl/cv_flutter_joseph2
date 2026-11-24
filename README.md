# cv_flutter_joseph

Application mobile Flutter présentant le **CV**, la **famille** et les **contacts** de AKONKWA SIRINGI joseph.
La gestion des membres de la famille et l'authentification passent par une **API REST** (PHP + MySQL) :
https://github.com/espoirbaraka/api-test

## Fonctionnalités
- **Connexion réelle** (e-mail + mot de passe) via l'API, **création de compte**, session conservée, déconnexion
- **Accueil / CV** : photo, nom, profil, formation, expériences, compétences, langues, centres d'intérêt
- **Famille (CRUD via l'API)** : consulter, ajouter (avec photo), modifier, supprimer. Données enregistrées en base MySQL
- **Contact** : téléphone, e-mail, adresse, LinkedIn, GitHub, Facebook (liens cliquables)
- Navigation par barre du bas, gestion des erreurs et indicateurs de chargement

## Démonstration vidéo
▶️ **[Voir la vidéo de démonstration](demo/demo.mp4)**

## Captures d'écran

| Connexion | Accueil (CV) |
|---|---|
| ![Connexion](screenshots/01_connexion.png) | ![Accueil](screenshots/02_accueil.png) |

| Famille | Contact |
|---|---|
| ![Famille](screenshots/03_famille.png) | ![Contact](screenshots/04_contact.png) |

## Installation et exécution

### 1. Lancer l'API
1. Démarrer **Apache** et **MySQL** dans XAMPP.
2. Placer l'API dans `C:\xampp\htdocs\api-test`.
3. Créer la base `api` et importer `api.sql` (phpMyAdmin).
4. Copier `.env.example` en `.env`.
5. Vérifier : http://localhost/api-test/public/famille-membres renvoie du JSON.

### 2. Lancer l'application
```bash
flutter pub get
flutter run
```
- **Émulateur Android** : l'adresse `10.0.2.2` est utilisée automatiquement.
- **Téléphone réel** : renseigner l'IP du PC dans `lib/config.dart` (`kHoteApiManuel`).
- Android doit autoriser le HTTP : voir `android_manifest_snippet.xml` (fait automatiquement par `setup.bat`).

## Structure
```
lib/
├── main.dart
├── config.dart              # adresse de l'API
├── data.dart                # données du CV
├── models/membre.dart
├── services/
│   ├── api_service.dart     # appels HTTP (login, register, CRUD membres)
│   └── session.dart         # session locale
├── widgets/ (avatar.dart, membre_avatar.dart)
└── pages/
    ├── login_page.dart, register_page.dart, main_shell.dart
    ├── home_page.dart, family_page.dart, member_form_page.dart
    └── contact_page.dart
```
