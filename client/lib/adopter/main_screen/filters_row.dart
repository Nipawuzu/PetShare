import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_share/adopter/main_screen/announcement_filters.dart';
import 'package:pet_share/adopter/main_screen/cubit.dart';
import 'package:pet_share/adopter/main_screen/filtering_category.dart';
import 'package:pet_share/adopter/main_screen/filters_view.dart';
import 'package:pet_share/common_widgets/pick_button.dart';

class FiltersRow extends StatefulWidget {
  const FiltersRow({super.key, required this.filters});

  final AnnouncementFilters filters;

  @override
  State<FiltersRow> createState() => _FiltersRowState();
}

class _FiltersRowState extends State<FiltersRow> {
  late AnnouncementFilters _filters;

  @override
  void initState() {
    super.initState();
    _filters = widget.filters;
  }

  Widget _buildCatFilterCategory(BuildContext context) {
    return FilteringCategory(
      picked: _filters.species.contains("kot"),
      onPressed: () {
        setState(() {
          if (_filters.species.contains("kot")) {
            _filters.species.remove("kot");
          } else {
            _filters.species.add("kot");
          }
        });

        context.read<MainAdopterViewCubit>().useFilters(_filters);
      },
      category: "Koty",
      image: Image.asset(
        "images/cat_filter.png",
      ),
    );
  }

  Widget _buildDogFilterCategory(BuildContext context) {
    return FilteringCategory(
      picked: _filters.species.contains("pies"),
      onPressed: () {
        setState(() {
          if (_filters.species.contains("pies")) {
            _filters.species.remove("pies");
          } else {
            _filters.species.add("pies");
          }
        });

        context.read<MainAdopterViewCubit>().useFilters(_filters);
      },
      category: "Psy",
      image: Image.asset("images/dog_filter.webp"),
    );
  }

  Widget _buildOtherPetsFilterCategory(BuildContext context) {
    return FilteringCategory(
      picked: _filters.withoutCatsAndDogs,
      onPressed: () {
        setState(() {
          _filters.withoutCatsAndDogs = !_filters.withoutCatsAndDogs;
        });

        context.read<MainAdopterViewCubit>().useFilters(_filters);
      },
      category: "Inne",
      image: Image.asset("images/other_pets_filter.png"),
    );
  }

  _showFiltersInBottomSheet() async {
    await showModalBottomSheet(
      useSafeArea: true,
      isDismissible: false,
      isScrollControlled: true,
      enableDrag: true,
      showDragHandle: true,
      context: context,
      builder: (context) => Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: FiltersView(
          filters: _filters,
        ),
      ),
    ).then((value) => setState(() {})).then((value) async =>
        await context.read<MainAdopterViewCubit>().useFilters(_filters));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: _buildCatFilterCategory(context)),
        const SizedBox(width: 8),
        Expanded(child: _buildDogFilterCategory(context)),
        const SizedBox(width: 8),
        Expanded(child: _buildOtherPetsFilterCategory(context)),
        const SizedBox(width: 8),
        Expanded(
          child: PickButton(
            imageScale: 0.5,
            onPressed: _showFiltersInBottomSheet,
            color: Colors.grey.shade200,
            image: Image.asset("images/filter.png"),
          ),
        ),
      ],
    );
  }
}
