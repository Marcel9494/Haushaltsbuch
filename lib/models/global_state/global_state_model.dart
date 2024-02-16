import 'package:hive/hive.dart';

import '/utils/consts/hive_consts.dart';

@HiveType(typeId: globalStateTypeId)
class GlobalState extends HiveObject {
  @HiveField(0)
  late int bookingSerieIndex;
  @HiveField(1)
  late int categorieIndex;
  @HiveField(2)
  late int defaultBudgetIndex;
}

class GlobalStateAdapter extends TypeAdapter<GlobalState> {
  @override
  final typeId = globalStateTypeId;

  @override
  GlobalState read(BinaryReader reader) {
    return GlobalState()
      ..bookingSerieIndex = reader.read()
      ..categorieIndex = reader.read()
      ..defaultBudgetIndex = reader.read();
  }

  @override
  void write(BinaryWriter writer, GlobalState obj) {
    writer.write(obj.bookingSerieIndex);
    writer.write(obj.categorieIndex);
    writer.write(obj.defaultBudgetIndex);
  }
}
