import 'package:hive/hive.dart';

import '/utils/consts/hive_consts.dart';

@HiveType(typeId: introScreenTypeId)
class IntroScreenState extends HiveObject {
  @HiveField(0)
  late bool introductionState;

  static void createIntroScree() async {
    var introBox = await Hive.openBox(introScreenBox);
    var startIntroScreenState = IntroScreenState()..introductionState = true;
    introBox.add(startIntroScreenState);
  }

  static Future<bool> getIntroScreenState() async {
    var introBox = await Hive.openBox(introScreenBox);
    IntroScreenState introScreenState = await introBox.get(0);
    return introScreenState.introductionState;
  }

  static void setIntroScreenState() async {
    var introBox = await Hive.openBox(introScreenBox);
    IntroScreenState introScreenState = await introBox.get(0);
    introScreenState.introductionState = !introScreenState.introductionState;
    introBox.putAt(0, introScreenState);
  }
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