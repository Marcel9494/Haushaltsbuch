part of 'account_bloc.dart';

@immutable
abstract class AccountEvent {}

class CreateOrLoadAccountEvent extends AccountEvent {
  final BuildContext context;
  final int accountBoxIndex;
  CreateOrLoadAccountEvent(this.context, this.accountBoxIndex);
}

class CreateOrUpdateAccountEvent extends AccountEvent {
  final BuildContext context;
  final int accountBoxIndex;
  final RoundedLoadingButtonController saveButtonController;
  CreateOrUpdateAccountEvent(this.context, this.accountBoxIndex, this.saveButtonController);
}

class DeleteAccountEvent extends AccountEvent {
  final BuildContext context;
  final int accountBoxIndex;
  DeleteAccountEvent(this.context, this.accountBoxIndex);
}
