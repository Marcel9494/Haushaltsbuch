import 'package:hive/hive.dart';

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

  static Future<List<Subbudget>> loadSubcategorieBudgetList(String categorie, List<String> subcategorie, DateTime selectedDate) async {
    var budgetBox = await Hive.openBox(budgetsBox);
    List<Subbudget> subcategorieBudgetList = [];
    for (int i = 0; i < budgetBox.length; i++) {
      Subbudget budget = await budgetBox.getAt(i);
      if (DateTime.parse(budget.budgetDate).month == selectedDate.month && DateTime.parse(budget.budgetDate).year == selectedDate.year && budget.categorie == categorie) {
        budget.boxIndex = i;
        subcategorieBudgetList.add(budget);
      }
    }
    return subcategorieBudgetList;
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
