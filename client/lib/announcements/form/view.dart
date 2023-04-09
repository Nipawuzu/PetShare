import 'dart:typed_data';

import 'package:bottom_picker/bottom_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pet_share/announcements/form/cubit.dart';
import 'package:pet_share/announcements/new_announcement.dart';
import 'package:pet_share/announcements/new_pet.dart';
import 'package:pet_share/announcements/service.dart';

class NewAnnouncementForm extends StatefulWidget {
  const NewAnnouncementForm(this.announcementService, {super.key});

  final AnnouncementService announcementService;

  @override
  State<NewAnnouncementForm> createState() => _NewAnnouncementFormState();
}

class _NewAnnouncementFormState extends State<NewAnnouncementForm> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AnnouncementFormCubit(widget.announcementService),
      child: BlocBuilder<AnnouncementFormCubit, AnnouncementFormState>(
        builder: (context, state) {
          if (state is PetFormState) {
            return PetFormPage(state: state);
          } else if (state is DetailsFormState) {
            return AnnouncementFormPage(state: state);
          } else if (state is SendingFormState) {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      "Wysyłanie ogłoszenia...",
                      textScaleFactor: 1.5,
                    ),
                  ],
                ),
              ),
            );
          } else if (state is FormSentState) {
            Future.delayed(
              const Duration(seconds: 2),
              () => Navigator.of(context).pop(),
            );

            return Scaffold(
              body: Center(
                  child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    "Ogłoszenie zostało wysłane",
                    textScaleFactor: 1.5,
                  ),
                  Icon(Icons.done)
                ],
              )),
            );
          } else if (state is FormErrorState) {
            Future.delayed(
              const Duration(seconds: 2),
              () => Navigator.of(context).pop(),
            );

            return Scaffold(
              body: Center(
                  child: Padding(
                padding: const EdgeInsets.all(50.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Flexible(
                      child: Text(
                        "Wystąpił błąd poczas próby wysłania ogłoszenia. Spróbuj ponownie później.",
                        textScaleFactor: 1.5,
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Icon(
                      Icons.error,
                      color: Colors.red,
                    )
                  ],
                ),
              )),
            );
          }

          return Container();
        },
      ),
    );
  }
}

class PetFormPage extends StatefulWidget {
  const PetFormPage({super.key, required this.state});

  final PetFormState state;

  @override
  State<PetFormPage> createState() => _PetFormPageState();
}

class _PetFormPageState extends State<PetFormPage> {
  NewPet _pet = NewPet();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _pet = widget.state.announcement.pet ?? _pet;
    _datePickerController.text =
        _formatDate(widget.state.announcement.pet?.birthday);
    _pickedPhoto = widget.state.announcement.pet?.photo;
  }

  String _formatDate(DateTime? date) {
    return date != null ? DateFormat('dd.MM.yyyy').format(date) : "";
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      toolbarHeight: 64,
      leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close)),
      titleSpacing: 0,
      title: const Text('Nowe ogłoszenie'),
    );
  }

  Widget _buildPetList(BuildContext context) {
    return Column(
      children: const [],
    );
  }

  Uint8List? _pickedPhoto;

  Widget _buildImage(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
          ),
          child: InkWell(
            onTap: () async {
              var img = await ImagePicker().pickImage(
                source: ImageSource.gallery,
              );
              _pickedPhoto = await img?.readAsBytes();
              setState(() {});
            },
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  minHeight: _pickedPhoto == null ? 250 : 0,
                  minWidth: double.maxFinite),
              child: _pickedPhoto == null
                  ? const Icon(
                      Icons.camera_alt_outlined,
                      size: 64,
                    )
                  : Image.memory(_pickedPhoto!),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNameField(BuildContext context) {
    return TextFormField(
      initialValue: _pet.name,
      onSaved: (newValue) => _pet.name = newValue.toString(),
      decoration: InputDecoration(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text("Imię zwierzątka"),
            SizedBox(width: 1),
            Text('*', style: TextStyle(color: Colors.red)),
          ],
        ),
      ),
      validator: (value) =>
          value?.isEmpty ?? false ? "Wpisz nazwę zwierzątka" : null,
    );
  }

  final TextEditingController _datePickerController = TextEditingController();
  Widget _buildBirthdayField(BuildContext context) {
    return TextFormField(
      validator: (value) =>
          value?.isEmpty ?? false ? "Wybierz datę urodzenia zwierzątka" : null,
      readOnly: true,
      controller: _datePickerController,
      decoration: InputDecoration(
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text("Data urodzenia"),
              SizedBox(width: 1),
              Text('*', style: TextStyle(color: Colors.red)),
            ],
          ),
          suffixIcon: IconButton(
              onPressed: () => BottomPicker.date(
                    displayButtonIcon: false,
                    buttonText: "Wybierz",
                    buttonTextStyle:
                        const TextStyle(color: Colors.white, fontSize: 16),
                    buttonSingleColor: Colors.orange,
                    title: "Data urodzenia",
                    onSubmit: (date) => setState(
                      () {
                        _pet.birthday = date;
                        _datePickerController.text = _formatDate(date);
                      },
                    ),
                  ).show(context),
              icon: const Icon(Icons.calendar_month))),
    );
  }

  Widget _buildSpeciesField(BuildContext context) {
    return TextFormField(
      initialValue: _pet.species,
      onSaved: (newValue) => _pet.species = newValue?.trim() ?? '',
      decoration: InputDecoration(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text("Gatunek"),
            SizedBox(width: 1),
            Text('*', style: TextStyle(color: Colors.red)),
          ],
        ),
      ),
      validator: (value) =>
          value?.isEmpty ?? false ? "Wpisz gatunek zwierzątka" : null,
    );
  }

  Widget _buildBreedField(BuildContext context) {
    return TextFormField(
      initialValue: _pet.breed,
      onSaved: (newValue) => _pet.breed = newValue?.trim() ?? '',
      decoration: const InputDecoration(
        labelText: "Rasa",
      ),
    );
  }

  Widget _buildDescriptionField(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 216),
      child: TextFormField(
        initialValue: _pet.description,
        onSaved: (newValue) => _pet.description = newValue?.trim() ?? '',
        minLines: 5,
        maxLines: null,
        decoration: const InputDecoration(
            labelText: "Opis zwierzątka", alignLabelWithHint: true),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
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
                        builder: (context) => _buildPetList(context),
                      );
                    },
                    child: const Text("Wybierz z listy...")),
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      _pet.photo = _pickedPhoto;
                      widget.state.announcement.pet = _pet;
                      context
                          .read<AnnouncementFormCubit>()
                          .createPet(widget.state.announcement);
                    }
                  },
                  child: const Text("Dalej"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputs(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildImage(context),
            const SizedBox(
              height: 32,
            ),
            _buildNameField(context),
            const SizedBox(
              height: 16,
            ),
            _buildBirthdayField(context),
            const SizedBox(
              height: 16,
            ),
            _buildSpeciesField(context),
            const SizedBox(
              height: 16,
            ),
            _buildBreedField(context),
            const SizedBox(
              height: 16,
            ),
            _buildDescriptionField(context),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24),
              child: _buildInputs(context),
            ),
          ),
          _buildActionButtons(context),
        ],
      ),
    );
  }
}

