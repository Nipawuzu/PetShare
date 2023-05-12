import 'package:flutter/material.dart';

class CatProgressIndicator extends StatelessWidget {
  const CatProgressIndicator({this.text, super.key});

  final Widget? text;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).primaryTextTheme.bodyMedium!,
      child: Container(
        height: double.infinity,
        width: double.infinity,
        color: const Color(0xfffbfbfb),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset("images/running_cat.gif"),
          if (text != null)
            const SizedBox(
              height: 32.0,
            ),
          if (text != null) text!,
        ]),
      ),
    );
  }
}
