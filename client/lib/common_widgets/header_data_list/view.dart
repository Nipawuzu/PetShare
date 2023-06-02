import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_share/common_widgets/header_data_list/cubit.dart';
import 'package:pet_share/common_widgets/header_data_list/list_data_view.dart';
import 'package:pet_share/common_widgets/gif_views.dart';

typedef ErrorScreenBuilder = Widget Function(
    BuildContext context, ErrorState state);

typedef LoadingScreenBuilder = Widget Function(
    BuildContext context, LoadingState state);

typedef HeaderBuilder<H> = Widget Function(BuildContext context, H data);

typedef ListBuilder<L> = Widget Function(BuildContext context, List<L> data);

class HeaderDataList<H, L> extends StatefulWidget {
  const HeaderDataList({
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
  final HeaderDataListCubit<H, L> cubit;
  final double? headerToListRatio;
  @override
  State<HeaderDataList<H, L>> createState() => _HeaderDataListState<H, L>();
}

class _HeaderDataListState<H, L> extends State<HeaderDataList<H, L>> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => widget.cubit,
      child: BlocBuilder<HeaderDataListCubit<H, L>, ListViewState<H, L>>(
        builder: _refreshWrapper,
      ),
    );
  }

  Widget _refreshWrapper(BuildContext context, ListViewState<H, L> state) {
    return RefreshIndicator(
      onRefresh: context.read<HeaderDataListCubit<H, L>>().reloadData,
      child: _buildViewByState(context, state),
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
    await context.read<HeaderDataListCubit<H, L>>().loadData();
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
    return DataListView<H, L>(
      toolbarScreenRatio: widget.headerToListRatio,
      listBuilder: widget.listBuilder,
      headerBuilder: widget.headerBuilder,
      listData: state.listData,
      headerData: state.headerData,
    );
  }
}
