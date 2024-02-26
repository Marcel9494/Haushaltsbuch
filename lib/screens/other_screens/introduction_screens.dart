import 'package:flutter/material.dart';

import 'package:introduction_screen/introduction_screen.dart';

import '/models/global_state/global_state_repository.dart';
import '/models/primary_account/primary_account_repository.dart';
import '/models/account/account_repository.dart';
import '/models/categorie/categorie_repository.dart';
import '/models/screen_arguments/bottom_nav_bar_screen_arguments.dart';

import '/utils/consts/route_consts.dart';

class IntroductionScreens extends StatefulWidget {
  const IntroductionScreens({Key? key}) : super(key: key);

  @override
  State<IntroductionScreens> createState() => _IntroductionScreensState();
}

class _IntroductionScreensState extends State<IntroductionScreens> {
  bool _startValuesCreated = false;

  void _createStartCategoriesAndAccounts() {
    if (_startValuesCreated == false) {
      GlobalStateRepository globalStateRepository = GlobalStateRepository();
      globalStateRepository.create();
      AccountRepository accountRepository = AccountRepository();
      accountRepository.createStartAccounts();
      CategorieRepository categorieRepository = CategorieRepository();
      categorieRepository.createStartCategories();
      PrimaryAccountRepository primaryAccountRepository = PrimaryAccountRepository();
      primaryAccountRepository.createStartPrimaryAccounts();
      _startValuesCreated = true;
    }
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
          image: Image.asset('assets/images/introduction_screen_image2.jpg'),
        ),
        PageViewModel(
          title: 'Konten und Vermögen verwalten',
          body: 'Verwalte deine Konten & dein Vermögen & behalte stets den Überblick.',
          image: Image.asset('assets/images/introduction_screen_image3.jpg'),
          //image: _buildImage('img2.jpg'),
        ),
        PageViewModel(
          title: 'Statistiken',
          body: 'Statistische Auswertungen deiner Einnahmen & Ausgaben, sowie deiner Vermögensentwicklungen.',
          image: Image.asset('assets/images/introduction_screen_image4.jpg'),
        ),
      ],
      showNextButton: true,
      showSkipButton: true,
      skip: const Text('Überspringen'),
      skipStyle: const ButtonStyle(
        foregroundColor: MaterialStatePropertyAll<Color>(Colors.black),
      ),
      next: const Text('Weiter'),
      nextStyle: const ButtonStyle(
        foregroundColor: MaterialStatePropertyAll<Color>(Colors.black),
      ),
      done: const Text('Fertig'),
      doneStyle: const ButtonStyle(
        foregroundColor: MaterialStatePropertyAll<Color>(Colors.black),
      ),
      onChange: (_) {
        // Muss in onChange aufgerufen werden.
        // Wenn dies erst bei onDone aufgerufen wird werden die Startkonten beim ersten Start der App nicht richtig angezeigt.
        _createStartCategoriesAndAccounts();
      },
      onDone: () {
        Navigator.popAndPushNamed(context, bottomNavBarRoute, arguments: BottomNavBarScreenArguments(0));
      },
      dotsDecorator: DotsDecorator(
        size: const Size.square(10.0),
        activeSize: const Size(20.0, 10.0),
        activeColor: Theme.of(context).colorScheme.secondary,
        color: Colors.white,
        spacing: const EdgeInsets.symmetric(horizontal: 3.0),
        activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
      ),
      baseBtnStyle: TextButton.styleFrom(
        backgroundColor: Colors.cyanAccent,
      ),
      curve: Curves.fastOutSlowIn,
      animationDuration: 1000,
      allowImplicitScrolling: false,
    );
  }
}
