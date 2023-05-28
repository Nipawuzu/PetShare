import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_share/common_widgets/header_data_list/cubit.dart';
import 'package:pet_share/common_widgets/header_data_list/view.dart';
import 'package:pet_share/common_widgets/header_list_view.dart';

class DataListView<H, L> extends StatefulWidget {
  const DataListView({
    super.key,
    this.expandedHeight,
    this.toolbarHeight,
    this.toolbarScreenRatio,
    required this.listBuilder,
    required this.headerBuilder,
    required this.listData,
    required this.headerData,
  });

  final double? expandedHeight;
  final double? toolbarHeight;
  final double? toolbarScreenRatio;
  final HeaderBuilder<H> headerBuilder;
  final ListBuilder<L> listBuilder;
  final List<L> listData;
  final H headerData;

  @override
  State<DataListView<H, L>> createState() => _DataListViewState<H, L>();
}

class _DataListViewState<H, L> extends State<DataListView<H, L>> {
  bool ignoreNotification = false;
  bool ignoreScrollNotification = false;
  double lastDataLoadOffset = 0;
  int loadedPages = 0;

  @override
  void initState() {
    super.initState();
  }

  bool onScrollNotification(ScrollNotification notification) {
    if (ignoreScrollNotification) return false;

    var maxScrollOffset = notification.metrics.maxScrollExtent;
    var currentScrollOffset = notification.metrics.pixels;

    if (currentScrollOffset >
        lastDataLoadOffset + (maxScrollOffset - lastDataLoadOffset) * 0.5) {
      ignoreScrollNotification = true;
      loadedPages++;
      lastDataLoadOffset = currentScrollOffset;
      context
          .read<HeaderDataListCubit<H, L>>()
          .nextPage()
          .then((_) => ignoreScrollNotification = false);
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return HeaderListView(
      toolbarHeight: widget.toolbarHeight,
      toolbarScreenRatio: widget.toolbarScreenRatio,
      slivers: [
        widget.listBuilder(context, widget.listData),
      ],
      header: widget.headerBuilder(context, widget.headerData),
      onScrollNotification: onScrollNotification,
    );
  }
}
