import 'package:haushaltsbuch/models/global_state/global_state_repository.dart';
import 'package:hive/hive.dart';

import '/utils/consts/hive_consts.dart';

import '/models/subbudget/subbudget_model.dart';
import '/models/subbudget/subbudget_interface.dart';

import '../booking/booking_model.dart';
import '../booking/booking_repository.dart';
import '../default_budget/default_budget_model.dart';
import '../default_budget/default_budget_repository.dart';

class SubbudgetRepository extends SubbudgetInterface {
  @override
  Subbudget createInstance(Subbudget newSubbudget) {
    return Subbudget()
      ..currentSubcategoriePercentage = newSubbudget.currentSubcategoriePercentage
      ..currentSubcategorieExpenditure = newSubbudget.currentSubcategorieExpenditure
      ..categorie = newSubbudget.categorie
      ..subcategorieName = newSubbudget.subcategorieName
      ..subcategorieBudget = newSubbudget.subcategorieBudget
      ..budgetDate = newSubbudget.budgetDate;
  }

  @override
  void create(Subbudget newSubbudget) async {
    var subbudgetBox = await Hive.openBox(subbudgetsBox);
    subbudgetBox.add(newSubbudget);
    // TODO Anzahl der Budgets erhöhen, damit für die nächsten 10 Jahre Subbudgets erstellt werden. 3 nur als Test.
    for (int i = 0; i < 3; i++) {
      Subbudget nextSubbudget = createInstance(newSubbudget);
      nextSubbudget.budgetDate = DateTime(DateTime.now().year, DateTime.now().month + i + 1, 1).toString(); // TODO Jahr dynamisch implementieren
      subbudgetBox.add(nextSubbudget);
    }
  }

  @override
  void createSubbudgets(String mainCategorie, String subcategorie, List<String> subcategorieNames) async {
    var subbudgetBox = await Hive.openBox(subbudgetsBox);
    for (int i = 0; i < subcategorieNames.length; i++) {
      // TODO Anzahl der Budgets erhöhen, damit für die nächsten 10 Jahre Budgets erstellt werden. 3 nur als Test.
      if (subcategorieNames[i] == subcategorie) {
        continue;
      }
      for (int j = 0; j < 3; j++) {
        DateTime date = DateTime.now();
        Subbudget subbudget = Subbudget()
          ..boxIndex = i
          ..subcategorieBudget = 0.0
          ..subcategorieName = subcategorieNames[i]
          ..currentSubcategoriePercentage = 0.0
          ..currentSubcategorieExpenditure = 0.0
          ..categorie = mainCategorie
          ..budgetDate = DateTime(date.year, date.month + j, 1).toString();
        subbudgetBox.add(subbudget);
      }

      GlobalStateRepository globalStateRepository = GlobalStateRepository();
      DefaultBudget newDefaultSubcategoriebudget = DefaultBudget()
        ..index = await globalStateRepository.getDefaultBudgetIndex()
        ..categorie = subcategorieNames[i]
        ..defaultBudget = 0.0;
      DefaultBudgetRepository defaultBudgetRepository = DefaultBudgetRepository();
      defaultBudgetRepository.create(newDefaultSubcategoriebudget);
    }
  }

  @override
  void update(Subbudget updatedSubbudget, int subbudgetBoxIndex) async {
    var subbudgetBox = await Hive.openBox(subbudgetsBox);
    subbudgetBox.putAt(subbudgetBoxIndex, updatedSubbudget);
  }

  @override
  void updateAllSubbudgetsForCategorie(String budgetCategorie, double newBudgetAmount) async {
    var subbudgetBox = await Hive.openBox(subbudgetsBox);
    for (int i = 0; i < subbudgetBox.length; i++) {
      Subbudget subbudget = await subbudgetBox.getAt(i);
      if (subbudget.subcategorieName == budgetCategorie) {
        subbudget.subcategorieBudget = newBudgetAmount;
        subbudgetBox.putAt(i, subbudget);
      }
    }
  }

  @override
  Future<List<Subbudget>> loadSubcategorieList(String categorie) async {
    var subbudgetBox = await Hive.openBox(subbudgetsBox);
    List<Subbudget> subcategorieList = [];
    for (int i = 0; i < subbudgetBox.length; i++) {
      Subbudget subbudget = await subbudgetBox.getAt(i);
      if (subbudget.categorie == categorie) {
        bool subcategorieIsAlreadyInList = false;
        for (int j = 0; j < subcategorieList.length; j++) {
          if (subcategorieList[j].subcategorieName == subbudget.subcategorieName) {
            subcategorieIsAlreadyInList = true;
          }
        }
        if (subcategorieIsAlreadyInList == false) {
          subcategorieList.add(subbudget);
        }
      }
    }
    return subcategorieList;
  }

