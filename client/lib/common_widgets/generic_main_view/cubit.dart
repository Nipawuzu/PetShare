import 'package:flutter_bloc/flutter_bloc.dart';

abstract class HeaderListViewCubit<H, L> extends Cubit<ListViewState<H, L>> {
  HeaderListViewCubit() : super(LoadingState());

  Future loadData();
  Future reloadData();
  Future nextPage();
  Future useFilters();
}

class ListViewState<H, L> {}

class ErrorState<H, L> extends ListViewState<H, L> {
  final String message;

  ErrorState({this.message = ""});
}

class LoadingState<H, L> extends ListViewState<H, L> {}

class DataState<H, L> extends ListViewState<H, L> {
  final H headerData;
  final List<L> listData;

  DataState({required this.headerData, required this.listData});
}
