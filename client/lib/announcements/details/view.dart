import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pet_share/announcements/added_announcements/announcement_tile.dart';
import 'package:pet_share/announcements/added_announcements/cubit.dart';
import 'package:pet_share/announcements/models/announcement.dart';
import 'package:url_launcher/url_launcher.dart';

class AnnouncementAndPetDetails extends StatefulWidget {
  const AnnouncementAndPetDetails({super.key, required this.announcement});
  final Announcement announcement;

  @override
  State<AnnouncementAndPetDetails> createState() =>
      _AnnouncementAndPetDetailsState();
}

class _AnnouncementAndPetDetailsState extends State<AnnouncementAndPetDetails>
    with TickerProviderStateMixin {
  late AnimationController _colorAnimationController;
  late AnimationController _textAnimationController;
  late Animation _colorTween, _iconColorTween, _textColorTween;

  @override
  void initState() {
    _colorAnimationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 0));
    _colorTween = ColorTween(begin: Colors.transparent, end: Colors.white)
        .animate(_colorAnimationController);
    _iconColorTween = ColorTween(begin: Colors.white, end: Colors.black)
        .animate(_colorAnimationController);
    _textColorTween = ColorTween(begin: Colors.transparent, end: Colors.black)
        .animate(_colorAnimationController);

    _textAnimationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 0));

    super.initState();
  }

  bool _scrollListener(ScrollNotification scrollInfo) {
    if (scrollInfo.metrics.axis == Axis.vertical) {
      _colorAnimationController.animateTo(scrollInfo.metrics.pixels / 200);

      _textAnimationController
          .animateTo((scrollInfo.metrics.pixels - 200) / 50);
      return true;
    }

    return false;
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: AnimatedBuilder(
        animation: _colorAnimationController,
        builder: (context, child) => AppBar(
          backgroundColor: _colorTween.value,
          title: Text(widget.announcement.title,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: _textColorTween.value,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          leading: IconButton(
              color: _iconColorTween.value,
              onPressed: () =>
                  context.read<ListOfAnnouncementsCubit>().goBack(),
              icon: const Icon(
                Icons.arrow_back,
              )),
          actionsIconTheme: IconThemeData(color: _iconColorTween.value),
          actions: <Widget>[
            _buildPopUpMenuButton(context),
          ],
          titleSpacing: 5,
        ),
      ),
    );
  }

  PopupMenuButton _buildPopUpMenuButton(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) => [
        const PopupMenuItem<int>(
          value: 0,
          child: TextWithBasicStyle(
            text: "Usuń ogłoszenie",
          ),
        ),
      ],
      onSelected: (item) => {
        if (item == 0)
          showDialogWhenDeletingAnnouncement(context, widget.announcement)
      },
    );
  }

  void showDialogWhenDeletingAnnouncement(
      BuildContext context, Announcement announcement) {
    showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: const TextWithBasicStyle(
          text: 'Czy na pewno chcesz usunąć to ogłoszenie?',
          textScaleFactor: 1.2,
          align: TextAlign.center,
        ),
        actions: <Widget>[
          Row(
            children: [
              _buildDeleteButton(context, 'Tak', true),
              _buildDeleteButton(context, 'Anuluj', false)
            ],
          )
        ],
      ),
    ).then((value) => {
          if (value != null && value)
            {
              context
                  .read<GridOfAnnouncementsCubit>()
                  .deleteAnnouncement(announcement),
            }
        });
  }

  Widget _buildDeleteButton(
      BuildContext context, String text, bool doesDelete) {
    return Expanded(
      child: TextButton(
        onPressed: () => {Navigator.pop(context, doesDelete)},
        child: TextWithBasicStyle(
          text: text,
          textScaleFactor: 1.2,
        ),
      ),
    );
  }

  final ScrollController _scrollController = ScrollController();

  Widget _buildInputs(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Header(announcement: widget.announcement),
          Body(announcement: widget.announcement),
        ],
      ),
    );
  }

  Widget _buildAddress(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: TextWithBasicStyle(
          // ignore: prefer_interpolation_to_compose_strings, prefer_adjacent_string_concatenation
          text: "ul. ${widget.announcement.pet.shelter.address.street}, ${widget.announcement.pet.shelter.address.postalCode} " +
              "${widget.announcement.pet.shelter.address.city}\n ${widget.announcement.pet.shelter.address.province}, " +
              // ignore: unnecessary_string_interpolations
              "${widget.announcement.pet.shelter.address.country}",
          textScaleFactor: 1.2,
          align: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildContactList(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 4,
            width: 100,
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 16),
            child: TextWithBasicStyle(
              text:
                  "Skontaktuj się ze schroniskiem ${widget.announcement.pet.shelter.fullShelterName}",
              textScaleFactor: 1.3,
              align: TextAlign.center,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildContactButton(
                context,
                "Zadzwoń",
                Icons.phone,
                () => CallUtils.openDialer(
                    widget.announcement.pet.shelter.phoneNumber, context)),
            _buildContactButton(
                context,
                "Napisz maila",
                Icons.email,
                () => CallUtils.openDialerForEmail(
                    widget.announcement.pet.shelter.email, context)),
          ],
        ),
        _buildAddress(context),
        TextButton(
          child: const TextWithBasicStyle(
            text: "Zamknij",
            textScaleFactor: 1.2,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _buildContactButton(
      BuildContext context, String text, IconData icon, Function onPressed) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton.icon(
            onPressed: onPressed as void Function()?,
            icon: Icon(icon),
            label: TextWithBasicStyle(
              text: text,
            )),
      ),
    );
  }

  BottomAppBar _buildBottomAppBar(BuildContext context) {
    return BottomAppBar(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.grey.shade100)),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => _buildContactList(context),
                      );
                    },
                    child: const Text("Kontakt")),
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: ElevatedButton(
                  key: const Key('next'),
                  onPressed: () {
                    context.read<GridOfAnnouncementsCubit>().adopt(
                        "1ae57d7b-acfe-456f-3f70-08db3c140a81",
                        widget.announcement);
                  },
                  child: const Text("Aplikuj"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<GridOfAnnouncementsCubit>().goBack();
        return false;
      },
      child: NotificationListener<ScrollNotification>(
        onNotification: _scrollListener,
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: _buildAppBar(context),
          bottomNavigationBar: _buildBottomAppBar(context),
          body: _buildInputs(context),
        ),
      ),
    );
  }
}

