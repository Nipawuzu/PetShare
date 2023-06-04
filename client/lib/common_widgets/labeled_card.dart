import 'package:flutter/material.dart';

class LabeledCard extends StatelessWidget {
  const LabeledCard(
      {super.key, required this.label, required this.children, this.color});

  final String label;
  final List<Widget> children;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              textAlign: TextAlign.left,
              style: Theme.of(context).inputDecorationTheme.labelStyle,
            ),
            const SizedBox(
              height: 4,
            ),
            for (final child in children) child,
          ],
        ),
      ),
    );
  }
}
