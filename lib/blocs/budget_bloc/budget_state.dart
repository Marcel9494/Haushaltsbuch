part of 'budget_bloc.dart';

@immutable
abstract class BudgetState {}

class BudgetInitial extends BudgetState {}

class BudgetLoadingState extends BudgetState {
  BudgetLoadingState();
}

class BudgetLoadedState extends BudgetState {
  final BuildContext context;
  final int budgetBoxIndex;
  BudgetLoadedState(this.context, this.budgetBoxIndex);
}

class BudgetListLoadingState extends BudgetState {
  final BuildContext context;
  BudgetListLoadingState(this.context);
}

class BudgetListLoadedState extends BudgetState {
  final BuildContext context;
  final List<Budget> budgetList;
  final DefaultBudget defaultBudget;
  final String categorie;
  BudgetListLoadedState(this.context, this.budgetList, this.defaultBudget, this.categorie);
}
