import 'package:flutter/material.dart';

class GifView extends StatelessWidget {
  const GifView({super.key, this.text, required this.asset, this.color});

  final Widget? text;
  final String asset;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).primaryTextTheme.bodyMedium!,
      child: Container(
        height: double.infinity,
        width: double.infinity,
        color: color ?? Theme.of(context).scaffoldBackgroundColor,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset(asset),
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

class RabbitErrorScreen extends StatelessWidget {
  const RabbitErrorScreen({super.key, this.text});

  final Widget? text;

  @override
  Widget build(BuildContext context) {
    return GifView(asset: "images/error.gif", text: text);
  }
}

class CatProgressIndicator extends StatelessWidget {
  const CatProgressIndicator({this.text, super.key});

  final Widget? text;

  @override
  Widget build(BuildContext context) {
    return GifView(
      asset: "images/running_cat.gif",
      text: text,
      color: const Color(0xfffbfbfb),
    );
  }
}

class CatForbiddenView extends StatelessWidget {
  const CatForbiddenView({this.text, super.key});

  final Widget? text;

  @override
  Widget build(BuildContext context) {
    return GifView(
      asset: "images/you_shouldnot_be_here.gif",
      text: text,
    );
  }
}
