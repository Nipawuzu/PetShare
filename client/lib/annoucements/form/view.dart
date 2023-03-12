import 'package:bottom_picker/bottom_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pet_share/annoucements/announcement.dart';
import 'package:pet_share/annoucements/form/cubit.dart';
import 'package:pet_share/annoucements/pet.dart';

class NewAnnoucementForm extends StatefulWidget {
  const NewAnnoucementForm({super.key});

  @override
  State<NewAnnoucementForm> createState() => _NewAnnoucementFormState();
}

class _NewAnnoucementFormState extends State<NewAnnoucementForm> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AnnoucementFormCubit(),
      child: BlocBuilder<AnnoucementFormCubit, AnnouncementFormState>(
        builder: (context, state) {
          if (state is PetFormState) {
            return PetFormPage(state: state);
          } else if (state is DetailsFormState) {
            return AnnoucementFormPage(state: state);
          } else if (state is SendingFormState) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
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
  Pet pet = Pet();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _datePickerController.text = _formatDate(widget.state.pet?.birthday);
    pet.birthday = widget.state.pet?.birthday;
  }

  String _formatDate(DateTime? date) {
    return date != null ? DateFormat('dd.MM.yyyy').format(date) : "";
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
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

  Widget _buildImage(BuildContext context) {
    return Center(
      child: DecoratedBox(
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
              width: 4,
            ),
            borderRadius: BorderRadius.circular(20)),
        child: InkWell(
          onTap: () {},
          child: const SizedBox.square(
            dimension: 250,
            child: Icon(
              Icons.camera_alt_outlined,
              size: 64,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNameField(BuildContext context) {
    return TextFormField(
      initialValue: widget.state.pet?.name,
      onSaved: (newValue) => pet.name = newValue.toString(),
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
                        pet.birthday = date;
                        _datePickerController.text = _formatDate(date);
                      },
                    ),
                  ).show(context),
              icon: const Icon(Icons.calendar_month))),
    );
  }

  Widget _buildSpeciesField(BuildContext context) {
    return TextFormField(
      initialValue: widget.state.pet?.species,
      onSaved: (newValue) => pet.species = newValue.toString().trim(),
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
      initialValue: widget.state.pet?.breed,
      onSaved: (newValue) => pet.breed = newValue.toString().trim(),
      decoration: const InputDecoration(
        labelText: "Rasa",
      ),
    );
  }

  Widget _buildDescriptionField(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 216),
      child: TextFormField(
        initialValue: widget.state.pet?.description,
        onSaved: (newValue) => pet.description = newValue.toString().trim(),
        minLines: 5,
        maxLines: null,
        decoration: const InputDecoration(
            labelText: "Opis zwierzątka", alignLabelWithHint: true),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => _buildPetList(context),
                );
              },
              child: const Center(
                child: Text(
                  "Wybierz z listy...",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      fontFamily: "Quicksand",
                      fontWeight: FontWeight.bold),
                ),
              )),
          TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                context.read<AnnoucementFormCubit>().choosePet(pet);
              }
            },
            child: const Text(
              "Next",
              style: TextStyle(
                  fontSize: 20,
                  fontFamily: "Quicksand",
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
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
              height: 24,
            ),
            _buildNameField(context),
            const SizedBox(
              height: 24,
            ),
            _buildBirthdayField(context),
            const SizedBox(
              height: 24,
            ),
            _buildSpeciesField(context),
            const SizedBox(
              height: 24,
            ),
            _buildBreedField(context),
            const SizedBox(
              height: 24,
            ),
            _buildDescriptionField(context),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildInputs(context),
      ),
    );
  }
}

class AnnoucementFormPage extends StatefulWidget {
  const AnnoucementFormPage({super.key, required this.state});

  final DetailsFormState state;

  @override
  State<AnnoucementFormPage> createState() => _AnnoucementFormPageState();
}

class _AnnoucementFormPageState extends State<AnnoucementFormPage> {
  final _formKey = GlobalKey<FormState>();

  String _formatAge(DateTime birthday) {
    var days = DateTime.now().difference(widget.state.pet!.birthday!).inDays;

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
      titleSpacing: 0,
      title: const Text("Nowe ogłoszenie"),
    );
  }

  Widget _buildPetInfo() {
    return SizedBox(
      height: 200,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 4,
                  ),
                  borderRadius: BorderRadius.circular(20)),
              child: const Icon(
                Icons.camera_alt_outlined,
                size: 64,
              ),
            ),
          ),
          const SizedBox(
            width: 4,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Imię: ${widget.state.pet?.name}"),
                  const SizedBox(
                    height: 16,
                  ),
                  Text("Gatunek: ${widget.state.pet?.species}"),
                  const SizedBox(
                    height: 16,
                  ),
                  if (widget.state.pet?.birthday != null)
                    Text("Wiek: ${_formatAge(widget.state.pet!.birthday!)}"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Align(
        alignment: Alignment.centerRight,
        child: TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                context.read<AnnoucementFormCubit>().submit(Announcement(
                    pet: widget.state.pet!, title: '', description: ''));
              }
            },
            child: const Text(
              "Wyślij",
              style: TextStyle(
                  fontSize: 20,
                  fontFamily: "Quicksand",
                  fontWeight: FontWeight.bold),
            )),
      ),
    );
  }

  Widget _buildInputs(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildPetInfo(),
          const SizedBox(
            height: 24,
          ),
          TextFormField(
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
              minLines: 5,
              maxLines: null,
              decoration: const InputDecoration(
                labelText: "Opis ogłoszenia",
                alignLabelWithHint: true,
              ),
            ),
          ),
          const Spacer(),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<AnnoucementFormCubit>().goBack();
        return false;
      },
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _buildInputs(context),
        ),
      ),
    );
  }
}
