import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_share/login_register/cubit.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  Future<bool?> showSignOutDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: const Text("Czy na pewno chcesz się wylogować?"),
          contentPadding: const EdgeInsets.all(16.0),
          actions: [
            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(
                  Colors.grey,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text("Nie"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text("Tak"),
            ),
          ],
        );
      },
    );
  }

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
                  Row(
                    children: [
                      IconButton(
                        onPressed: () async {
                          await showSignOutDialog(context).then((value) {
                            if (value == true) {
                              context.read<AuthCubit>().signOut();
                            }
                          });
                        },
                        icon: const Icon(
                          Icons.logout,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.settings,
                        ),
                      ),
                    ],
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
