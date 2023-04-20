import 'package:pet_share/login_register/choose_register_page.dart';
import 'package:pet_share/login_register/cubit.dart';

List<CardModel> items = [
  CardModel(
      header: "PetShare",
      image: "images/new_announcement.png",
      description: "Wybierz swoją rolę w naszym systemie!",
      type: RegisterType.none),
  CardModel(
      header: "Chcesz zaadoptować zwierzątko?",
      image: "images/adoption.png",
      description: "Zarejestruj się jako adoptujący!",
      type: RegisterType.adopter),
  CardModel(
      header: "Chcesz oddać zwierzę do adopcji?",
      image: "images/shelter.png",
      description: "Zarejestruj się jako schronisko!",
      type: RegisterType.shelter),
];
