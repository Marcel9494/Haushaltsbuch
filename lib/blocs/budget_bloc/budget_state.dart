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
  final BudgetModeType budgetModeType;
  BudgetLoadedState(this.context, this.budgetBoxIndex, this.budgetModeType);
}
