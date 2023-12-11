part of 'primary_account_bloc.dart';

@immutable
abstract class PrimaryAccountEvent {}

class LoadPrimaryAccountEvent extends PrimaryAccountEvent {
  LoadPrimaryAccountEvent();
}
