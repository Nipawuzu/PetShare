import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:pet_share/announcements/details/view.dart';
import 'package:pet_share/common_widgets/custom_input_decoration.dart';
import 'package:pet_share/login_register/cubit.dart';
import 'package:pet_share/login_register/new_adopter.dart';
import 'package:pet_share/login_register/new_shelter.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({
    super.key,
    required this.type,
    required this.email,
    required this.user,
    required this.authId,
  });

  final RegisterType type;
  final String email;
  final NewUser user;
  final String authId;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  late NewUser _user;
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _user = widget.user;
    _user.email = widget.email;
    controller.text = _user.phoneNumber;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
          onPressed: () => context.read<AuthCubit>().goBackToChooseRegisterType(
                widget.authId,
                widget.email,
              ),
          icon: const Icon(Icons.arrow_back)),
      titleSpacing: 0,
      title: TextWithBasicStyle(
        text:
            "Nowe konto ${widget.type == RegisterType.adopter ? "adopcyjne" : "schroniska"}",
      ),
    );
  }

  Widget _buildUserNameField(BuildContext context) {
    return TextFormField(
      initialValue: _user.userName,
      onSaved: (newValue) => _user.userName = newValue.toString(),
      decoration: customInputDecoration("Nazwa użytkownika"),
      validator: (value) =>
          value?.isEmpty ?? false ? "Wpisz nazwę użytkownika" : null,
    );
  }

  Widget _buildFirstNameField(BuildContext context) {
    return TextFormField(
      initialValue: (_user as NewAdopter).firstName,
      onSaved: (newValue) =>
          (_user as NewAdopter).firstName = newValue.toString(),
      decoration: customInputDecoration("Imię"),
      validator: (value) => value?.isEmpty ?? false ? "Wpisz imię" : null,
    );
  }

  Widget _buildLastNameField(BuildContext context) {
    return TextFormField(
      initialValue: (_user as NewAdopter).lastName,
      onSaved: (newValue) =>
          (_user as NewAdopter).lastName = newValue.toString(),
      decoration: customInputDecoration("Nazwisko"),
      validator: (value) => value?.isEmpty ?? false ? "Wpisz nazwisko" : null,
    );
  }

  Widget _buildFullShelterNameField(BuildContext context) {
    return TextFormField(
      initialValue: (_user as NewShelter).fullShelterName,
      onSaved: (newValue) =>
          (_user as NewShelter).fullShelterName = newValue.toString(),
      decoration: customInputDecoration("Nazwa schroniska"),
      validator: (value) =>
          value?.isEmpty ?? false ? "Wpisz nazwę schroniska" : null,
    );
  }

  Widget _buildPhoneNumberField(BuildContext context) {
    return InternationalPhoneNumberInput(
      selectorConfig: const SelectorConfig(
        selectorType: PhoneInputSelectorType.DROPDOWN,
        trailingSpace: false,
        useEmoji: true,
      ),
      ignoreBlank: true,
      autoValidateMode: AutovalidateMode.disabled,
      initialValue: PhoneNumber(isoCode: widget.user.isoCode),
      textFieldController: controller,
      formatInput: true,
      keyboardType: const TextInputType.numberWithOptions(
        signed: true,
        decimal: true,
      ),
      inputBorder: const OutlineInputBorder(),
      inputDecoration: customInputDecoration("Numer telefonu"),
      onSaved: (PhoneNumber number) {
        _user.phoneNumber = number.parseNumber();
        _user.isoCode = number.isoCode!;
        _user.dialCode = number.dialCode!;
      },
      validator: (value) =>
          value?.isEmpty ?? false ? "Wpisz numer telefonu" : null,
      onInputChanged: (PhoneNumber value) {},
    );
  }

  Widget _buildEmailField(BuildContext context) {
    return TextFormField(
      initialValue: _user.email,
      readOnly: true,
      decoration: customInputDecoration("Email"),
    );
  }

  Widget _buildInputs(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 4,
          ),
          _buildUserNameField(
            context,
          ),
          const SizedBox(
            height: 24,
          ),
          if (widget.type == RegisterType.adopter)
            Column(
              children: [
                _buildFirstNameField(context),
                const SizedBox(
                  height: 24,
                ),
                _buildLastNameField(context),
              ],
            ),
          if (widget.type == RegisterType.shelter)
            _buildFullShelterNameField(context),
          const SizedBox(
            height: 24,
          ),
          _buildEmailField(context),
          const SizedBox(
            height: 24,
          ),
          _buildPhoneNumberField(context),
          const Spacer(),
          _buildActionButtons(context),
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
              context.read<AuthCubit>().goToAddressPage(
                    widget.type,
                    _user,
                    widget.authId,
                    widget.email,
                  );
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<AuthCubit>().goBackToChooseRegisterType(
              widget.authId,
              widget.email,
            );
        return false;
      },
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: LayoutBuilder(
            builder: (context, constraint) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraint.maxHeight),
                  child: IntrinsicHeight(
                    child: _buildInputs(context),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class AddressFormPage extends StatefulWidget {
  const AddressFormPage({
    super.key,
    required this.user,
    required this.type,
    required this.authId,
    required this.email,
  });
  final NewUser user;
  final RegisterType type;
  final String authId;
  final String email;

  @override
  State<AddressFormPage> createState() => _AddressFormPageState();
}

class _AddressFormPageState extends State<AddressFormPage> {
  final _formKey = GlobalKey<FormState>();
  late NewAddress _address;

  @override
  void initState() {
    super.initState();
    _address = widget.user.address ?? NewAddress();
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
          onPressed: () {
            _formKey.currentState!.save();
            widget.user.address = _address;
            context.read<AuthCubit>().goBackToUserInformationPage(
                  widget.type,
                  widget.user,
                  widget.authId,
                  widget.email,
                );
          },
          icon: const Icon(Icons.arrow_back)),
      titleSpacing: 0,
      title: const TextWithBasicStyle(
        text: "Adres",
      ),
    );
  }

  Widget _buildStreetField(BuildContext context) {
    return TextFormField(
      initialValue: _address.street,
      onSaved: (newValue) => _address.street = newValue?.trim() ?? '',
      decoration: customInputDecoration("Ulica"),
      validator: (value) => value?.isEmpty ?? false ? "Wpisz ulicę" : null,
    );
  }

  Widget _buildCityField(BuildContext context) {
    return TextFormField(
      initialValue: _address.city,
      onSaved: (newValue) => _address.city = newValue?.trim() ?? '',
      decoration: customInputDecoration("Miasto"),
      validator: (value) => value?.isEmpty ?? false ? "Wpisz miasto" : null,
    );
  }

  Widget _buildPostalCodeField(BuildContext context) {
    return TextFormField(
        initialValue: _address.postalCode,
        onSaved: (newValue) => _address.postalCode = newValue?.trim() ?? '',
        decoration: customInputDecoration("Kod pocztowy"),
        validator: (value) {
          if (value?.isEmpty ?? true) {
            return "Wpisz kod pocztowy";
          } else {
            RegExp exp = RegExp(r'[0-9]{2}-[0-9]{3}');
            String str = value.toString();
            if (!exp.hasMatch(str)) {
              return "Podaj kod pocztowy w formacie 00-000";
            }
          }
          return null;
        });
  }

  Widget _buildProvinceField(BuildContext context) {
    return TextFormField(
      initialValue: _address.province,
      onSaved: (newValue) => _address.province = newValue?.trim() ?? '',
      decoration: customInputDecoration("Województwo"),
      validator: (value) =>
          value?.isEmpty ?? false ? "Wpisz województwo" : null,
    );
  }

  Widget _buildCountryField(BuildContext context) {
    return TextFormField(
      initialValue: _address.country,
      onSaved: (newValue) => _address.country = newValue?.trim() ?? '',
      decoration: customInputDecoration("Kraj"),
      validator: (value) => value?.isEmpty ?? false ? "Wpisz kraj" : null,
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
                widget.user.address = _address;
                context.read<AuthCubit>().signUp(widget.user, widget.authId);
              }
            },
            child: const Center(
              child: Text(
                "Zarejestruj się",
                style: TextStyle(
                    fontSize: 20,
                    fontFamily: "Quicksand",
                    fontWeight: FontWeight.bold),
              ),
            )),
      ),
    );
  }

  Widget _buildInputs(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 4,
          ),
          _buildStreetField(context),
          const SizedBox(
            height: 24,
          ),
          _buildCityField(context),
          const SizedBox(
            height: 24,
          ),
          _buildPostalCodeField(context),
          const SizedBox(
            height: 24,
          ),
          _buildProvinceField(context),
          const SizedBox(
            height: 24,
          ),
          _buildCountryField(context),
          const SizedBox(
            height: 24,
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
        _formKey.currentState!.save();
        widget.user.address = _address;
        context.read<AuthCubit>().goBackToUserInformationPage(
              widget.type,
              widget.user,
              widget.authId,
              widget.email,
            );
        return false;
      },
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: LayoutBuilder(
            builder: (context, constraint) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraint.maxHeight),
                  child: IntrinsicHeight(
                    child: _buildInputs(context),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
