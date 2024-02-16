part of 'default_budget_bloc.dart';

@immutable
abstract class DefaultBudgetState {}

class DefaultBudgetInitial extends DefaultBudgetState {}

class DefaultBudgetLoadingState extends DefaultBudgetState {
  DefaultBudgetLoadingState();
}

class DefaultBudgetLoadedState extends DefaultBudgetState {
  final BuildContext context;
  final String budgetCategorie;
  DefaultBudgetLoadedState(this.context, this.budgetCategorie);
}
