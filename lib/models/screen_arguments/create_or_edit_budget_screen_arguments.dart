import '../enums/budget_mode_types.dart';

class CreateOrEditBudgetScreenArguments {
  final BudgetModeType budgetModeType;
  final int? budgetBoxIndex;
  final String? budgetCategorie;

  CreateOrEditBudgetScreenArguments(this.budgetModeType, [this.budgetBoxIndex, this.budgetCategorie]);
}
