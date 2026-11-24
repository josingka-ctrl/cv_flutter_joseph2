import 'package:flutter/material.dart';
import '../services/session.dart';
import 'contact_page.dart';
import 'family_page.dart';
import 'home_page.dart';
import 'login_page.dart';

/// Navigation par barre du bas + déconnexion (efface la session).
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  static const _titres = ['Mon CV', 'Ma famille', 'Contact'];
  final _pages = const [HomePage(), FamilyPage(), ContactPage()];

  Future<void> _deconnexion() async {
    await Session.effacer();
    if (!mounted) return;
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => const LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titres[_index]),
        actions: [
          IconButton(
            tooltip: 'Se déconnecter',
            icon: const Icon(Icons.logout),
            onPressed: _deconnexion,
          ),
        ],
      ),
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Accueil'),
          NavigationDestination(
              icon: Icon(Icons.family_restroom), label: 'Famille'),
          NavigationDestination(
              icon: Icon(Icons.contact_mail), label: 'Contact'),
        ],
      ),
    );
  }
}
