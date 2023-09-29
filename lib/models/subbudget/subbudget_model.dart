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
}

class SubbudgetAdapter extends TypeAdapter<Subbudget> {
  @override
  final typeId = subbudgetTypeId;

  @override
  Subbudget read(BinaryReader reader) {
    return Subbudget()
      ..categorie = reader.read()
      ..subcategorieName = reader.read()
      ..subcategorieBudget = reader.read()
      ..budgetDate = reader.read();
  }

  @override
  void write(BinaryWriter writer, Subbudget obj) {
    writer.write(obj.categorie);
    writer.write(obj.subcategorieName);
    writer.write(obj.subcategorieBudget);
    writer.write(obj.budgetDate);
  }
}
