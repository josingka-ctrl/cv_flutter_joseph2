import 'package:flutter/material.dart';

/// Photo ronde chargée depuis les assets (icône si l'image est introuvable).
class Avatar extends StatelessWidget {
  final String asset;
  final double radius;
  const Avatar({super.key, required this.asset, this.radius = 30});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      child: ClipOval(
        child: Image.asset(
          asset,
          width: radius * 2,
          height: radius * 2,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Icon(Icons.person, size: radius),
        ),
      ),
    );
  }
}
