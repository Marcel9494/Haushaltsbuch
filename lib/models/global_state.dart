import 'package:hive/hive.dart';

import '/utils/consts/hive_consts.dart';

@HiveType(typeId: globalStateTypeId)
class GlobalState extends HiveObject {
  @HiveField(0)
  late int bookingSerieIndex;

  static void createGlobalState() async {
    var globalBox = await Hive.openBox(globalStateBox);
    var startGlobalState = GlobalState()..bookingSerieIndex = 0;
    globalBox.add(startGlobalState);
  }

  static Future<int> getBookingSerieIndex() async {
    var globalBox = await Hive.openBox(globalStateBox);
    GlobalState globalState = await globalBox.getAt(0);
    return globalState.bookingSerieIndex;
  }

  static void increaseBookingSerieIndex() async {
    var globalBox = await Hive.openBox(globalStateBox);
    GlobalState globalState = await globalBox.getAt(0);
    globalState.bookingSerieIndex = globalState.bookingSerieIndex + 1;
    globalBox.putAt(0, globalState);
  }
}

class GlobalStateAdapter extends TypeAdapter<GlobalState> {
  @override
  final typeId = globalStateTypeId;

  @override
  GlobalState read(BinaryReader reader) {
    return GlobalState()..bookingSerieIndex = reader.read();
  }

  @override
  void write(BinaryWriter writer, GlobalState obj) {
    writer.write(obj.bookingSerieIndex);
  }
}
