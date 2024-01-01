import '/models/subbudget/subbudget_model.dart';

abstract class SubbudgetInterface {
  void create(Subbudget newSubbudget);
  Subbudget createInstance(Subbudget newSubbudget);
  void createSubbudgets(String mainCategorie, String subcategorie, List<String> subcategorieNames);

  void updateAllSubbudgetsForCategorie(String budgetCategorie, double newBudgetAmount);
  Future<List<Subbudget>> loadSubcategorieList(String categorie);
  Future<List<Subbudget>> loadSubcategorieBudgetList(String categorie, List<String> subcategorie, DateTime selectedDate);
  Future<List<Subbudget>> loadOneSubbudget(String subcategorieName);
  Future<bool> existsSubbudgetForCategorie(String subbudgetCategorie);
  Future<List<Subbudget>> calculateCurrentExpenditure(List<Subbudget> subbudgetList, DateTime selectedDate);
}
