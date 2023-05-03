import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:like_button/like_button.dart';
import 'package:pet_share/announcements/added_announcements/cubit.dart';
import 'package:pet_share/announcements/details/view.dart';
import 'package:pet_share/announcements/models/announcement.dart';
import 'package:pet_share/common_widgets/image.dart';

class AnnouncementTile extends StatelessWidget {
  const AnnouncementTile({super.key, required this.announcement});
  final Announcement announcement;

  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            children: [
              ImageWidget(
                image: announcement.pet.photoUrl,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Wrap(
                          spacing: 8.0,
                          runSpacing: 4.0,
                          children: <Widget>[
                            TextWithBasicStyle(
                              text: announcement.pet.name,
                              bold: true,
                              textScaleFactor: 1.2,
                            ),
                            TextWithBasicStyle(
                              text: formatAge(announcement.pet.birthday),
                              textScaleFactor: 1.2,
                            ),
                          ]),
                    ),
                    LikeButton(
                      size: 36,
                      likeBuilder: (bool isLiked) {
                        return Icon(
                          Icons.favorite,
                          color: isLiked ? Colors.orange : Colors.grey,
                          size: 36,
                        );
                      },
                      onTap: (isLiked) {
                        if (announcement.id != null) {
                          context
                              .read<GridOfAnnouncementsCubit>()
                              .like("", announcement.id!, !isLiked);
                        }

                        return Future.value(!isLiked);
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

String statusToString(AnnouncementStatus status) {
  switch (status) {
    case AnnouncementStatus.open:
      return "Otwarte";
    case AnnouncementStatus.closed:
      return "Zamknięte";
    case AnnouncementStatus.removed:
      return "Usunięte";
    case AnnouncementStatus.inVerification:
      return "Użytkownik w trakcie weryfikacji";
  }
}

Color statusToColor(AnnouncementStatus status) {
  switch (status) {
    case AnnouncementStatus.open:
      return Colors.green;
    case AnnouncementStatus.closed:
      return Colors.red;
    case AnnouncementStatus.removed:
      return Colors.brown;
    case AnnouncementStatus.inVerification:
      return Colors.blue;
  }
}

String formatAge(DateTime? birthday) {
  if (birthday == null) {
    return "";
  }

  var days = DateTime.now().difference(birthday).inDays;

  if (days > 365) {
    return formatYears(days ~/ 365);
  } else if (days > 30) {
    return formatMonths(days ~/ 30);
  }

  return formatDays(days);
}

String formatYears(int years) {
  if (years > 4) {
    return "$years lat";
  } else if (years > 1) {
    return "$years lata";
  } else if (years == 1) {
    return "$years rok";
  } else {
    return "";
  }
}

String formatMonths(int months) {
  if (months > 4) {
    return "$months miesięcy";
  } else if (months > 1) {
    return "$months miesiące";
  } else if (months == 1) {
    return "$months miesiąc";
  } else {
    return "";
  }
}

String formatDays(int days) {
  if (days > 4) {
    return "$days dni";
  } else if (days == 1) {
    return "$days dzień";
  } else {
    return "";
  }
}
