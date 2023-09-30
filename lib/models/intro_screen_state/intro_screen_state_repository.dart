import 'package:hive/hive.dart';

import '/utils/consts/hive_consts.dart';

import 'intro_screen_state_interface.dart';
import 'intro_screen_state_model.dart';

class IntroScreenStateRepository extends IntroScreenStateInterface {
  @override
  void init() async {
    var introBox = await Hive.openBox(introScreenBox);
    var startIntroScreenState = IntroScreenState()..introductionState = true;
    introBox.add(startIntroScreenState);
  }

  @override
  Future<bool> getIntroScreenState() async {
    var introBox = await Hive.openBox(introScreenBox);
    IntroScreenState introScreenState = await introBox.get(0);
    return introScreenState.introductionState;
  }

  @override
  void setIntroScreenState() async {
    var introBox = await Hive.openBox(introScreenBox);
    IntroScreenState introScreenState = await introBox.get(0);
    introScreenState.introductionState = !introScreenState.introductionState;
    introBox.putAt(0, introScreenState);
  }
}
