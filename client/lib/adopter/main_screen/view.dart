import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pet_share/adopter/main_screen/filtering_category.dart';
import 'package:pet_share/announcements/announcement_grid/announcement_tile.dart';
import 'package:pet_share/announcements/details/gate.dart';
import 'package:pet_share/announcements/models/announcement.dart';
import 'package:pet_share/common_widgets/drawer.dart';
import 'package:pet_share/common_widgets/gif_views.dart';
import 'package:pet_share/common_widgets/list_header_view.dart';
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

  Widget _buildWelcome(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 10,
        ),
        child: Column(children: [
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
        ]));
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
            return const Center(child: CatProgressIndicator());
          }

          if (snapshot.hasData && snapshot.data != null) {
            return ListHeaderView(
                expandedHeight: 300,
                header: _buildWelcome(context),
                slivers: [_buildAnnouncementsGrid(context, snapshot.data!)]);
          }

          return const Center(child: Text("Wystąpił błąd"));
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
