import 'package:equatable/equatable.dart';

class SearchEvent extends Equatable {
  final String? searchValue;
  final bool? loadMore;

  const SearchEvent({required this.searchValue, required this.loadMore});

  @override
  List<Object?> get props => [searchValue, loadMore];
}