class AnnouncementFormPage extends StatefulWidget {
  const AnnouncementFormPage({super.key, required this.state});

  final DetailsFormState state;

  @override
  State<AnnouncementFormPage> createState() => _AnnouncementFormPageState();
}

class _AnnouncementFormPageState extends State<AnnouncementFormPage> {
  final _formKey = GlobalKey<FormState>();
  late NewAnnouncement _announcement;

  @override
  void initState() {
    super.initState();
    _announcement = widget.state.announcement;
  }

  String _formatAge(DateTime birthday) {
    var days = DateTime.now()
        .difference(widget.state.announcement.pet!.birthday!)
        .inDays;

    if (days > 365) {
      var years = days ~/ 365;
      return "$years lat";
    } else if (days > 30) {
      return "${days ~/ 30} miesięcy";
    }

    return "$days dni";
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      toolbarHeight: 64,
      titleSpacing: 0,
      title: const Text("Nowe ogłoszenie"),
    );
  }

  Widget _buildPetInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                  maxHeight: 250, minWidth: double.maxFinite),
              child: _announcement.pet?.photo != null
                  ? Image.memory(_announcement.pet!.photo!, fit: BoxFit.cover)
                  : const Icon(
                      Icons.camera_alt_outlined,
                      size: 64,
                    ),
            ),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Wrap(
          alignment: WrapAlignment.start,
          spacing: 4.0,
          children: [
            if (_announcement.pet?.name.isNotEmpty ?? false)
              Chip(label: Text("Imię: ${_announcement.pet!.name}")),
            if (_announcement.pet?.species.isNotEmpty ?? false)
              Chip(label: Text("Gatunek: ${_announcement.pet!.species}")),
            if (_announcement.pet?.breed.isNotEmpty ?? false)
              Chip(label: Text("Rasa: ${_announcement.pet!.breed}")),
            if (_announcement.pet?.birthday != null)
              Chip(
                  label:
                      Text("Wiek: ${_formatAge(_announcement.pet!.birthday!)}"))
          ],
        )
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
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
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      context
                          .read<AnnouncementFormCubit>()
                          .submit(_announcement);
                    }
                  },
                  child: const Text("Dodaj ogłoszenie"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputs(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildPetInfo(),
            const SizedBox(
              height: 24,
            ),
            TextFormField(
              onSaved: (newValue) =>
                  _announcement.title = newValue?.trim() ?? '',
              decoration: const InputDecoration(
                labelText: "Tytuł ogłoszenia",
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 216),
              child: TextFormField(
                onSaved: (newValue) =>
                    _announcement.description = newValue?.trim() ?? '',
                minLines: 5,
                maxLines: null,
                decoration: const InputDecoration(
                  labelText: "Opis ogłoszenia",
                  alignLabelWithHint: true,
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
        context.read<AnnouncementFormCubit>().goBack();
        return false;
      },
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24),
                child: _buildInputs(context),
              ),
            ),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }
}
