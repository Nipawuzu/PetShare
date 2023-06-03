import 'package:flutter/material.dart';
import 'package:pet_share/adopter/main_screen/announcement_filters.dart';
import 'package:pet_share/common_widgets/chip_keyboard_input.dart';
import 'package:pet_share/common_widgets/filter_slider.dart';

class FiltersView extends StatefulWidget {
  const FiltersView({super.key, required this.filters});

  final AnnouncementFilters filters;

  @override
  State<FiltersView> createState() => _FiltersViewState();
}

class _FiltersViewState extends State<FiltersView> {
  static const int _maxAvailableAgeInYears = 20;
  static const int _sliderValueMonthBoundary = 30;

  int _sliderValueToMonths(double value) {
    if (value < _sliderValueMonthBoundary) {
      var percentage = value / _sliderValueMonthBoundary;
      return (percentage * 12).toInt();
    }

    var percentage =
        (value - _sliderValueMonthBoundary) / (100 - _sliderValueMonthBoundary);
    return (percentage * _maxAvailableAgeInYears).ceil() * 12;
  }

  double _monthsToSliderValue(int months) {
    if (months < 12) {
      return months / 12 * _sliderValueMonthBoundary;
    }

    return _sliderValueMonthBoundary +
        (months / 12 / _maxAvailableAgeInYears) *
            (100 - _sliderValueMonthBoundary);
  }

  String _sliderAgeFormatter(double value) {
    var months = _sliderValueToMonths(value);

    if (months < 12) {
      return "$months miesięcy";
    }

    return "${months ~/ 12} lat";
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints.expand(),
      child: SingleChildScrollView(
        child: Column(
          children: [
            FilterSlider(
              initialValue: _monthsToSliderValue(24),
              value: widget.filters.minAge != null
                  ? _monthsToSliderValue(widget.filters.minAge!)
                  : null,
              label: "Minimalny wiek",
              labelFormatter: _sliderAgeFormatter,
              onChanged: (newValue) => widget.filters.minAge =
                  newValue != null ? _sliderValueToMonths(newValue) : null,
            ),
            FilterSlider(
              initialValue: _monthsToSliderValue(120),
              value: widget.filters.maxAge != null
                  ? _monthsToSliderValue(widget.filters.maxAge!)
                  : null,
              label: "Maksymalny wiek",
              labelFormatter: _sliderAgeFormatter,
              onChanged: (newValue) => widget.filters.maxAge =
                  newValue != null ? _sliderValueToMonths(newValue) : null,
            ),
            ChipKeyboardInput(
              label: "Gatunek",
              hintText: "Dodaj gatunek",
              choices: widget.filters.species,
            ),
            ChipKeyboardInput(
              label: "Rasa",
              hintText: "Dodaj rasę",
              choices: widget.filters.breeds,
            ),
            ChipKeyboardInput(
              label: "Schronisko",
              hintText: "Dodaj schronisko",
              choices: widget.filters.shelters,
            ),
            ChipKeyboardInput(
              label: "Miasto",
              hintText: "Dodaj miasto",
              choices: widget.filters.cities,
            ),
          ],
        ),
      ),
    );
  }
}
