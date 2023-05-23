import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pet_share/adopter/main_screen/filtering_category.dart';
import 'package:pet_share/announcements/announcement_grid/announcement_tile.dart';
import 'package:pet_share/announcements/details/gate.dart';
import 'package:pet_share/announcements/details/view.dart';
import 'package:pet_share/announcements/models/announcement.dart';
import 'package:pet_share/common_widgets/drawer.dart';
import 'package:pet_share/common_widgets/gif_views.dart';
import 'package:pet_share/common_widgets/list_header_view.dart';
import 'package:pet_share/services/adopter/service.dart';
import 'package:pet_share/services/announcements/service.dart';
import 'package:pet_share/services/service_response.dart';

typedef AsyncValueSetter<T> = Future<T> Function();
typedef WelcomeMaker<T> = Widget Function(T);
typedef ItemBuilder<T, S> = Widget Function(T, S);

class AdopterMainScreen extends StatefulWidget {
  const AdopterMainScreen({super.key});

  @override
  State<AdopterMainScreen> createState() => _AdopterMainScreenState();
}

class _AdopterMainScreenState extends State<AdopterMainScreen>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      centerTitle: true,
      title: const Text('Petshare'),
      actions: [
        IconButton(
          icon: const Icon(Icons.arrow_forward_outlined),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildWelcomeText(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: "Cześć!\n",
        style: Theme.of(context).primaryTextTheme.headlineMedium,
        children: [
          TextSpan(
            text: "Zobacz, jakie zwierzaki czekają na ciebie!",
            style: Theme.of(context).primaryTextTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildWelcome(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 10,
      ),
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Expanded(child: _buildWelcomeText(context)),
                Expanded(
                  child: Image.asset(
                    "images/dog_reading.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                FilteringCategory(category: "Koty"),
                FilteringCategory(category: "Psy"),
                FilteringCategory(category: "Inne"),
                FilteringCategory(category: "..."),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAnnouncementsGrid(
      BuildContext context, List<Announcement> announcements) {
    return SliverMasonryGrid.count(
      key: const PageStorageKey<String>('announcements'),
      crossAxisCount: 2,
      childCount: announcements.length,
      itemBuilder: (context, index) => GestureDetector(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AnnouncementDetailsGate(
              announcement: announcements[index],
              adopterService: context.read<AdopterService>(),
              announcementService: context.read<AnnouncementService>(),
            ),
          ),
        ),
        child: AnnouncementTile(
          announcement: announcements[index],
          announcementService: context.read<AnnouncementService>(),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: FutureBuilder(
        future: context.read<AnnouncementService>().getAnnouncements(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return RefreshIndicator(
              onRefresh: () async {
                setState(() {});
              },
              child: LayoutBuilder(builder: (context, constraint) {
                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(maxHeight: constraint.maxHeight),
                    child: Expanded(
                      child: Column(
                        children: [
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxHeight: 300),
                            child: _buildWelcome(context),
                          ),
                          const Expanded(
                            child: Center(
                                child: CatProgressIndicator(
                                    text: TextWithBasicStyle(
                              text: "Wczytywanie ogłoszeń...",
                              textScaleFactor: 1.7,
                            ))),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            );
          }

          return AdopterMainView<Announcement>(
            announcements: snapshot.data,
            onRefresh: () =>
                context.read<AnnouncementService>().getAnnouncements(),
            buildWelcome: _buildWelcome,
            itemBuilder: _buildAnnouncementsGrid,
            expandedHeight: 300,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _buildAppbar(context),
      drawer: const AppDrawer(),
      body: _buildBody(context),
    );
  }
}

class AdopterMainView<T> extends StatefulWidget {
  const AdopterMainView(
      {super.key,
      required this.announcements,
      required this.onRefresh,
      required this.buildWelcome,
      required this.itemBuilder,
      this.expandedHeight});

  final ServiceResponse<List<T>?>? announcements;
  final AsyncValueSetter<ServiceResponse<List<T>?>?> onRefresh;
  final WelcomeMaker<BuildContext> buildWelcome;
  final ItemBuilder<BuildContext, List<T>> itemBuilder;
  final double? expandedHeight;
  @override
  State<AdopterMainView<T>> createState() => _AdopterMainViewState<T>();
}

class _AdopterMainViewState<T> extends State<AdopterMainView<T>> {
  late ServiceResponse<List<T>?>? announcements;

  @override
  void initState() {
    announcements = widget.announcements;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        announcements = await widget.onRefresh();
        setState(() {});
      },
      child: LayoutBuilder(
        builder: (context, constraint) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: constraint.maxHeight),
              child: Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: announcements == null || announcements!.data == null
                      ? Column(
                          children: [
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxHeight: 300),
                              child: widget.buildWelcome(context),
                            ),
                            announcements != null &&
                                    announcements!.error ==
                                        ErrorType.unauthorized
                                ? const Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: CatForbiddenView(
                                        text: Text("Brak dostępu"),
                                      ),
                                    ),
                                  )
                                : Expanded(
                                    child: Transform.scale(
                                      scale: 0.75,
                                      child: const RabbitErrorScreen(
                                        text: Text(
                                            "Wystapił błąd podczas pobierania danych"),
                                      ),
                                    ),
                                  ),
                          ],
                        )
                      : ListHeaderView(
                          expandedHeight: widget.expandedHeight,
                          header: widget.buildWelcome(context),
                          slivers: [
                            widget.itemBuilder(context, announcements!.data!)
                          ],
                          onRefresh: widget.onRefresh,
                          itemBuilder: widget.itemBuilder,
                          data: announcements,
                          buildWelcome: widget.buildWelcome,
                        ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
