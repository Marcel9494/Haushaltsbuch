part of 'default_budget_bloc.dart';

@immutable
abstract class DefaultBudgetEvents {}

class LoadDefaultBudgetEvent extends DefaultBudgetEvents {
  final BuildContext context;
  final String budgetCategorie;
  LoadDefaultBudgetEvent(this.context, this.budgetCategorie);
}

class UpdateDefaultBudgetEvent extends DefaultBudgetEvents {
  final BuildContext context;
  final RoundedLoadingButtonController saveButtonController;
  UpdateDefaultBudgetEvent(this.context, this.saveButtonController);
}
