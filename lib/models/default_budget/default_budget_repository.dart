import 'package:hive/hive.dart';

import '/utils/consts/hive_consts.dart';

import 'default_budget_interface.dart';
import 'default_budget_model.dart';

class DefaultBudgetRepository extends DefaultBudgetInterface {
  @override
  void create(DefaultBudget newDefaultBudget) async {
    var defaultBudgetBox = await Hive.openBox(defaultBudgetsBox);
    defaultBudgetBox.add(newDefaultBudget);
  }

  @override
  void update(DefaultBudget updatedDefaultBudget) async {
    var defaultBudgetBox = await Hive.openBox(defaultBudgetsBox);
    for (int i = 0; i < defaultBudgetBox.length; i++) {
      DefaultBudget defaultBudget = await defaultBudgetBox.getAt(i);
      if (defaultBudget.categorie == updatedDefaultBudget.categorie) {
        defaultBudgetBox.putAt(i, updatedDefaultBudget);
      }
    }
  }

  @override
  void delete(String budgetCategorie) async {
    var defaultBudgetBox = await Hive.openBox(defaultBudgetsBox);
    for (int i = 0; i < defaultBudgetBox.length; i++) {
      DefaultBudget defaultBudget = await defaultBudgetBox.getAt(i);
      if (defaultBudget.categorie == budgetCategorie) {
        defaultBudgetBox.deleteAt(i);
        break;
      }
    }
  }

  @override
  Future<DefaultBudget> load(String defaultBudgetCategorie) async {
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
