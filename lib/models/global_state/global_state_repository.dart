import 'package:hive/hive.dart';

import '/utils/consts/hive_consts.dart';
import 'global_state_interface.dart';
import 'global_state_model.dart';

class GlobalStateRepository extends GlobalStateInterface {
  @override
  void create() async {
    var globalBox = await Hive.openBox(globalStateBox);
    if (globalBox.isNotEmpty) {
      return;
    }
    var startGlobalState = GlobalState()
      ..categorieIndex = 0
      ..bookingSerieIndex = 0
      ..defaultBudgetIndex = 0;
    globalBox.add(startGlobalState);
  }

  @override
  Future<int> getBookingSerieIndex() async {
    var globalBox = await Hive.openBox(globalStateBox);
    GlobalState globalState = await globalBox.getAt(0);
    return globalState.bookingSerieIndex;
  }

  @override
  void increaseBookingSerieIndex() async {
    var globalBox = await Hive.openBox(globalStateBox);
    GlobalState globalState = await globalBox.getAt(0);
    globalState.bookingSerieIndex = globalState.bookingSerieIndex + 1;
    globalBox.putAt(0, globalState);
  }

  @override
  Future<int> getCategorieIndex() async {
    var globalBox = await Hive.openBox(globalStateBox);
    GlobalState globalState = await globalBox.getAt(0);
    return globalState.categorieIndex;
  }

  @override
  void increaseCategorieIndex() async {
    var globalBox = await Hive.openBox(globalStateBox);
    GlobalState globalState = await globalBox.getAt(0);
    globalState.categorieIndex = globalState.categorieIndex + 1;
    globalBox.putAt(0, globalState);
  }

  @override
  Future<int> getDefaultBudgetIndex() async {
    var globalBox = await Hive.openBox(globalStateBox);
    GlobalState globalState = await globalBox.getAt(0);
    return globalState.defaultBudgetIndex;
  }

  @override
  void increaseDefaultBudgetIndex() async {
    var globalBox = await Hive.openBox(globalStateBox);
    GlobalState globalState = await globalBox.getAt(0);
    globalState.defaultBudgetIndex = globalState.defaultBudgetIndex + 1;
    globalBox.putAt(0, globalState);
  }
}
