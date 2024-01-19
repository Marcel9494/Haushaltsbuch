import 'budget_model.dart';
import '../default_budget/default_budget_model.dart';

abstract class BudgetInterface {
  void create(Budget newBudget);
  Budget createInstance(Budget newBudget);

  void update(Budget updatedBudget, int budgetBoxIndex);
  void updateAllFutureBudgetsFromCategorie(DefaultBudget defaultBudget);
  void updateAllBudgetsFromCategorie(DefaultBudget defaultBudget);
  void updateBudgetCategorieName(String oldCategorieName, String newCategorieName);

  void deleteAllBudgetsFromCategorie(String budgetCategorie);

  Future<Budget> load(int budgetBoxIndex);
  Future<List<Budget>> loadAllBudgetCategories();
  Future<List<Budget>> loadBudgetListFromOneCategorie(String budgetCategorie, [int selectedYear = -1]);
  Future<List<Budget>> loadMonthlyBudgetList(DateTime selectedDate);

  Future<bool> existsBudgetForCategorie(String budgetCategorie);

  Future<List<Budget>> calculateCurrentExpenditure(List<Budget> budgetList, DateTime selectedDate);
  Future<double> calculateCompleteBudgetExpenditures(List<Budget> budgetList, DateTime selectedDate);
  List<Budget> calculateBudgetPercentage(List<Budget> budgetList);
  Future<double> calculateCompleteBudgetAmount(List<Budget> budgetList, DateTime selectedDate);
}
