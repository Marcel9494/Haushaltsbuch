part of 'budget_bloc.dart';

@immutable
abstract class BudgetState {}

class BudgetInitial extends BudgetState {}

class BudgetInitializingState extends BudgetState {}

class BudgetInitializedState extends BudgetState {}

class BudgetLoadingState extends BudgetState {
  BudgetLoadingState();
}

class BudgetLoadedState extends BudgetState {
  final BuildContext context;
  final int budgetBoxIndex;
  final List<Budget> budgetList;
  final DefaultBudget defaultBudget;
  final String categorie;
  final int selectedYear;
  BudgetLoadedState(this.context, this.budgetBoxIndex, this.budgetList, this.defaultBudget, this.categorie, this.selectedYear);
}
