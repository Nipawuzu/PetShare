import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pet_share/applications/received_applications/view.dart';
import 'package:pet_share/environment.dart';
import 'package:pet_share/services/adopter/service.dart';
import 'package:username_gen/username_gen.dart';

class ShelterMainScreen extends StatefulWidget {
  const ShelterMainScreen({super.key});

  @override
  State<ShelterMainScreen> createState() => _ShelterMainScreenState();
}

class _ShelterMainScreenState extends State<ShelterMainScreen>
    with TickerProviderStateMixin {
  late AnimationController _bannerAnimationController;
  late Animation<double> _bannerAnimation;
  final ScrollController _petListScrollController = ScrollController();

  bool _bannerIsVisible = true;
  bool _bannerCanMove = true;
  bool _bannerIsMoving = false;

  @override
  void initState() {
    super.initState();
    _bannerAnimationController = AnimationController(
      vsync: this,
    );
    _bannerAnimation = CurvedAnimation(
      parent: _bannerAnimationController,
      curve: Curves.linear,
    );

    _bannerAnimationController.value = 1;
  }

  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () {},
      ),
      centerTitle: true,
      title: const Text('Petshare'),
      actions: [
        IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildWelcome(BuildContext context) {
    return FadeTransition(
      opacity: _bannerAnimation,
      child: SizeTransition(
        sizeFactor: _bannerAnimation,
        axis: Axis.vertical,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 5,
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Cześć!",
                        style:
                            Theme.of(context).primaryTextTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      RichText(
                        text: TextSpan(
                          text: "Czeka na ciebie ",
                          style: Theme.of(context).primaryTextTheme.bodyMedium,
                          children: [
                            TextSpan(
                              text: "10",
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: _interestToColor(10),
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const TextSpan(text: "  wniosków do rozpatrzenia!")
                          ],
                        ),
                      ),
                    ],
                  )),
            ),
            Expanded(
              flex: 4,
              child: Image.asset(
                "images/dog_reading.jpg",
                fit: BoxFit.fitWidth,
                alignment: Alignment.bottomCenter,
              ),
            )
          ],
        ),
      ),
    );
  }

  late Offset _startDragPoint = const Offset(0, 0);

  _pointerDownHandler(PointerDownEvent details) {
    if (_petListScrollController.offset >
        _petListScrollController.initialScrollOffset) {
      _bannerCanMove = false;
      return;
    }

    _startDragPoint = details.position;
    _bannerCanMove = true;
  }

  _pointerMoveHandler(PointerMoveEvent details) {
    if (!_bannerCanMove) return;

    var dy = (details.position.dy - _startDragPoint.dy) / 300;
    double value = min(max(dy, -1), 1);

    if (_bannerAnimationController.value == 0 && !_bannerIsVisible) {
      if (_bannerAnimationController.value + value > 0) {
        setState(() {
          _bannerIsMoving = true;
        });
      } else {
        return;
      }
    }

    _bannerIsMoving = true;
    _bannerAnimationController.value += value;
    _startDragPoint = details.position;
  }

  _pointerUpHandler(PointerUpEvent details) {
    if (!_bannerIsMoving) return;

    var showBanner = _bannerAnimationController.value > 0.25;
    _bannerIsMoving = false;

    _bannerAnimationController
        .animateTo(showBanner ? 1 : 0,
            duration: const Duration(milliseconds: 200))
        .whenComplete(() {
      setState(() {
        _bannerIsVisible = showBanner;
      });
    });
  }

  Widget _buildPetList(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Listener(
          onPointerDown: _pointerDownHandler,
          onPointerMove: _pointerMoveHandler,
          onPointerUp: _pointerUpHandler,
          child: ListView.builder(
            physics: !_bannerIsVisible && !_bannerIsMoving
                ? const ScrollPhysics()
                : const NeverScrollableScrollPhysics(),
            controller: _petListScrollController,
            itemCount: 20,
            itemBuilder: (context, index) => Card(
              child: ListTile(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ReceivedApplications(
                        AdopterService(Dio(), Environment.adopterApiUrl)),
                  ),
                ),
                contentPadding: const EdgeInsets.all(8.0),
                leading: SizedBox.square(
                  dimension: 50,
                  child: ClipOval(
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: "https://cataas.com/cat?=$index",
                    ),
                  ),
                ),
                title: Text(
                  UsernameGen.generateWith(),
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Chip(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      label: Text((index * 10).toString()),
                      backgroundColor: _interestToColor(index * 10),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward_ios),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _interestToColor(int applicationsCount) {
    if (applicationsCount <= 5) {
      return Colors.green.shade200;
    }

    if (applicationsCount <= 10) {
      return Colors.green.shade400;
    }

    if (applicationsCount <= 20) {
      return Colors.yellow.shade500;
    }

    if (applicationsCount <= 30) {
      return Colors.orange.shade500;
    }

    return Colors.red.shade400;
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        _buildWelcome(context),
        _buildPetList(context),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(context),
      body: _buildBody(context),
    );
  }
}
