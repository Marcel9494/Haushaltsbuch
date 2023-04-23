import 'package:haushaltsbuch/models/booking.dart';
import 'package:hive/hive.dart';

import '/utils/consts/hive_consts.dart';

@HiveType(typeId: 5)
class Budget extends HiveObject {
  late int boxIndex;
  @HiveField(0)
  late String categorie;
  @HiveField(1)
  late double budget;
  late double currentExpenditure;
  late double percentage;

  void createBudget(Budget newBudget) async {
    var budgetBox = await Hive.openBox(budgetsBox);
    budgetBox.add(newBudget);
  }

  static Future<List<Budget>> loadBudgets() async {
    var budgetBox = await Hive.openBox(budgetsBox);
    List<Budget> budgetList = [];
    for (int i = 0; i < budgetBox.length; i++) {
      Budget budget = await budgetBox.getAt(i);
      budget.boxIndex = i;
      budgetList.add(budget);
    }
    budgetList.sort((first, second) => second.percentage.compareTo(first.percentage));
    return budgetList;
  }

  static Future<List<Budget>> calculateCurrentExpenditure(List<Budget> budgetList) async {
    List<Booking> bookingList = await Booking.loadMonthlyBookingList(4, 2023);
    for (int i = 0; i < budgetList.length; i++) {
      budgetList[i].currentExpenditure = Booking.getCategorieExpenditures(bookingList, budgetList[i].categorie);
    }
    return budgetList;
  }

  static List<Budget> calculateBudgetPercentage(List<Budget> budgetList) {
    for (int i = 0; i < budgetList.length; i++) {
      budgetList[i].percentage = (budgetList[i].currentExpenditure * 100) / budgetList[i].budget;
    }
    return budgetList;
  }
}

class BudgetAdapter extends TypeAdapter<Budget> {
  @override
  final typeId = 5;

  @override
  Budget read(BinaryReader reader) {
    return Budget()
      ..categorie = reader.read()
      ..budget = reader.read();
  }

  @override
  void write(BinaryWriter writer, Budget obj) {
    writer.write(obj.categorie);
    writer.write(obj.budget);
  }
}
