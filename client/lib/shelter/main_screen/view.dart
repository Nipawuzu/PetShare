import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_share/announcements/details/view.dart';
import 'package:pet_share/announcements/form/view.dart';
import 'package:pet_share/common_widgets/drawer.dart';
import 'package:pet_share/common_widgets/gif_views.dart';
import 'package:pet_share/common_widgets/interest_to_color.dart';
import 'package:pet_share/shelter/main_screen/cubit.dart';
import 'package:pet_share/shelter/main_screen/view_model.dart';
import 'package:pet_share/shelter/pet_details/view.dart';
import 'package:pet_share/common_widgets/header_data_list/cubit.dart';
import 'package:pet_share/common_widgets/header_data_list/view.dart';

class ShelterMainScreen extends StatefulWidget {
  const ShelterMainScreen({super.key});

  @override
  State<ShelterMainScreen> createState() => _ShelterMainScreenState();
}

class _ShelterMainScreenState extends State<ShelterMainScreen>
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
          icon: const Icon(Icons.home),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildWelcomeWithNoPets(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: "Cześć!\n",
        style: Theme.of(context).primaryTextTheme.headlineMedium,
        children: [
          TextSpan(
            text: "Nie masz jeszcze żadnych\nwniosków do rozpatrzenia",
            style: Theme.of(context).primaryTextTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  String _formatWaiting(int numberOfApplications) {
    if (numberOfApplications < 5 && numberOfApplications > 1) return "Czekają";

    return "Czeka";
  }

  String _formatApplications(int numberOfApplications) {
    switch (numberOfApplications % 10) {
      case 1:
        return "wniosek";
      case 2:
      case 3:
      case 4:
        return "wnioski";
      default:
        return "wniosków";
    }
  }

  Widget _buildWelcomeWithNumberOfApplications(
      BuildContext context, int applicationsCount) {
    return RichText(
      text: TextSpan(
        text: "Cześć!\n",
        style: Theme.of(context).primaryTextTheme.headlineMedium,
        children: [
          TextSpan(
            text: "${_formatWaiting(applicationsCount)} na ciebie ",
            style: Theme.of(context).primaryTextTheme.bodyMedium,
            children: [
              TextSpan(
                text: "$applicationsCount\n",
                style: Theme.of(context).primaryTextTheme.bodyMedium?.copyWith(
                      color: interestToColor(applicationsCount),
                      fontWeight: FontWeight.bold,
                    ),
              ),
              TextSpan(
                  text:
                      "${_formatApplications(applicationsCount)} do rozpatrzenia!")
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWelcome(BuildContext context) {
    return Text("Cześć!",
        style: Theme.of(context).primaryTextTheme.headlineMedium);
  }

  Widget _buildHeader(BuildContext context, int applicationsCount) {
    return _buildWelcome(
        context,
        applicationsCount == 0
            ? _buildWelcomeWithNoPets(context)
            : _buildWelcomeWithNumberOfApplications(
                context, applicationsCount));
  }

  Widget _buildWelcome(BuildContext context, Widget welcomeText) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.2,
      child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
          ),
          child: Column(
            children: [
              Expanded(
                flex: 5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Image.asset(
                      "images/dog_reading.png",
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        alignment: Alignment.bottomLeft,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            minHeight: 1,
                            minWidth: 1,
                          ),
                          child: welcomeText,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: InputChip(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) =>
                                  NewAnnouncementForm(context.read())),
                        ),
                        label: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextWithBasicStyle(
                                text: "Dodaj ogłoszenie",
                                textScaleFactor: 1,
                                bold: true,
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Icon(
                                Icons.create,
                                size: 12,
                              )
                            ]),
                        backgroundColor: Colors.grey.shade200,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              )
            ],
          )),
    );
  }

  Widget _buildPetList(
      BuildContext context, List<PetListItemViewModel> petWithApplications) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
          childCount: petWithApplications.length, (context, index) {
        return Card(
          child: ListTile(
            onTap: () => Navigator.of(context)
                .push(MaterialPageRoute(
                    builder: (context) => PetDetails(
                          pet: petWithApplications[index].pet,
                          applications: petWithApplications[index].applications,
                        )))
                .then((value) =>
                    context.read<MainShelterViewCubit>().recountApplications()),
            contentPadding: const EdgeInsets.all(8.0),
            leading: SizedBox.square(
              dimension: 50,
              child: ClipOval(
                child: petWithApplications[index].pet.photoUrl != null
                    ? CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: petWithApplications[index].pet.photoUrl!,
                      )
                    : const Icon(Icons.pets_outlined),
              ),
            ),
            title: Text(
              petWithApplications[index].pet.name,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Chip(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  label: Text(petWithApplications[index]
                      .waitingApplicationsCount
                      .toString()),
                  backgroundColor: interestToColor(
                      petWithApplications[index].waitingApplicationsCount),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward_ios),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildStaticViewWithHeader(BuildContext context,
      {required Widget header, required Widget body}) {
    return LayoutBuilder(builder: (context, constraint) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: constraint.maxHeight),
          child: Column(
            children: [
              header,
              Expanded(
                child: body,
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildLoadingScreen(BuildContext context, LoadingState state) {
    return _buildStaticViewWithHeader(
      context,
      header: _buildWelcome(context, _buildEmptyWelcome(context)),
      body: Transform.scale(
        scale: 0.75,
        child: const Center(
            child: CatProgressIndicator(
                text: TextWithBasicStyle(
          text: "Wczytywanie wniosków...",
          textScaleFactor: 1.7,
        ))),
      ),
    );
  }

  Widget _buildError(BuildContext context, ErrorState state) {
    return _buildStaticViewWithHeader(
      context,
      header: _buildWelcome(
        context,
        _buildEmptyWelcome(context),
      ),
      body: Transform.scale(
        scale: 0.75,
        child: Center(
          child: RabbitErrorScreen(
            text: Text(state.message),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => MainShelterViewCubit(context.read()),
      child: Builder(builder: (context) {
        return HeaderDataList(
          headerToListRatio: 0.2,
          errorScreenBuilder: _buildError,
          loadingScreenBuilder: _buildLoadingScreen,
          headerBuilder: _buildHeader,
          listBuilder: _buildPetList,
          cubit: context.read<MainShelterViewCubit>(),
        );
      }),
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