  @override
  Future<List<Subbudget>> loadSubcategorieBudgetList(String categorie, List<String> subcategorie, DateTime selectedDate) async {
    var subbudgetBox = await Hive.openBox(subbudgetsBox);
    List<Subbudget> subcategorieBudgetList = [];
    for (int i = 0; i < subbudgetBox.length; i++) {
      Subbudget subbudget = await subbudgetBox.getAt(i);
      for (int j = 0; j < subcategorie.length; j++) {
        if (DateTime.parse(subbudget.budgetDate).month == selectedDate.month &&
            DateTime.parse(subbudget.budgetDate).year == selectedDate.year &&
            subbudget.subcategorieName == subcategorie[j]) {
          subbudget.boxIndex = i;
          subbudget.currentSubcategorieExpenditure = 0.0;
          subbudget.currentSubcategoriePercentage = 0.0;
          subcategorieBudgetList.add(subbudget);
        }
      }
    }
    return subcategorieBudgetList;
  }

  @override
  Future<Subbudget> load(int subbudgetBoxIndex) async {
    var subbudgetBox = await Hive.openBox(subbudgetsBox);
    Subbudget subbudget = await subbudgetBox.getAt(subbudgetBoxIndex);
    return subbudget;
  }

  @override
  Future<List<Subbudget>> loadSubbudgetListFromOneCategorie(String subbudgetCategorie, [int selectedYear = -1]) async {
    var subbudgetBox = await Hive.openBox(subbudgetsBox);
    List<Subbudget> subbudgetList = [];
    for (int i = 0; i < subbudgetBox.length; i++) {
      Subbudget subbudget = await subbudgetBox.getAt(i);
      if (DateTime.parse(subbudget.budgetDate).year == selectedYear && subbudget.subcategorieName == subbudgetCategorie && selectedYear != -1) {
        subbudget.boxIndex = i;
        subbudgetList.add(subbudget);
      }
    }
    return subbudgetList;
  }

  @override
  Future<List<Subbudget>> loadOneSubbudget(String subcategorieName) async {
    var subbudgetBox = await Hive.openBox(subbudgetsBox);
    List<Subbudget> subbudgetList = [];
    for (int i = 0; i < subbudgetBox.length; i++) {
      Subbudget subbudget = await subbudgetBox.getAt(i);
      if (subbudget.subcategorieName == subcategorieName) {
        subbudget.boxIndex = i;
        subbudgetList.add(subbudget);
      }
    }
    return subbudgetList;
  }

  @override
  void deleteAllBudgetsFromCategorie(String subbudgetCategorie) async {
    var subbudgetBox = await Hive.openBox(subbudgetsBox);
    for (int i = subbudgetBox.length - 1; i >= 0; i--) {
      Subbudget subbudget = await subbudgetBox.getAt(i);
      if (subbudget.subcategorieName == subbudgetCategorie) {
        subbudgetBox.deleteAt(i);
      }
    }
    DefaultBudgetRepository defaultBudgetRepository = DefaultBudgetRepository();
    defaultBudgetRepository.delete(subbudgetCategorie);
  }

  @override
  Future<bool> existsSubbudgetForCategorie(String subbudgetCategorie) async {
    var subbudgetBox = await Hive.openBox(subbudgetsBox);
    for (int i = 0; i < subbudgetBox.length; i++) {
      Subbudget subbudget = await subbudgetBox.getAt(i);
      if (subbudget.subcategorieName == subbudgetCategorie) {
        return true;
      }
    }
    return false;
  }

  @override
  Future<List<Subbudget>> calculateCurrentExpenditure(List<Subbudget> subbudgetList, DateTime selectedDate) async {
    BookingRepository bookingRepository = BookingRepository();
    List<Booking> bookingList = await bookingRepository.loadMonthlyBookings(selectedDate.month, selectedDate.year);
    for (int i = 0; i < subbudgetList.length; i++) {
      subbudgetList[i].currentSubcategorieExpenditure = bookingRepository.getSubcategorieExpenditures(bookingList, subbudgetList[i].categorie, subbudgetList[i].subcategorieName);
    }
    return subbudgetList;
  }
}
