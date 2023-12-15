part of 'primary_account_bloc.dart';

@immutable
abstract class PrimaryAccountEvent {}

class LoadPrimaryAccountEvent extends PrimaryAccountEvent {
  final BuildContext context;
  LoadPrimaryAccountEvent(this.context);
}

class SavePrimaryAccountEvent extends PrimaryAccountEvent {
  final BuildContext context;
  final String accountName;
  final String accountType;
  SavePrimaryAccountEvent(this.context, this.accountName, this.accountType);
}
