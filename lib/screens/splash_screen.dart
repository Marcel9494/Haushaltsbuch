import 'package:flutter/material.dart';

import '/screens/introduction_screens.dart';

import '/components/deco/loading_indicator.dart';
import '/components/bottom_nav_bar/bottom_nav_bar.dart';

import '/models/account.dart';
import '/models/global_state.dart';
import '/models/primary_account.dart';
import '/models/intro_screen_state.dart';
import '/models/categorie/categorie_repository.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SplashScreenState();
  }
}

class _SplashScreenState extends State<SplashScreen> {
  late Future<bool> _value;

  @override
  initState() {
    super.initState();
    // Abfrage des States für die Anzeige des IntroductionScreens
    _value = IntroScreenState.getIntroScreenState();
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
                    IntroScreenState.setIntroScreenState();
                    return const IntroductionScreens();
                  } else {
                    // Wenn State auf false => Initialisieren und Anzeigen der Buchungsseite
                    CategorieRepository categorieRepository = CategorieRepository();
                    categorieRepository.createStartExpenditureCategories();
                    categorieRepository.createStartRevenueCategories();
                    categorieRepository.createStartInvestmentCategories();
                    Account.createStartAccounts();
                    PrimaryAccount.createStartPrimaryAccounts();
                    GlobalState.createGlobalState();
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
