import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_share/common_widgets/generic_main_view/cubit.dart';
import 'package:pet_share/common_widgets/generic_main_view/list_view.dart';
import 'package:pet_share/common_widgets/gif_views.dart';

typedef ErrorScreenBuilder = Widget Function(
    BuildContext context, ErrorState state);

typedef LoadingScreenBuilder = Widget Function(
    BuildContext context, LoadingState state);

typedef HeaderBuilder<H> = Widget Function(BuildContext context, H data);

typedef ListBuilder<L> = Widget Function(BuildContext context, List<L> data);

class GenericMainView<H, L> extends StatefulWidget {
  const GenericMainView({
    super.key,
    required this.cubit,
    this.errorScreenBuilder,
    this.headerToListRatio,
    this.loadingScreenBuilder,
    required this.headerBuilder,
    required this.listBuilder,
  });

  final HeaderBuilder<H> headerBuilder;
  final ListBuilder<L> listBuilder;
  final LoadingScreenBuilder? loadingScreenBuilder;
  final ErrorScreenBuilder? errorScreenBuilder;
  final HeaderListViewCubit<H, L> cubit;
  final double? headerToListRatio;
  @override
  State<GenericMainView<H, L>> createState() => _GenericMainViewState<H, L>();
}

class _GenericMainViewState<H, L> extends State<GenericMainView<H, L>> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => widget.cubit,
      child: BlocBuilder<HeaderListViewCubit<H, L>, ListViewState<H, L>>(
        builder: _buildViewByState,
      ),
    );
  }

  Widget _buildViewByState(BuildContext context, ListViewState<H, L> state) {
    if (state is LoadingState<H, L>) {
      return _buildLoadingScreen(context, state);
    } else if (state is DataState<H, L>) {
      return _buildListView(context, state);
    } else if (state is ErrorState<H, L>) {
      return _buildErrorScreen(context, state);
    } else {
      return Container();
    }
  }

  Widget _buildErrorScreen(BuildContext context, ErrorState state) {
    return widget.errorScreenBuilder != null
        ? widget.errorScreenBuilder!(context, state)
        : RabbitErrorScreen(
            text: Text(state.message.isNotEmpty
                ? state.message
                : "Wystąpił błąd podczas ładowania listy"));
  }

  Future<dynamic> _loadData(BuildContext context) async {
    await context.read<HeaderListViewCubit<H, L>>().loadData();
    return null;
  }

  Widget _buildLoadingScreen(BuildContext context, LoadingState state) {
    return FutureBuilder(
      future: _loadData(context),
      builder: (context, snapshot) => widget.loadingScreenBuilder != null
          ? widget.loadingScreenBuilder!(context, state)
          : const Center(
              child: CatProgressIndicator(
                text: Text("Ładowanie listy..."),
              ),
            ),
    );
  }

  Widget _buildListView(BuildContext context, DataState<H, L> state) {
    return ListDataView<H, L>(
      toolbarScreenRatio: widget.headerToListRatio,
      listBuilder: widget.listBuilder,
      headerBuilder: widget.headerBuilder,
      listData: state.listData,
      headerData: state.headerData,
    );
  }
}