class CallUtils {
  CallUtils._();

  static Future<void> openDialer(
      String phoneNumber, BuildContext context) async {
    Uri callUrl = Uri(scheme: 'tel', path: phoneNumber);
    open(callUrl, context);
  }

  static Future<void> openDialerForEmail(
      String email, BuildContext context) async {
    Uri callUrl = Uri(scheme: 'mailto', path: email);
    open(callUrl, context);
  }

  static Future<void> open(Uri uri, BuildContext context) async {
    try {
      await launchUrl(uri);
    } catch (e) {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Nie udała się próba połączenia ze schroniskiem'),
          content: const Text('Spróbuj ponownie później'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}

class Body extends StatelessWidget {
  const Body({super.key, required this.announcement});
  final Announcement announcement;

  final description =
      "Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Fusce malesuada varius imperdiet. Etiam eget augue risus. Vivamus ut eros sit amet ligula consectetur placerat et et metus. Nulla mauris sem, porttitor nec bibendum ut, mollis eget neque. Nullam eget diam at sapien gravida volutpat vitae sed nibh. Aliquam cursus sollicitudin nunc ac facilisis. Donec at fringilla metus, at volutpat eros. Sed massa lectus, blandit sit amet mi non, fringilla placerat justo.";

  final longDescription =
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam placerat lorem non vestibulum condimentum. Mauris efficitur nisi et erat efficitur, a varius tortor semper. Suspendisse mattis, nibh at consequat fringilla, nisl tortor fermentum urna, vestibulum facilisis enim diam eget enim. Integer scelerisque lacus a fermentum suscipit. Quisque at auctor ante, ac tristique diam. Cras varius, tellus id pulvinar malesuada, eros leo pulvinar quam, sed malesuada ex lorem in purus. Donec consequat massa at congue tempor. Nunc bibendum metus sit amet diam tristique, eget ultricies risus finibus. Nullam tempor auctor aliquam. Nunc et tristique turpis. Vestibulum eu elit tristique, gravida ante non, condimentum tellus. Aenean eget nibh egestas, lacinia lacus at, ullamcorper sem. Nulla facilisi. Nam libero turpis, cursus at posuere eu, pharetra vitae lorem. Pellentesque risus velit, vestibulum non tristique eget, laoreet vitae ipsum. Vestibulum a metus lacinia, suscipit eros id, facilisis lacus.";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Tytuł ogłoszenia",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium,
            textScaleFactor: 1.2,
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 16),
          Text(
            longDescription,
            style: Theme.of(context).textTheme.bodyMedium,
            textScaleFactor: 1.2,
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({super.key, required this.announcement});
  final Announcement announcement;

  String _formatDate(DateTime? date) {
    return date != null ? DateFormat('dd.MM.yyyy').format(date) : "";
  }

  String _statusToString(AnnouncementStatus status) {
    switch (status) {
      case AnnouncementStatus.open:
        return "Szuka domu";
      case AnnouncementStatus.closed:
        return "Już ma swoj dom";
      case AnnouncementStatus.removed:
        return "Usunięto";
      case AnnouncementStatus.inVerification:
        return "Jest odwiedzane";
    }
  }

  Color _statusToColor(AnnouncementStatus status) {
    switch (status) {
      case AnnouncementStatus.open:
        return Colors.green.shade300;
      case AnnouncementStatus.closed:
        return Colors.red.shade300;
      case AnnouncementStatus.removed:
        return Colors.red.shade700;
      case AnnouncementStatus.inVerification:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(10),
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(
                  minHeight: 400, maxHeight: 400, minWidth: double.maxFinite),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                ),
                child: announcement.pet.photoUrl != null
                    ? CachedNetworkImage(
                        imageUrl: announcement.pet.photoUrl!, fit: BoxFit.cover)
                    : Container(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 2.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: Colors.orange.shade500,
                      width: 6,
                    ),
                  ),
                  gradient: LinearGradient(
                    transform: const GradientRotation(pi / 4),
                    stops: const [0.015, 0.4, 0.5, 0.85, 1],
                    colors: [
                      Colors.white,
                      Colors.grey.shade50,
                      Colors.grey.shade100,
                      Colors.grey.shade200,
                      Colors.grey.shade300,
                    ],
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Wrap(
                    spacing: 8.0,
                    runSpacing: -8.0,
                    children: [
                      if (announcement.pet.name.isNotEmpty)
                        Chip(
                          label: Text(
                            "Imię: ${announcement.pet.name}",
                          ),
                        ),
                      Chip(
                          label: Text(
                              "Data urodzenia: ${_formatDate(announcement.pet.birthday)}")),
                      if (announcement.pet.species.isNotEmpty)
                        Chip(
                            label:
                                Text("Gatunek: ${announcement.pet.species}")),
                      if (announcement.pet.breed.isNotEmpty)
                        Chip(label: Text("Rasa: ${announcement.pet.breed}")),
                      Chip(
                        label: Text(_statusToString(announcement.status)),
                        backgroundColor: _statusToColor(announcement.status),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TextWithBasicStyle extends StatelessWidget {
  const TextWithBasicStyle(
      {super.key,
      required this.text,
      this.textScaleFactor = 1.0,
      this.align,
      this.bold = false});

  final String text;
  final double textScaleFactor;
  final bool bold;
  final TextAlign? align;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textScaleFactor: textScaleFactor,
      textAlign: align,
      style: TextStyle(
        fontFamily: "Quicksand",
        fontWeight: bold ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}

class BoldTextWithBasicStyle extends StatelessWidget {
  const BoldTextWithBasicStyle(
      {super.key, required this.text, this.textScaleFactor = 1.0});

  final String text;
  final double textScaleFactor;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textScaleFactor: textScaleFactor,
      style: const TextStyle(
        fontFamily: "Quicksand",
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
