import 'package:flutter/material.dart';
import 'package:pet_share/common_widgets/labeled_card.dart';

class ChipKeyboardInput extends StatefulWidget {
  const ChipKeyboardInput(
      {super.key,
      this.label = "",
      this.hintText = "",
      this.choices = const []});

  final String label;
  final String hintText;
  final List<String> choices;

  @override
  State<ChipKeyboardInput> createState() => _ChipKeyboardInputState();
}

class _ChipKeyboardInputState extends State<ChipKeyboardInput> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return LabeledCard(
      label: widget.label,
      children: [
        Wrap(
          spacing: 4,
          children: [
            for (final choice in widget.choices)
              InputChip(
                onPressed: () {},
                label: Text(choice),
                onDeleted: () {
                  setState(() {
                    widget.choices.remove(choice);
                  });
                },
              ),
          ],
        ),
        const SizedBox(
          height: 4,
        ),
        Row(children: [
          Expanded(
            child: TextField(
              controller: _textEditingController,
              decoration: InputDecoration(
                hintText: widget.hintText,
              ),
              onSubmitted: (newValue) {
                setState(() {
                  widget.choices.add(newValue);
                  _textEditingController.clear();
                });
              },
            ),
          ),
          IconButton(
            enableFeedback: false,
            icon: const Icon(Icons.add),
            onPressed: () {
              if (_textEditingController.text.isEmpty) return;
              setState(() {
                widget.choices
                    .add(_textEditingController.text.trim().toLowerCase());
                _textEditingController.clear();
              });
            },
          ),
        ]),
      ],
    );
  }
}
