import 'default_budget_model.dart';

abstract class DefaultBudgetInterface {
  void create(DefaultBudget newDefaultBudget);
  void update(DefaultBudget updatedDefaultBudget);
  void delete(String budgetCategorie);
  Future<DefaultBudget> load(String defaultBudgetCategorie);
}
