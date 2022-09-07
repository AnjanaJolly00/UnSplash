import 'package:equatable/equatable.dart';

abstract class SearchState extends Equatable {}

class SearchInitialState extends SearchState {
  @override
  List<Object?> get props => [];
}

class SearchLoadingState extends SearchState {
  @override
  List<Object?> get props => [];
}

class SearchSuccessState extends SearchState {
  @override
  List<Object?> get props => [];
}

class SearchFailureState extends SearchState {
  final String? errorMsg;
  SearchFailureState({this.errorMsg = " "});
  @override
  List<Object?> get props => [errorMsg];
}
