import 'package:hive/hive.dart';

import 'booking.dart';

import '/utils/consts/hive_consts.dart';

@HiveType(typeId: subbudgetTypeId)
class Subbudget extends HiveObject {
  late int boxIndex;
  late double currentSubcategorieExpenditure;
  late double currentSubcategoriePercentage;
  @HiveField(0)
  late String categorie;
  @HiveField(1)
  late String subcategorieName;
  @HiveField(2)
  late double subcategorieBudget;
  @HiveField(3)
  late String budgetDate;

  Subbudget createBudgetInstance(Subbudget newSubbudget) {
    return Subbudget()
      ..currentSubcategoriePercentage = newSubbudget.currentSubcategoriePercentage
      ..currentSubcategorieExpenditure = newSubbudget.currentSubcategorieExpenditure
      ..categorie = newSubbudget.categorie
      ..subcategorieName = newSubbudget.subcategorieName
      ..subcategorieBudget = newSubbudget.subcategorieBudget
      ..budgetDate = newSubbudget.budgetDate;
  }

  static void createSubbudgets(String mainCategorie, String subcategorie, List<String> subcategorieNames) async {
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
    }
  }

  static Future<List<Subbudget>> loadSubcategorieList(String categorie) async {
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

  static Future<List<Subbudget>> loadSubcategorieBudgetList(String categorie, List<String> subcategorie, DateTime selectedDate) async {
    var subbudgetBox = await Hive.openBox(subbudgetsBox);
    List<Subbudget> subcategorieBudgetList = [];
    for (int i = 0; i < subbudgetBox.length; i++) {
      Subbudget subbudget = await subbudgetBox.getAt(i);
      for (int j = 0; j < subcategorie.length; j++) {
        if (DateTime.parse(subbudget.budgetDate).month == selectedDate.month &&
            DateTime.parse(subbudget.budgetDate).year == selectedDate.year &&
            subbudget.subcategorieName == subcategorie[j]) {
          subbudget.boxIndex = i;
          subbudget.categorie = categorie;
          subbudget.currentSubcategorieExpenditure = 0.0;
          subbudget.currentSubcategoriePercentage = 0.0;
          subcategorieBudgetList.add(subbudget);
        }
      }
    }
    return subcategorieBudgetList;
  }

  static Future<List<Subbudget>> calculateCurrentExpenditure(List<Subbudget> subbudgetList, DateTime selectedDate) async {
    List<Booking> bookingList = await Booking.loadMonthlyBookingList(selectedDate.month, selectedDate.year);
    for (int i = 0; i < subbudgetList.length; i++) {
      subbudgetList[i].currentSubcategorieExpenditure = Booking.getSubcategorieExpenditures(bookingList, subbudgetList[i].categorie, subbudgetList[i].subcategorieName);
    }
    return subbudgetList;
  }
}

class SubbudgetAdapter extends TypeAdapter<Subbudget> {
  @override
  final typeId = subbudgetTypeId;

  @override
  Subbudget read(BinaryReader reader) {
    return Subbudget()
      ..subcategorieName = reader.read()
      ..subcategorieBudget = reader.read()
      ..budgetDate = reader.read();
  }

  @override
  void write(BinaryWriter writer, Subbudget obj) {
    writer.write(obj.subcategorieName);
    writer.write(obj.subcategorieBudget);
    writer.write(obj.budgetDate);
  }
}
