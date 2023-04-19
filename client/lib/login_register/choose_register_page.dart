import 'package:flutter/material.dart';
import 'package:pet_share/common_widgets/custom_text_field.dart';
import 'package:pet_share/login_register/cubit.dart';
import 'package:provider/provider.dart';

class ChooseRegisterPage extends StatefulWidget {
  const ChooseRegisterPage({super.key, this.pageNumber = 0});

  final int pageNumber;
  @override
  State<ChooseRegisterPage> createState() => _ChooseRegisterPageState();
}

class _ChooseRegisterPageState extends State<ChooseRegisterPage> {
  List<CardModel> items = [
    CardModel(
        header: "PetShare",
        image: "images/new_announcement.png",
        description: "Wybierz swoją rolę w naszym systemie!",
        type: RegisterType.none),
    CardModel(
        header: "Chcesz zaadoptować zwierzątko?",
        image: "images/adoption.png",
        description: " jako adoptujący!",
        type: RegisterType.adopter),
    CardModel(
        header: "Chcesz oddać zwierzę do adopcji?",
        image: "images/shelter.png",
        description: " jako schronisko!",
        type: RegisterType.shelter),
  ];

  List<Widget> indicator() => List<Widget>.generate(
        items.length,
        (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 3.0),
          height: 10.0,
          width: 10.0,
          decoration: BoxDecoration(
            color: currentPage.round() == index
                ? Colors.orange
                : Colors.orange.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      );

  late double currentPage;
  late PageController _pageViewController;

  @override
  void initState() {
    super.initState();
    currentPage = widget.pageNumber.toDouble();
    _pageViewController = PageController(initialPage: widget.pageNumber);
    _pageViewController.addListener(
      () {
        setState(
          () {
            if (_pageViewController.page != null) {
              currentPage = _pageViewController.page!;
            }
          },
        );
      },
    );
  }

  Widget _buildCard(BuildContext context, CardModel cardModel) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(cardModel.header,
                    textScaleFactor: 2.2,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: "Quicksand",
                      fontWeight: FontWeight.w300,
                      color: Color(0XFF3F3D56),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  cardModel.image,
                  fit: BoxFit.fitWidth,
                  width: 220.0,
                  alignment: Alignment.bottomCenter,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () => context
                      .read<AuthCubit>()
                      .tryToSignUp(cardModel.type, currentPage.toInt()),
                  child: cardModel.type == RegisterType.none
                      ? Text(
                          cardModel.description,
                          textScaleFactor: 1.6,
                          style: const TextStyle(
                              fontFamily: "Quicksand",
                              color: Colors.grey,
                              letterSpacing: 1.2,
                              height: 1.3),
                          textAlign: TextAlign.center,
                        )
                      : CustomTextField(
                          firstText: "Zarejestruj się",
                          secondText: cardModel.description,
                          isFirstTextInBold: true,
                          firstTextColor: Colors.grey,
                          secondTextColor: Colors.grey,
                          textScaleFactor: 1.6,
                          textAlign: TextAlign.center,
                        ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          PageView.builder(
            controller: _pageViewController,
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) {
              return _buildCard(context, items[index]);
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.only(top: 70.0),
              padding: const EdgeInsets.symmetric(vertical: 40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: indicator(),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CardModel {
  CardModel(
      {required this.header,
      required this.image,
      required this.description,
      required this.type});

  String header;
  String image;
  String description;
  RegisterType type;
}
