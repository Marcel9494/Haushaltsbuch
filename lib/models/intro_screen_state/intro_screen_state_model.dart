import 'package:hive/hive.dart';

import '/utils/consts/hive_consts.dart';

class IntroScreenState extends HiveObject {
  @HiveField(0)
  late bool introductionState;
}

class IntroScreenStateAdapter extends TypeAdapter<IntroScreenState> {
  @override
  final typeId = introScreenTypeId;

  @override
  IntroScreenState read(BinaryReader reader) {
    return IntroScreenState()..introductionState = reader.read();
  }

  @override
  void write(BinaryWriter writer, IntroScreenState obj) => writer.write(obj.introductionState);
}
