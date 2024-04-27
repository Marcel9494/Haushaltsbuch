import 'package:flutter/material.dart';
import 'package:haushaltsbuch/utils/consts/hive_consts.dart';
import 'package:introduction_screen/introduction_screen.dart';

import '/models/account/account_repository.dart';
import '/models/categorie/categorie_repository.dart';
import '/models/global_state/global_state_repository.dart';
import '/models/primary_account/primary_account_repository.dart';
import '/models/screen_arguments/bottom_nav_bar_screen_arguments.dart';
import '/utils/consts/route_consts.dart';

class IntroductionScreens extends StatefulWidget {
  const IntroductionScreens({Key? key}) : super(key: key);

  @override
  State<IntroductionScreens> createState() => _IntroductionScreensState();
}

class _IntroductionScreensState extends State<IntroductionScreens> {
  bool _isProdHiveValuesInitialized = false;

  // Produktiv Modus Start Werte setzen
  void _initializeProdHiveValues() {
    if (_isProdHiveValuesInitialized == false) {
      setHiveMode(false);
      GlobalStateRepository globalStateRepository = GlobalStateRepository();
      globalStateRepository.create();
      AccountRepository accountRepository = AccountRepository();
      accountRepository.createStartAccounts();
      CategorieRepository categorieRepository = CategorieRepository();
      categorieRepository.createStartCategories();
      PrimaryAccountRepository primaryAccountRepository = PrimaryAccountRepository();
      primaryAccountRepository.createStartPrimaryAccounts();
      _isProdHiveValuesInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      globalBackgroundColor: Colors.white,
      isTopSafeArea: true,
      pages: [
        PageViewModel(
          titleWidget: const Padding(
            padding: EdgeInsets.only(top: 48.0),
            child: Text(
              'Einnahmen, Ausgaben & Investitionen',
              style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 24.0),
              textAlign: TextAlign.center,
            ),
          ),
          bodyWidget: const Text(
            'Behalte alle deine Einnahmen, Ausgaben & Investitionen im Blick.',
            style: TextStyle(color: Colors.black87, fontSize: 18.0),
            textAlign: TextAlign.center,
          ),
          image: Image.asset('assets/images/introduction_screen_image1.jpg'),
        ),
        PageViewModel(
          titleWidget: const Padding(
            padding: EdgeInsets.only(top: 48.0),
            child: Text(
              'Budgets',
              style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 24.0),
              textAlign: TextAlign.center,
            ),
          ),
          bodyWidget: const Text(
            'Setze dir feste monatliche Budgets und behalte diese immer im Überblick.',
            style: TextStyle(color: Colors.black87, fontSize: 18.0),
            textAlign: TextAlign.center,
          ),
          image: Image.asset('assets/images/introduction_screen_image2.jpg'),
        ),
        PageViewModel(
          titleWidget: const Padding(
            padding: EdgeInsets.only(top: 48.0),
            child: Text(
              'Konten',
              style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 24.0),
              textAlign: TextAlign.center,
            ),
          ),
          bodyWidget: const Text(
            'Behalte alle deine Konten und Investments im Blick.',
            style: TextStyle(color: Colors.black87, fontSize: 18.0),
            textAlign: TextAlign.center,
          ),
          image: Image.asset('assets/images/introduction_screen_image3.jpg'),
        ),
        PageViewModel(
          titleWidget: const Padding(
            padding: EdgeInsets.only(top: 48.0),
            child: Text(
              'Updates',
              style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 24.0),
              textAlign: TextAlign.center,
            ),
          ),
          bodyWidget: const Text(
            'Die App wird stetig weiter entwickelt und verbessert.\nFreue dich auf viele weitere Features.',
            style: TextStyle(color: Colors.black87, fontSize: 18.0),
            textAlign: TextAlign.center,
          ),
          image: Image.asset('assets/images/introduction_screen_image4.jpg'),
        ),
      ],
      showNextButton: true,
      showSkipButton: true,
      skip: const Text('Überspringen'),
      skipStyle: const ButtonStyle(
        foregroundColor: MaterialStatePropertyAll<Color>(Colors.black87),
      ),
      next: const Text('Weiter'),
      nextStyle: const ButtonStyle(
        foregroundColor: MaterialStatePropertyAll<Color>(Colors.black87),
      ),
      done: const Text('Fertig'),
      doneStyle: const ButtonStyle(
        foregroundColor: MaterialStatePropertyAll<Color>(Colors.black87),
      ),
      onChange: (_) async {
        // Muss in onChange aufgerufen werden.
        // Wenn dies erst bei onDone aufgerufen wird werden die Startkonten beim ersten Start der App nicht richtig angezeigt.
        _initializeProdHiveValues();
      },
      onDone: () {
        Navigator.popAndPushNamed(context, bottomNavBarRoute, arguments: BottomNavBarScreenArguments(0));
      },
      dotsDecorator: DotsDecorator(
        size: const Size.square(10.0),
        activeSize: const Size(20.0, 10.0),
        activeColor: Theme.of(context).colorScheme.secondary,
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
