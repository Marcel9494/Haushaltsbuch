part of 'account_bloc.dart';

@immutable
abstract class AccountState {}

class AccountInitial extends AccountState {}

class AccountLoadingState extends AccountState {
  AccountLoadingState();
}

class AccountLoadedState extends AccountState {
  final BuildContext context;
  final int accountBoxIndex;
  AccountLoadedState(this.context, this.accountBoxIndex);
}
