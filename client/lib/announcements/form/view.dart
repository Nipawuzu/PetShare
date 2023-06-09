import 'dart:typed_data';

import 'package:bottom_picker/bottom_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:intl/intl.dart';
import 'package:pet_share/announcements/form/cubit.dart';
import 'package:pet_share/announcements/models/new_announcement.dart';
import 'package:pet_share/announcements/models/new_pet.dart';
import 'package:pet_share/announcements/models/pet.dart';
import 'package:pet_share/common_widgets/gif_views.dart';
import 'package:pet_share/services/announcements/service.dart';

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
            return const Scaffold(
                body: CatProgressIndicator(
              text: Text("Wysyłanie ogłoszenia..."),
            ));
          } else if (state is FormSentState) {
            Future.delayed(
              const Duration(seconds: 2),
              () => Navigator.of(context).pop(),
            );

            return const Scaffold(
              body: Center(
                  child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
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
              const Duration(seconds: 5),
              () => Navigator.of(context).pop(),
            );

            return const Scaffold(
              body: RabbitErrorScreen(
                text: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Wystąpił błąd poczas próby wysłania ogłoszenia. Spróbuj ponownie później.",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
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
    return const Column(
      children: [],
    );
  }

  Widget _buildImage(BuildContext context) {
    return FormField<Uint8List>(
      key: const Key('image'),
      validator: (value) => value == null ? "Dodaj zdjęcie zwierzątka" : null,
      onSaved: (newValue) => _pet.photo = newValue,
      builder: (field) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            margin: EdgeInsets.zero,
            borderOnForeground: true,
            elevation: 0,
            color: Colors.grey.shade200,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                side: BorderSide(
                    width: 2,
                    color: field.hasError ? Colors.red : Colors.grey.shade200)),
            child: InkWell(
              onTap: () async {
                var img = await ImagePickerPlatform.instance.pickImage(
                  source: ImageSource.gallery,
                );
                var imgBytes = await img?.readAsBytes();

                setState(() {
                  // ignore: invalid_use_of_protected_member
                  field.setValue(imgBytes);
                });
              },
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    minHeight: field.value == null ? 250 : 0,
                    minWidth: double.infinity),
                child: field.value == null
                    ? const Icon(
                        Icons.camera_alt_outlined,
                        size: 64,
                      )
                    : Image.memory(field.value!),
              ),
            ),
          ),
          if (field.hasError)
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 3.0, horizontal: 12),
              child: Text(
                field.errorText!,
                style: Theme.of(context)
                    .primaryTextTheme
                    .labelMedium!
                    .copyWith(color: Theme.of(context).colorScheme.error),
              ),
            )
        ],
      ),
    );
  }

  Widget _buildNameField(BuildContext context) {
    return TextFormField(
      key: const Key('name'),
      initialValue: _pet.name,
      onSaved: (newValue) => _pet.name = newValue.toString(),
      decoration: InputDecoration(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Imię zwierzątka"),
            const SizedBox(width: 1),
            Text('*',
                style: TextStyle(color: Theme.of(context).colorScheme.error)),
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
      key: const Key('birthday'),
      validator: (value) =>
          value?.isEmpty ?? false ? "Wybierz datę urodzenia zwierzątka" : null,
      readOnly: true,
      controller: _datePickerController,
      decoration: InputDecoration(
          label: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
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
      key: const Key('species'),
      initialValue: _pet.species,
      onSaved: (newValue) => _pet.species = newValue?.trim() ?? '',
      decoration: const InputDecoration(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
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
      key: const Key('breed'),
      initialValue: _pet.breed,
      onSaved: (newValue) => _pet.breed = newValue?.trim() ?? '',
      decoration: const InputDecoration(
        labelText: "Rasa",
      ),
    );
  }

  Widget _buildSexField(BuildContext context) {
    return DropdownButtonFormField(
      key: const Key('sex'),
      onSaved: (newValue) => _pet.sex = newValue ?? Sex.Unknown,
      decoration: const InputDecoration(
        labelText: "Płeć",
      ),
      items: Sex.values.map<DropdownMenuItem<Sex>>((Sex value) {
        return DropdownMenuItem<Sex>(
          value: value,
          child: Text(sexToString(value)),
        );
      }).toList(),
      onChanged: (Sex? newValue) => {},
    );
  }

  Widget _buildDescriptionField(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 216),
      child: TextFormField(
        key: const Key('description'),
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
                  key: const Key('next'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
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
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildImage(context),
              const SizedBox(
                height: 16,
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
              _buildSexField(context),
              const SizedBox(
                height: 16,
              ),
              _buildDescriptionField(context),
            ],
          ),
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
            child: _buildInputs(context),
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
                  minHeight: 250, minWidth: double.maxFinite),
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
                  key: const Key('submit'),
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
              key: const Key("title"),
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
                key: const Key('description'),
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
