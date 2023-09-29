import 'package:hive/hive.dart';

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
