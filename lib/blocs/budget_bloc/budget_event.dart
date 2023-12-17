part of 'budget_bloc.dart';

@immutable
abstract class BudgetEvents {}

class SaveBudgetEvent extends BudgetEvents {
  final BuildContext context;
  final int budgetBoxIndex;
  final BudgetModeType budgetModeType;
  final RoundedLoadingButtonController saveButtonController;
  SaveBudgetEvent(this.context, this.budgetBoxIndex, this.budgetModeType, this.saveButtonController);
}
