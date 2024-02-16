import 'package:hive/hive.dart';

import '/utils/consts/hive_consts.dart';

@HiveType(typeId: defaultBudgetTypeId)
class DefaultBudget extends HiveObject {
  @HiveField(0)
  late int index;
  @HiveField(1)
  late String categorie;
  @HiveField(2)
  late double defaultBudget;
}

class DefaultBudgetAdapter extends TypeAdapter<DefaultBudget> {
  @override
  final typeId = defaultBudgetTypeId;

  @override
  DefaultBudget read(BinaryReader reader) {
    return DefaultBudget()
      ..index = reader.read()
      ..categorie = reader.read()
      ..defaultBudget = reader.read();
  }

  @override
  void write(BinaryWriter writer, DefaultBudget obj) {
    writer.write(obj.index);
    writer.write(obj.categorie);
    writer.write(obj.defaultBudget);
  }
}
