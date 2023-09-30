import 'package:hive/hive.dart';

import '/utils/consts/hive_consts.dart';
import 'global_state_interface.dart';
import 'global_state_model.dart';

class GlobalStateRepository extends GlobalStateInterface {
  @override
  void create() async {
    var globalBox = await Hive.openBox(globalStateBox);
    var startGlobalState = GlobalState()..bookingSerieIndex = 0;
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
}
