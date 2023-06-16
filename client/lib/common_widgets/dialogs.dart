import 'package:flutter/material.dart';
import 'package:pet_share/announcements/details/view.dart';
import 'package:pet_share/services/service_response.dart';

void showDialogWithError(BuildContext context, String error) {
  showDialog<bool>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      content: TextWithBasicStyle(
        text: error,
        textScaleFactor: 1.2,
        align: TextAlign.center,
      ),
      actions: <Widget>[
        Center(
          child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const TextWithBasicStyle(
                text: 'OK',
              )),
        )
      ],
    ),
  );
}

void showAlertDialog<T>(
    BuildContext context,
    String action,
    TextSubject subject,
    Future<ServiceResponse<bool>> Function(T) afterYes,
    Function(T) rollbackChanges,
    T data) {
  showDialog<bool>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      contentPadding: const EdgeInsets.all(16.0),
      title: Text(
        "Czy na pewno chcesz $action ten ${getTextSubjectForAlertDialog(subject)}?",
      ),
      actions: [
        buildAlertButton(context, 'Anuluj', false),
        buildAlertButton(context, 'Tak', true),
      ],
    ),
  ).then((value) async => {
        if (value != null && value)
          {
            afterYes(data).then(
              (value) => checkAndActOnErrors(
                context,
                value,
                action,
                getTextSubjectForCheckAndActOnErrors(subject),
                rollbackChanges,
                data,
              ),
            )
          }
      });
}

Widget buildAlertButton(BuildContext context, String text, bool doesDelete) {
  return TextButton(
    style: ButtonStyle(
      foregroundColor: !doesDelete
          ? MaterialStateProperty.all<Color>(
              Colors.grey,
            )
          : null,
    ),
    onPressed: () => {Navigator.pop(context, doesDelete)},
    child: Text(
      text,
    ),
  );
}

void checkAndActOnErrors<T>(BuildContext context, ServiceResponse res,
    String action, String subject, Function(T) rollbackChanges, T data) {
  if (res.data != null) {
    Navigator.pop(context);
  } else {
    rollbackChanges(data);
    if (res.error == ErrorType.unauthorized) {
      showDialogWithError(
          context, "Nie jesteś uprawniony do $action tego $subject");
    } else if (res.error == ErrorType.badRequest) {
      showDialogWithError(context, "Nie znaleziono wybranego $subject");
    } else {
      showDialogWithError(context, "Nie udało się $action $subject");
    }
  }
}

enum TextSubject {
  announcement,
  application,
}

String getTextSubjectForAlertDialog(TextSubject subject) {
  switch (subject) {
    case TextSubject.announcement:
      return "ogłoszenie";
    case TextSubject.application:
      return "wniosek";
  }
}

String getTextSubjectForCheckAndActOnErrors(TextSubject subject) {
  switch (subject) {
    case TextSubject.announcement:
      return "ogłoszenia";
    case TextSubject.application:
      return "wniosku";
  }
}
