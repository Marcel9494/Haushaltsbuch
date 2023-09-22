import 'package:hive/hive.dart';

import '/utils/consts/hive_consts.dart';

@HiveType(typeId: defaultBudgetTypeId)
class DefaultBudget extends HiveObject {
  late int boxIndex;
  @HiveField(0)
  late String categorie;
  @HiveField(1)
  late double defaultBudget;

  void createDefaultBudget(DefaultBudget newDefaultBudget) async {
    var defaultBudgetBox = await Hive.openBox(defaultBudgetsBox);
    defaultBudgetBox.add(newDefaultBudget);
  }

  void updateDefaultBudget(DefaultBudget updatedDefaultBudget) async {
    var defaultBudgetBox = await Hive.openBox(defaultBudgetsBox);
    for (int i = 0; i < defaultBudgetBox.length; i++) {
      DefaultBudget defaultBudget = await defaultBudgetBox.getAt(i);
      if (defaultBudget.categorie == updatedDefaultBudget.categorie) {
        defaultBudgetBox.putAt(i, updatedDefaultBudget);
      }
    }
  }

  static void deleteDefaultBudget(String budgetCategorie) async {
    var defaultBudgetBox = await Hive.openBox(defaultBudgetsBox);
    for (int i = 0; i < defaultBudgetBox.length; i++) {
      DefaultBudget defaultBudget = await defaultBudgetBox.getAt(i);
      if (defaultBudget.categorie == budgetCategorie) {
        defaultBudgetBox.deleteAt(i);
        break;
      }
    }
  }

  static Future<DefaultBudget> loadDefaultBudget(String defaultBudgetCategorie) async {
    var defaultBudgetBox = await Hive.openBox(defaultBudgetsBox);
    DefaultBudget defaultBudget = DefaultBudget()
      ..categorie = ''
      ..defaultBudget = 0.0;
    for (int i = 0; i < defaultBudgetBox.length; i++) {
      defaultBudget = await defaultBudgetBox.getAt(i);
      if (defaultBudget.categorie == defaultBudgetCategorie) {
        return defaultBudget;
      }
    }
    return defaultBudget;
  }
}

class DefaultBudgetAdapter extends TypeAdapter<DefaultBudget> {
  @override
  final typeId = defaultBudgetTypeId;

  @override
  DefaultBudget read(BinaryReader reader) {
    return DefaultBudget()
      ..categorie = reader.read()
      ..defaultBudget = reader.read();
  }

  @override
  void write(BinaryWriter writer, DefaultBudget obj) {
    writer.write(obj.categorie);
    writer.write(obj.defaultBudget);
  }
}
