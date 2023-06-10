import 'package:flutter/material.dart';

class DefaultPage extends StatelessWidget {
  final Widget child;

  const DefaultPage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Theme.of(context).colorScheme.background,
          Theme.of(context).colorScheme.background,
          Theme.of(context).colorScheme.background,
          Theme.of(context).colorScheme.primaryContainer,
        ],
      )),
      child: child,
    );
  }
}
