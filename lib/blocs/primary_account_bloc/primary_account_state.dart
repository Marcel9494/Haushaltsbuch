part of 'primary_account_bloc.dart';

abstract class PrimaryAccountState {}

class PrimaryAccountInitial extends PrimaryAccountState {}

class PrimaryAccountLoading extends PrimaryAccountState {
  PrimaryAccountLoading();
}

class PrimaryAccountLoaded extends PrimaryAccountState {
  List<PrimaryAccount> loadedPrimaryAccounts;
  PrimaryAccountLoaded(this.loadedPrimaryAccounts);
}
