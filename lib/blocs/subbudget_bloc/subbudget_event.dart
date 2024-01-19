part of 'subbudget_bloc.dart';

@immutable
abstract class SubbudgetEvent {}

class CreateSubbudgetEvent extends SubbudgetEvent {
  final BuildContext context;
  final RoundedLoadingButtonController saveButtonController;
  CreateSubbudgetEvent(this.context, this.saveButtonController);
}

class LoadSubbudgetListFromOneCategorieEvent extends SubbudgetEvent {
  final BuildContext context;
  final int subbudgetBoxIndex;
  final String categorie;
  final int selectedYear;
  final bool pushNewScreen;
  LoadSubbudgetListFromOneCategorieEvent(this.context, this.subbudgetBoxIndex, this.categorie, this.selectedYear, this.pushNewScreen);
}

class LoadSubbudgetEvent extends SubbudgetEvent {
  final BuildContext context;
  final int subbudgetBoxIndex;
  LoadSubbudgetEvent(this.context, this.subbudgetBoxIndex);
}

class UpdateSubbudgetEvent extends SubbudgetEvent {
  final BuildContext context;
  final int subbudgetBoxIndex;
  final RoundedLoadingButtonController saveButtonController;
  UpdateSubbudgetEvent(this.context, this.subbudgetBoxIndex, this.saveButtonController);
}
