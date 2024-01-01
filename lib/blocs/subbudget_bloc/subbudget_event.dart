part of 'subbudget_bloc.dart';

@immutable
abstract class SubbudgetEvent {}

class SaveSubbudgetEvent extends SubbudgetEvent {
  final BuildContext context;
  final int subbudgetBoxIndex;
  final RoundedLoadingButtonController saveButtonController;
  SaveSubbudgetEvent(this.context, this.subbudgetBoxIndex, this.saveButtonController);
}

class LoadSubbudgetEvent extends SubbudgetEvent {
  final BuildContext context;
  final int subbudgetBoxIndex;
  LoadSubbudgetEvent(this.context, this.subbudgetBoxIndex);
}
