import 'package:flutter/material.dart';

/// Photo ronde d'un membre, chargée depuis l'API (icône si absente).
class MembreAvatar extends StatelessWidget {
  final String? url;
  final double radius;
  const MembreAvatar({super.key, this.url, this.radius = 28});

  @override
  Widget build(BuildContext context) {
    final fond = Theme.of(context).colorScheme.primaryContainer;
    final icone = Icon(Icons.person, size: radius);
    return CircleAvatar(
      radius: radius,
      backgroundColor: fond,
      child: url == null
          ? icone
          : ClipOval(
              child: Image.network(
                url!,
                width: radius * 2,
                height: radius * 2,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => icone,
                loadingBuilder: (c, child, p) => p == null
                    ? child
                    : const Center(
                        child: SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2))),
              ),
            ),
    );
  }
}
