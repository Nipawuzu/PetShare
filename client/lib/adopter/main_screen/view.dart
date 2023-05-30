import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pet_share/adopter/main_screen/cubit.dart';
import 'package:pet_share/adopter/main_screen/filtering_category.dart';
import 'package:pet_share/announcements/announcement_grid/announcement_tile.dart';
import 'package:pet_share/announcements/details/gate.dart';
import 'package:pet_share/announcements/details/view.dart';
import 'package:pet_share/announcements/models/announcement.dart';
import 'package:pet_share/common_widgets/drawer.dart';
import 'package:pet_share/common_widgets/header_data_list/cubit.dart';
import 'package:pet_share/common_widgets/header_data_list/view.dart';
import 'package:pet_share/common_widgets/gif_views.dart';
import 'package:pet_share/services/adopter/service.dart';
import 'package:pet_share/services/announcements/service.dart';

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

  Widget _buildWelcome(BuildContext context, dynamic headerData) {
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
      crossAxisCount: 1,
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

  Widget _buildLoadingScreen(BuildContext context, LoadingState state) {
    return RefreshIndicator(
      onRefresh:
          context.read<HeaderDataListCubit<dynamic, Announcement>>().reloadData,
      child: LayoutBuilder(builder: (context, constraint) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: constraint.maxHeight),
            child: Column(
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 300),
                  child: _buildWelcome(context, null),
                ),
                Expanded(
                  child: Center(
                      child: Transform.scale(
                    scale: 0.75,
                    child: const CatProgressIndicator(
                        text: TextWithBasicStyle(
                      text: "Wczytywanie ogłoszeń...",
                      textScaleFactor: 1.7,
                    )),
                  )),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildErrorScreen(BuildContext context, ErrorState state) {
    return RefreshIndicator(
      onRefresh:
          context.read<HeaderDataListCubit<dynamic, Announcement>>().reloadData,
      child: LayoutBuilder(builder: (context, constraint) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: constraint.maxHeight),
            child: Column(
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 300),
                  child: _buildWelcome(context, null),
                ),
                Expanded(
                  child: Center(
                      child: Transform.scale(
                    scale: 0.75,
                    child: RabbitErrorScreen(
                        text: TextWithBasicStyle(
                      text: state.message,
                      textScaleFactor: 1,
                    )),
                  )),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildBody(BuildContext context) {
    return HeaderDataList(
      headerToListRatio: 0.4,
      errorScreenBuilder: _buildErrorScreen,
      headerBuilder: _buildWelcome,
      listBuilder: _buildAnnouncementsGrid,
      loadingScreenBuilder: _buildLoadingScreen,
      cubit: MainAdopterViewCubit(context.read()),
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
