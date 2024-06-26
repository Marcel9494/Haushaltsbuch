import 'package:flutter/material.dart';

import 'introduction_screens.dart';

import '/components/deco/loading_indicator.dart';
import '/components/bottom_nav_bar/bottom_nav_bar.dart';

import '/models/account/account_repository.dart';
import '/models/categorie/categorie_repository.dart';
import '/models/global_state/global_state_repository.dart';
import '/models/primary_account/primary_account_repository.dart';
import '/models/intro_screen_state/intro_screen_state_repository.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SplashScreenState();
  }
}

class _SplashScreenState extends State<SplashScreen> {
  late Future<bool> _value;
  final IntroScreenStateRepository introScreenStateRepository = IntroScreenStateRepository();

  @override
  initState() {
    super.initState();
    // Abfrage des States für die Anzeige des IntroductionScreens
    _value = introScreenStateRepository.getIntroScreenState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Center(
          child: FutureBuilder<bool>(
            future: _value, // IntroScreenState.getIntroScreenState(),
            initialData: true,
            builder: (context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [LoadingIndicator()],
                );
              } else if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return const Text('Fehler beim Laden des Startbildschirms!');
                } else if (snapshot.hasData) {
                  if (snapshot.data == true) {
                    // Wenn State auf true => Anzeigen des IntroScreens
                    introScreenStateRepository.setIntroScreenState();
                    return const IntroductionScreens();
                  } else {
                    // Wenn State auf false => Initialisieren und Anzeigen der Buchungsseite
                    GlobalStateRepository globalStateRepository = GlobalStateRepository();
                    globalStateRepository.create();
                    AccountRepository accountRepository = AccountRepository();
                    accountRepository.createStartAccounts();
                    CategorieRepository categorieRepository = CategorieRepository();
                    categorieRepository.createStartCategories();
                    PrimaryAccountRepository primaryAccountRepository = PrimaryAccountRepository();
                    primaryAccountRepository.createStartPrimaryAccounts();
                    return const BottomNavBar(screenIndex: 0);
                  }
                } else {
                  return const Text('Keine Daten vorhanden!');
                }
              } else {
                return Text('State: ${snapshot.connectionState}');
              }
            },
          ),
        ),
      ),
    );
  }
}
