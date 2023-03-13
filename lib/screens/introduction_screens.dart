import 'package:flutter/material.dart';
import 'package:haushaltsbuch/models/screen_arguments/bottom_nav_bar_screen_arguments.dart';
import 'package:haushaltsbuch/utils/consts/route_consts.dart';

import 'package:introduction_screen/introduction_screen.dart';

class IntroductionScreens extends StatefulWidget {
  const IntroductionScreens({Key? key}) : super(key: key);

  @override
  State<IntroductionScreens> createState() => _IntroductionScreensState();
}

class _IntroductionScreensState extends State<IntroductionScreens> {
  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: [
        PageViewModel(
          title: 'Einnahmen & Ausgaben',
          body: 'Alle Einnahmen & Ausgaben im Blick.',
          //image: _buildImage('img1.jpg'),
          //decoration: pageDecoration,
        ),
        PageViewModel(
          title: 'Budgets festlegen',
          body: 'TODO',
          //image: _buildImage('img2.jpg'),
          //decoration: pageDecoration,
        ),
        PageViewModel(
          title: 'Konten und Vermögen verwalten',
          body: 'TODO',
          //image: _buildImage('img2.jpg'),
          //decoration: pageDecoration,
        ),
        PageViewModel(
          title: 'Statistiken',
          body: 'TODO',
          //image: _buildImage('img2.jpg'),
          //decoration: pageDecoration,
        ),
      ],
      showNextButton: true,
      showSkipButton: true,
      skip: const Text('Überspringen'),
      next: const Text('Weiter'),
      done: const Text('Fertig'),
      onDone: () {
        Navigator.popAndPushNamed(context, bottomNavBarRoute, arguments: BottomNavBarScreenArguments(0));
      },
    );
  }
}
