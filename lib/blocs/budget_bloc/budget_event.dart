part of 'budget_bloc.dart';

@immutable
abstract class BudgetEvents {}

class InitializeBudgetEvent extends BudgetEvents {
  final BuildContext context;
  InitializeBudgetEvent(this.context);
}

class SaveBudgetEvent extends BudgetEvents {
  final BuildContext context;
  final int budgetBoxIndex;
  final RoundedLoadingButtonController saveButtonController;
  SaveBudgetEvent(this.context, this.budgetBoxIndex, this.saveButtonController);
}

class LoadBudgetEvent extends BudgetEvents {
  final BuildContext context;
  final int budgetBoxIndex;
  LoadBudgetEvent(this.context, this.budgetBoxIndex);
}

class UpdateBudgetEvent extends BudgetEvents {
  final BuildContext context;
  final int budgetBoxIndex;
  final RoundedLoadingButtonController saveButtonController;
  UpdateBudgetEvent(this.context, this.budgetBoxIndex, this.saveButtonController);
}
