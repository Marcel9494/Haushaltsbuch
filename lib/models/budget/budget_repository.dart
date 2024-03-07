import 'package:hive/hive.dart';

import '../booking/booking_model.dart';
import '../booking/booking_repository.dart';
import '../default_budget/default_budget_model.dart';
import '../default_budget/default_budget_repository.dart';

import '../global_state/global_state_repository.dart';

import 'budget_interface.dart';
import 'budget_model.dart';

import '/utils/consts/hive_consts.dart';

class BudgetRepository extends BudgetInterface {
  @override
  Budget createInstance(Budget newBudget) {
    return Budget()
      ..percentage = newBudget.percentage
      ..currentExpenditure = newBudget.currentExpenditure
      ..categorie = newBudget.categorie
      ..budget = newBudget.budget
      ..budgetDate = newBudget.budgetDate;
  }

  @override
  void create(Budget newBudget) async {
    var budgetBox = await Hive.openBox(budgetsBox);
    budgetBox.add(newBudget);
    for (int i = 0; i < 120; i++) {
      Budget nextBudget = createInstance(newBudget);
      nextBudget.budgetDate = DateTime(DateTime.now().year, DateTime.now().month + i + 1, 1).toString();
      budgetBox.add(nextBudget);
    }

    GlobalStateRepository globalStateRepository = GlobalStateRepository();
    DefaultBudget newDefaultCategorieBudget = DefaultBudget()
      ..index = await globalStateRepository.getDefaultBudgetIndex()
      ..categorie = newBudget.categorie
      ..defaultBudget = newBudget.budget;
    DefaultBudgetRepository defaultBudgetRepository = DefaultBudgetRepository();
    defaultBudgetRepository.create(newDefaultCategorieBudget);
  }

  @override
  void update(Budget updatedBudget, int budgetBoxIndex) async {
    var budgetBox = await Hive.openBox(budgetsBox);
    budgetBox.putAt(budgetBoxIndex, updatedBudget);
  }

  @override
  void updateAllFutureBudgetsFromCategorie(DefaultBudget defaultBudget) async {
    var budgetBox = await Hive.openBox(budgetsBox);
    for (int i = 0; i < budgetBox.length; i++) {
      Budget budget = await budgetBox.getAt(i);
      if ((DateTime.parse(budget.budgetDate).isAfter(DateTime.now()) ||
              DateTime.parse(budget.budgetDate).month == DateTime.now().month && DateTime.parse(budget.budgetDate).year == DateTime.now().year) &&
          budget.categorie == defaultBudget.categorie) {
        budget.budget = defaultBudget.defaultBudget;
      }
    }
  }

  @override
  void updateAllBudgetsFromCategorie(DefaultBudget defaultBudget) async {
    var budgetBox = await Hive.openBox(budgetsBox);
    for (int i = 0; i < budgetBox.length; i++) {
      Budget budget = await budgetBox.getAt(i);
      if (budget.categorie == defaultBudget.categorie) {
        budget.budget = defaultBudget.defaultBudget;
        budgetBox.putAt(i, budget);
      }
    }
  }

  @override
  Future<void> updateBudgetCategorieName(String oldCategorieName, String newCategorieName) async {
    var budgetBox = await Hive.openBox(budgetsBox);
    for (int i = 0; i < budgetBox.length; i++) {
      Budget budget = await budgetBox.getAt(i);
      if (budget.categorie == oldCategorieName) {
        Budget updatedBudgetWithNewCategorieName = Budget()
          ..boxIndex = i
          ..categorie = newCategorieName
          ..budget = budget.budget
          ..budgetDate = budget.budgetDate;
        budgetBox.putAt(i, updatedBudgetWithNewCategorieName);
      }
    }
  }

  @override
  void deleteAllBudgetsFromCategorie(String budgetCategorie) async {
    var budgetBox = await Hive.openBox(budgetsBox);
    for (int i = budgetBox.length - 1; i >= 0; i--) {
      Budget budget = await budgetBox.getAt(i);
      if (budget.categorie == budgetCategorie) {
        budgetBox.deleteAt(i);
      }
    }
    DefaultBudgetRepository defaultBudgetRepository = DefaultBudgetRepository();
    defaultBudgetRepository.delete(budgetCategorie);
  }

