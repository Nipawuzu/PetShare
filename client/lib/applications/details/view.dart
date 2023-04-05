import 'package:flutter/material.dart';
import 'package:pet_share/applications/application.dart';
import 'package:pet_share/common_widgets/custom_text_field.dart';
import 'package:pet_share/shelter.dart';
import 'package:pet_share/utils/datetime_format.dart';

class ApplicationDetails extends StatelessWidget {
  const ApplicationDetails(this.application, {super.key});

  final Application application;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Wniosek o adopcję")),
        bottomNavigationBar: const ApplicationBottomAppBar(),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  application.announcement.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 30,
                      fontFamily: "Quicksand",
                      fontWeight: FontWeight.bold),
                ),
              ),
              UserData(application.user),
              ApplicationData(application),
            ],
          ),
        ));
  }
}

class ApplicationBottomAppBar extends StatelessWidget {
  const ApplicationBottomAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: ElevatedButton(
                  onPressed: () {}, child: const Text("Zaakceptuj")),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: ElevatedButton(
                onPressed: () {},
                child: const Text("Odrzuć"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UserData extends StatelessWidget {
  const UserData(this.user, {super.key});

  final User user;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Dane składającego: ",
          style: TextStyle(
              fontFamily: "Quicksand",
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.orange),
        ),
        CustomTextField(
          firstText: "Imię i nazwisko: ",
          secondText: user.userName,
          isFirstTextInBold: true,
        ),
        CustomTextField(
          firstText: "Adres: ",
          secondText: user.address.toString(),
          isFirstTextInBold: true,
        ),
        const Text(
          "Kontakt:",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        CustomTextField(
          firstText: "Email: ",
          secondText: user.email,
          isFirstTextInBold: true,
        ),
        CustomTextField(
          firstText: "Telefon: ",
          secondText: user.phoneNumber,
          isFirstTextInBold: true,
        ),
      ],
    );
  }
}

class ApplicationData extends StatelessWidget {
  const ApplicationData(this.application, {super.key});

  final Application application;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Wniosek: ",
          style: TextStyle(
              fontFamily: "Quicksand",
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.orange),
        ),
        CustomTextField(
          firstText: "Data utworzenia: ",
          secondText: application.dateOfApplication.formatDay(),
          isFirstTextInBold: true,
        ),
        CustomTextField(
          firstText: "Data modyfikacji: ",
          secondText: application.lastUpdateDate.formatDay(),
          isFirstTextInBold: true,
        ),
      ],
    );
  }
}
