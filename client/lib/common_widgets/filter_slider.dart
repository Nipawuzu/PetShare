import 'package:flutter/material.dart';
import 'package:pet_share/common_widgets/labeled_card.dart';

class FilterSlider extends StatefulWidget {
  const FilterSlider(
      {super.key,
      this.label = "",
      required this.labelFormatter,
      this.onChanged,
      this.value,
      this.initialValue});

  final String label;
  final String Function(double) labelFormatter;
  final Function(double? value)? onChanged;
  final double? value;
  final double? initialValue;

  @override
  State<FilterSlider> createState() => _FilterSliderState();
}

class _FilterSliderState extends State<FilterSlider> {
  late double _value;
  late bool picked;

  @override
  void initState() {
    super.initState();
    _value = widget.value ?? widget.initialValue ?? 50.0;
    picked = widget.value != null;
  }

  @override
  Widget build(BuildContext context) {
    return LabeledCard(
      color: picked ? Colors.green.shade50 : null,
      label: widget.label,
      children: [
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Slider.adaptive(
                activeColor: picked ? Colors.green.shade200 : null,
                inactiveColor: picked ? Colors.white : null,
                value: _value,
                onChanged: (newValue) {
                  setState(() {
                    _value = newValue;
                  });

                  if (picked) {
                    widget.onChanged?.call(newValue);
                  }
                },
                min: 0,
                max: 100,
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                widget.labelFormatter(_value),
                style: Theme.of(context).primaryTextTheme.labelMedium,
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                icon: Icon(
                  picked ? Icons.remove : Icons.done,
                  color: picked ? Colors.red : Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    picked = !picked;
                  });

                  widget.onChanged?.call(!picked ? null : _value);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
