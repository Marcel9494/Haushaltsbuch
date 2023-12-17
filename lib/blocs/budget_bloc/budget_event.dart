part of 'budget_bloc.dart';

@immutable
abstract class BudgetEvents {}

class SaveBudgetEvent extends BudgetEvents {
  final BuildContext context;
  final int budgetBoxIndex;
  final RoundedLoadingButtonController saveButtonController;
  SaveBudgetEvent(this.context, this.budgetBoxIndex, this.saveButtonController);
}

class CreateBudgetEvent extends BudgetEvents {
  final BuildContext context;
  CreateBudgetEvent(this.context);
}

class LoadBudgetEvent extends BudgetEvents {
  final BuildContext context;
  final int budgetBoxIndex;
  LoadBudgetEvent(this.context, this.budgetBoxIndex);
}
