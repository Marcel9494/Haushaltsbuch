part of 'budget_bloc.dart';

@immutable
abstract class BudgetEvents {}

class InitializeBudgetEvent extends BudgetEvents {
  final BuildContext context;
  InitializeBudgetEvent(this.context);
}

class CreateBudgetEvent extends BudgetEvents {
  final BuildContext context;
  final RoundedLoadingButtonController saveButtonController;
  CreateBudgetEvent(this.context, this.saveButtonController);
}

class LoadBudgetListFromOneCategorieEvent extends BudgetEvents {
  final BuildContext context;
  final int budgetBoxIndex;
  final String categorie;
  final int selectedYear;
  final bool pushNewScreen;
  LoadBudgetListFromOneCategorieEvent(this.context, this.budgetBoxIndex, this.categorie, this.selectedYear, this.pushNewScreen);
}

class UpdateBudgetEvent extends BudgetEvents {
  final BuildContext context;
  final int budgetBoxIndex;
  final RoundedLoadingButtonController saveButtonController;
  UpdateBudgetEvent(this.context, this.budgetBoxIndex, this.saveButtonController);
}
