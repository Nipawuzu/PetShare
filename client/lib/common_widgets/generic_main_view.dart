import 'package:flutter/material.dart';
import 'package:pet_share/adopter/main_screen/view.dart';
import 'package:pet_share/common_widgets/gif_views.dart';
import 'package:pet_share/common_widgets/list_header_view.dart';
import 'package:pet_share/services/service_response.dart';

class GenericMainView<T> extends StatefulWidget {
  const GenericMainView(
      {super.key,
      required this.data,
      required this.onRefresh,
      required this.welcomeBuilder,
      required this.itemBuilder,
      this.expandedHeight});

  final ServiceResponse<T> data;
  final AsyncValueSetter<ServiceResponse<T>, T> onRefresh;
  final FunctionBuilder<BuildContext, T> welcomeBuilder, itemBuilder;
  final double? expandedHeight;
  @override
  State<GenericMainView<T>> createState() => _GenericMainViewState<T>();
}

class _GenericMainViewState<T> extends State<GenericMainView<T>> {
  late ServiceResponse<T> data;

  @override
  void initState() {
    data = widget.data;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        data = await widget.onRefresh(data.data);
        setState(() {});
      },
      child: LayoutBuilder(
        builder: (context, constraint) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: constraint.maxHeight),
              child: Expanded(
                child: data.data == null
                    ? noDataWithWelcomeBuilderView(
                        context, data, widget.welcomeBuilder)
                    : ListHeaderView(
                        expandedHeight: widget.expandedHeight,
                        onRefresh: widget.onRefresh,
                        itemBuilder: widget.itemBuilder,
                        data: data,
                        welcomeBuilder: widget.welcomeBuilder,
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget noDataWithWelcomeBuilderView<T>(BuildContext context,
    ServiceResponse<T> data, FunctionBuilder<BuildContext, T> welcomeBuilder) {
  return Column(
    children: [
      ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 300),
          child: welcomeBuilder(context, data.data)),
      data.error == ErrorType.unauthorized
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
                  text: Text("Wystapił błąd podczas pobierania danych"),
                ),
              ),
            ),
    ],
  );
}
