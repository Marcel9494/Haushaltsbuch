import 'package:hive/hive.dart';

import 'default_budget.dart';

import '/models/booking.dart';

import '/utils/consts/hive_consts.dart';

@HiveType(typeId: budgetTypeId)
class Budget extends HiveObject {
  late int boxIndex;
  late double currentExpenditure;
  late double percentage;
  @HiveField(0)
  late String categorie;
  @HiveField(1)
  late double budget;
  @HiveField(2)
  late String budgetDate;

  Budget createBudgetInstance(Budget newBudget) {
    return Budget()
      ..percentage = newBudget.percentage
      ..currentExpenditure = newBudget.currentExpenditure
      ..categorie = newBudget.categorie
      ..budget = newBudget.budget
      ..budgetDate = newBudget.budgetDate;
  }

  void createBudget(Budget newBudget) async {
    var budgetBox = await Hive.openBox(budgetsBox);
    budgetBox.add(newBudget);
    // TODO Anzahl der Budgets erhöhen, damit für die nächsten 10 Jahre Budgets erstellt werden. 3 nur als Test.
    for (int i = 0; i < 3; i++) {
      DateTime date = DateTime.parse(budgetDate);
      Budget nextBudget = createBudgetInstance(newBudget);
      nextBudget.budgetDate = DateTime(date.year, date.month + i + 1, 1).toString();
      budgetBox.add(nextBudget);
    }
  }

  void updateBudget(Budget updatedBudget, int budgetBoxIndex) async {
    var budgetBox = await Hive.openBox(budgetsBox);
    budgetBox.putAt(budgetBoxIndex, updatedBudget);
  }

  static void updateAllFutureBudgetsFromCategorie(DefaultBudget defaultBudget) async {
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

  static void updateAllBudgetsFromCategorie(DefaultBudget defaultBudget) async {
    var budgetBox = await Hive.openBox(budgetsBox);
    for (int i = 0; i < budgetBox.length; i++) {
      Budget budget = await budgetBox.getAt(i);
      if (budget.categorie == defaultBudget.categorie) {
        budget.budget = defaultBudget.defaultBudget;
        // TODO mit putAt updaten?
      }
    }
  }

  void deleteAllBudgetsFromCategorie(String budgetCategorie) async {
    var budgetBox = await Hive.openBox(budgetsBox);
    for (int i = budgetBox.length - 1; i >= 0; i--) {
      Budget budget = await budgetBox.getAt(i);
      if (budget.categorie == budgetCategorie) {
        budgetBox.deleteAt(i);
      }
    }
    DefaultBudget.deleteDefaultBudget(budgetCategorie);
  }

  static Future<Budget> loadBudget(int budgetBoxIndex) async {
    var budgetBox = await Hive.openBox(budgetsBox);
    Budget budget = await budgetBox.getAt(budgetBoxIndex);
    return budget;
  }

  static Future<List<Budget>> loadAllBudgetCategories() async {
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

  static Future<List<Budget>> loadOneBudgetCategorie(String budgetCategorie, [int selectedYear = -1]) async {
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

  static Future<List<Budget>> loadMonthlyBudgetList(DateTime selectedDate) async {
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

  static Future<bool> existsBudgetForCategorie(String budgetCategorie) async {
    var budgetBox = await Hive.openBox(budgetsBox);
    for (int i = 0; i < budgetBox.length; i++) {
      Budget budget = await budgetBox.getAt(i);
      if (budget.categorie == budgetCategorie) {
        return Future.value(true);
      }
    }
    return Future.value(false);
  }

  static Future<List<Budget>> calculateCurrentExpenditure(List<Budget> budgetList, DateTime selectedDate) async {
    List<Booking> bookingList = await Booking.loadMonthlyBookingList(selectedDate.month, selectedDate.year);
    for (int i = 0; i < budgetList.length; i++) {
      budgetList[i].currentExpenditure = Booking.getExpenditures(bookingList, budgetList[i].categorie);
    }
    return budgetList;
  }

  static Future<double> calculateCompleteBudgetExpenditures(List<Budget> budgetList, DateTime selectedDate) async {
    double completeBudgetExpenditures = 0.0;
    List<Budget> categorieBudgetList = await calculateCurrentExpenditure(budgetList, selectedDate);
    for (int j = 0; j < categorieBudgetList.length; j++) {
      completeBudgetExpenditures += categorieBudgetList[j].currentExpenditure;
    }
    return completeBudgetExpenditures;
  }

  static List<Budget> calculateBudgetPercentage(List<Budget> budgetList) {
    for (int i = 0; i < budgetList.length; i++) {
      budgetList[i].percentage = (budgetList[i].currentExpenditure * 100) / budgetList[i].budget;
    }
    return budgetList;
  }

  static Future<double> calculateCompleteBudgetAmount(List<Budget> budgetList, DateTime selectedDate) async {
    double completeBudgetAmount = 0.0;
    List<Budget> budgetList = await Budget.loadMonthlyBudgetList(selectedDate);
    for (int i = 0; i < budgetList.length; i++) {
      completeBudgetAmount += budgetList[i].budget;
    }
    return completeBudgetAmount;
  }
}

class BudgetAdapter extends TypeAdapter<Budget> {
  @override
  final typeId = budgetTypeId;

  @override
  Budget read(BinaryReader reader) {
    return Budget()
      ..categorie = reader.read()
      ..budget = reader.read()
      ..budgetDate = reader.read();
  }

  @override
  void write(BinaryWriter writer, Budget obj) {
    writer.write(obj.categorie);
    writer.write(obj.budget);
    writer.write(obj.budgetDate);
  }
}
