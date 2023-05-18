import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      "User Name",
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).primaryTextTheme.headlineSmall,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.settings,
                    ),
                  )
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Divider(),
            ),
            const Spacer(flex: 3),
            Image.asset("images/happy_dog.gif"),
            const Spacer(),
            Text(
              "Tu jeszcze nic nie ma!",
              style: Theme.of(context).primaryTextTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Wciąż pracujemy nad tym, aby wszystkie zwierzaki były szczęśliwe.",
                style: Theme.of(context).primaryTextTheme.bodyMedium,
                textAlign: TextAlign.center,
                textScaleFactor: 0.8,
              ),
            ),
            const Spacer(flex: 3),
          ],
        ),
      ),
    );
  }
}
