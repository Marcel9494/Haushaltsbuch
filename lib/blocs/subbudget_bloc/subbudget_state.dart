part of 'subbudget_bloc.dart';

@immutable
abstract class SubbudgetState {}

class SubbudgetInitial extends SubbudgetState {}

class SubbudgetLoadingState extends SubbudgetState {}

class SubbudgetLoadedState extends SubbudgetState {
  final BuildContext context;
  final int subbudgetBoxIndex;
  final List<Subbudget> subbudgetList;
  final DefaultBudget defaultBudget;
  final String categorie;
  final int selectedYear;
  SubbudgetLoadedState(this.context, this.subbudgetBoxIndex, this.subbudgetList, this.defaultBudget, this.categorie, this.selectedYear);
}
