part of 'subbudget_bloc.dart';

@immutable
abstract class SubbudgetState {}

class SubbudgetInitial extends SubbudgetState {}

class SubbudgetLoadingState extends SubbudgetState {}

class SubbudgetLoadedState extends SubbudgetState {}
