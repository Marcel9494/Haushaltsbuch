import 'package:flutter/material.dart';

import 'package:introduction_screen/introduction_screen.dart';

import '../models/global_state.dart';
import '/models/account.dart';
import '/models/categorie.dart';
import '/models/screen_arguments/bottom_nav_bar_screen_arguments.dart';

import '/utils/consts/route_consts.dart';

class IntroductionScreens extends StatefulWidget {
  const IntroductionScreens({Key? key}) : super(key: key);

  @override
  State<IntroductionScreens> createState() => _IntroductionScreensState();
}

class _IntroductionScreensState extends State<IntroductionScreens> {
  @override
  void initState() {
    _forwardToApp();
    super.initState();
  }

  void _forwardToApp() async {
    // TODO funktioniert noch nicht
    /*if (await Categorie.checkIfCategoriesExists()) {
      Navigator.popAndPushNamed(context, bottomNavBarRoute, arguments: BottomNavBarScreenArguments(0));
    }*/
  }

  void _createStartCategoriesAndAccounts() {
    Categorie.createStartExpenditureCategories();
    Categorie.createStartRevenueCategories();
    Categorie.createStartInvestmentCategories();
    Account.createStartAccounts();
    GlobalState.createGlobalState();
    Navigator.popAndPushNamed(context, bottomNavBarRoute, arguments: BottomNavBarScreenArguments(0));
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: [
        PageViewModel(
          title: 'Einnahmen, Ausgaben & Investitionen',
          body: 'Alle Einnahmen, Ausgaben & Investitionen im Blick.',
          image: Image.asset('assets/images/introduction_screen_image1.jpg'),
        ),
        PageViewModel(
          title: 'Budgets festlegen',
          body: 'Budgets erstellen, Monat für Monat anpassen & Ausgaben verfolgen.',
          image: Image.asset('assets/images/introduction_screen_image2.png'),
        ),
        PageViewModel(
          title: 'Konten und Vermögen verwalten',
          body: 'TODO',
          //image: _buildImage('img2.jpg'),
        ),
        PageViewModel(
          title: 'Statistiken',
          body: 'Statistische Auswertungen deiner Einnahmen und Ausgaben, sowie deiner Vermögensentwicklungen.',
          image: Image.asset('assets/images/introduction_screen_image4.png'),
        ),
      ],
      showNextButton: true,
      showSkipButton: true,
      skip: const Text('Überspringen'),
      skipStyle: const ButtonStyle(
        foregroundColor: MaterialStatePropertyAll<Color>(Colors.cyanAccent),
      ),
      next: const Text('Weiter'),
      nextStyle: const ButtonStyle(
        foregroundColor: MaterialStatePropertyAll<Color>(Colors.cyanAccent),
      ),
      done: const Text('Fertig'),
      doneStyle: const ButtonStyle(
        foregroundColor: MaterialStatePropertyAll<Color>(Colors.cyanAccent),
      ),
      onDone: () {
        _createStartCategoriesAndAccounts();
      },
    );
  }
}
