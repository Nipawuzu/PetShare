import 'package:flutter/material.dart';

class HeaderListView extends StatefulWidget {
  const HeaderListView({
    super.key,
    this.expandedHeight,
    this.toolbarHeight,
    this.toolbarScreenRatio,
    this.onScrollNotification,
    this.onRefresh,
    required this.slivers,
    required this.header,
  });

  final double? expandedHeight;
  final double? toolbarHeight;
  final double? toolbarScreenRatio;
  final bool Function(ScrollNotification notification)? onScrollNotification;
  final Future<void> Function()? onRefresh;
  final List<Widget> slivers;
  final Widget header;

  @override
  State<HeaderListView> createState() => _HeaderListViewState();
}

class _HeaderListViewState extends State<HeaderListView> {
  Future<void>? _scrollAnimate;
  bool _ignoreNotification = false;
  late double _expandedHeight;
  late double _toolbarHeight;
  late GlobalKey<NestedScrollViewState> _nestedScrollViewState;

  @override
  void initState() {
    _toolbarHeight = widget.toolbarHeight ?? 0;
    _nestedScrollViewState = GlobalKey();
    super.initState();
  }

  double _calculateExpandRatio(BoxConstraints constraints) {
    var expandRatio = (constraints.maxHeight - _toolbarHeight) /
        (_expandedHeight - _toolbarHeight);
    if (expandRatio > 1.0) expandRatio = 1.0;
    if (expandRatio < 0.0) expandRatio = 0.0;

    return expandRatio;
  }

  bool onScrollNotification(ScrollNotification notification) {
    return widget.onScrollNotification != null
        ? widget.onScrollNotification!(notification)
        : false;
  }

  bool onNotification(ScrollEndNotification notification) {
    if (_ignoreNotification) return false;
    final scrollViewState = _nestedScrollViewState.currentState;
    final outerController = scrollViewState!.outerController;

    if (scrollViewState.innerController.position.pixels == 0) {
      final range = _expandedHeight - _toolbarHeight;
      final snapOffset = (outerController.offset / range) > 0.55 ? range : 0.0;
      _ignoreNotification = true;
      Future.microtask(() async {
        if (_scrollAnimate != null) await _scrollAnimate;
        _scrollAnimate = outerController
            .animateTo(snapOffset,
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeOutCubic)
            .then((value) {
          _ignoreNotification = false;
        });
      });
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    var ratio = widget.toolbarScreenRatio ?? 2 / 9;
    _expandedHeight =
        widget.expandedHeight ?? MediaQuery.of(context).size.height * ratio;

    return NotificationListener<ScrollEndNotification>(
      onNotification: onNotification,
      child: RefreshIndicator(
        notificationPredicate: (notification) {
          return notification.depth == 1;
        },
        onRefresh: () async {
          if (widget.onRefresh != null) {
            await widget.onRefresh!();
          }
        },
        child: NestedScrollView(
          key: _nestedScrollViewState,
          physics: HeaderScrollPhysics(expandedHeight: _expandedHeight),
          body: Builder(builder: (context) {
            return NotificationListener<ScrollNotification>(
              onNotification: onScrollNotification,
              child: CustomScrollView(
                slivers: [
                  SliverOverlapInjector(
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                          context)),
                  for (var sliver in widget.slivers) sliver
                ],
              ),
            );
          }),
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
                  toolbarHeight: _toolbarHeight,
                  expandedHeight: _expandedHeight,
                  flexibleSpace: LayoutBuilder(
                    builder: (context, constraints) {
                      final expandRation = _calculateExpandRatio(constraints);
                      final animation = AlwaysStoppedAnimation(expandRation);

                      return FadeAnimation(
                        animation: animation,
                        isExpandedWidget: true,
                        child: widget.header,
                      );
                    },
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class FadeAnimation extends StatelessWidget {
  const FadeAnimation(
      {super.key,
      required this.animation,
      required this.child,
      required this.isExpandedWidget});

  final Animation<double> animation;
  final Widget child;
  final bool isExpandedWidget;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
        opacity: Tween(
          begin: isExpandedWidget ? 0.0 : 1.0,
          end: isExpandedWidget ? 1.0 : 0.0,
        ).animate(CurvedAnimation(
            parent: animation,
            curve: Interval(
                isExpandedWidget ? 0.5 : 0.2, isExpandedWidget ? 1.0 : 0.55))),
        child: child);
  }
}

class HeaderScrollPhysics extends ScrollPhysics {
  final double expandedHeight;

  const HeaderScrollPhysics(
      {required this.expandedHeight, ScrollPhysics? parent})
      : super(parent: parent);

  @override
  HeaderScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return HeaderScrollPhysics(
        expandedHeight: expandedHeight, parent: buildParent(ancestor));
  }

  @override
  Simulation? createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    if (velocity == 0.0 ||
        velocity > 0.0 && position.pixels >= position.maxScrollExtent ||
        velocity < 0.0 && position.pixels <= position.minScrollExtent) {
      return null;
    }

    return HeaderScrollSimulation(
        position: position.pixels,
        velocity: velocity,
        expandedHeight: expandedHeight);
  }
}

class HeaderScrollSimulation extends ClampingScrollSimulation {
  final double expandedHeight;

  HeaderScrollSimulation(
      {required this.expandedHeight,
      required double position,
      required double velocity,
      double friction = 0.015,
      Tolerance tolerance = Tolerance.defaultTolerance})
      : super(
            position: position,
            velocity: velocity,
            friction: friction,
            tolerance: tolerance) {
    assert(expandedHeight >= 0);
  }

  @override
  double x(double time) {
    final double x = super.x(time);
    return x < 0.0 ? 0.0 : (x > expandedHeight ? expandedHeight : x);
  }

  @override
  bool isDone(double time) => super.isDone(time) || position >= expandedHeight;
}