  @override
  Future<Budget> load(int budgetBoxIndex) async {
    var budgetBox = await Hive.openBox(budgetsBox);
    Budget budget = await budgetBox.getAt(budgetBoxIndex);
    return budget;
  }

  @override
  Future<List<Budget>> loadAllBudgetCategories() async {
    var budgetBox = await Hive.openBox(budgetsBox);
    List<Budget> budgetList = [];
    bool categorieAlreadyInBudgetList = false;
    for (int i = 0; i < budgetBox.length; i++) {
      categorieAlreadyInBudgetList = false;
      Budget budget = await budgetBox.getAt(i);
      for (int j = 0; j < budgetList.length; j++) {
        if (budgetList[j].categorie == budget.categorie) {
          categorieAlreadyInBudgetList = true;
          break;
        }
      }
      if (categorieAlreadyInBudgetList) {
        continue;
      }
      budget.boxIndex = i;
      budgetList.add(budget);
    }
    return budgetList;
  }

  @override
  Future<List<Budget>> loadBudgetListFromOneCategorie(String budgetCategorie, [int selectedYear = -1]) async {
    var budgetBox = await Hive.openBox(budgetsBox);
    List<Budget> budgetList = [];
    for (int i = 0; i < budgetBox.length; i++) {
      Budget budget = await budgetBox.getAt(i);
      if (DateTime.parse(budget.budgetDate).year == selectedYear && budget.categorie == budgetCategorie && selectedYear != -1) {
        budget.boxIndex = i;
        budgetList.add(budget);
      }
    }
    return budgetList;
  }

  @override
  Future<List<Budget>> loadMonthlyBudgetList(DateTime selectedDate) async {
    var budgetBox = await Hive.openBox(budgetsBox);
    List<Budget> budgetList = [];
    for (int i = 0; i < budgetBox.length; i++) {
      Budget budget = await budgetBox.getAt(i);
      if (DateTime.parse(budget.budgetDate).month == selectedDate.month && DateTime.parse(budget.budgetDate).year == selectedDate.year) {
        budget.boxIndex = i;
        budgetList.add(budget);
      }
    }
    return budgetList;
  }

  @override
  Future<bool> existsBudgetForCategorie(String budgetCategorie) async {
    var budgetBox = await Hive.openBox(budgetsBox);
    for (int i = 0; i < budgetBox.length; i++) {
      Budget budget = await budgetBox.getAt(i);
      if (budget.categorie == budgetCategorie) {
        return true;
      }
    }
    return false;
  }

  @override
  Future<List<Budget>> calculateCurrentExpenditure(List<Budget> budgetList, DateTime selectedDate) async {
    BookingRepository bookingRepository = BookingRepository();
    List<Booking> bookingList = await bookingRepository.loadMonthlyBookings(selectedDate.month, selectedDate.year);
    for (int i = 0; i < budgetList.length; i++) {
      budgetList[i].currentExpenditure = bookingRepository.getExpenditures(bookingList, budgetList[i].categorie);
    }
    return budgetList;
  }

  @override
  Future<double> calculateCompleteBudgetExpenditures(List<Budget> budgetList, DateTime selectedDate) async {
    double completeBudgetExpenditures = 0.0;
    List<Budget> categorieBudgetList = await calculateCurrentExpenditure(budgetList, selectedDate);
    for (int j = 0; j < categorieBudgetList.length; j++) {
      completeBudgetExpenditures += categorieBudgetList[j].currentExpenditure;
    }
    return completeBudgetExpenditures;
  }

  @override
  List<Budget> calculateBudgetPercentage(List<Budget> budgetList) {
    for (int i = 0; i < budgetList.length; i++) {
      budgetList[i].percentage = (budgetList[i].currentExpenditure * 100) / budgetList[i].budget;
    }
    return budgetList;
  }

  @override
  Future<double> calculateCompleteBudgetAmount(List<Budget> budgetList, DateTime selectedDate) async {
    BudgetRepository budgetRepository = BudgetRepository();
    double completeBudgetAmount = 0.0;
    List<Budget> budgetList = await budgetRepository.loadMonthlyBudgetList(selectedDate);
    for (int i = 0; i < budgetList.length; i++) {
      completeBudgetAmount += budgetList[i].budget;
    }
    return completeBudgetAmount;
  }
}
