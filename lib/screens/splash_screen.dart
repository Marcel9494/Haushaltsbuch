import 'package:flutter/material.dart';
import 'package:haushaltsbuch/screens/introduction_screens.dart';

import '../components/bottom_nav_bar/bottom_nav_bar.dart';
import '../models/account.dart';
import '../models/categorie.dart';
import '../models/global_state.dart';
import '/models/intro_screen_state.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SplashScreenState ();
  }
}

class _SplashScreenState extends State<SplashScreen> {

  late Future<bool> _value;

  @override
  initState() {
    super.initState();
    _value = IntroScreenState.getIntroScreenState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        title: const Text('Flutter FutureBuilder Demo'),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Center(
          child: FutureBuilder<bool>(
            future: _value,
            initialData: true,
            builder: (
                BuildContext context,
                AsyncSnapshot<bool> snapshot,
                ) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    Visibility(
                      visible: snapshot.hasData,
                      child: const Text("Willkommen im Haushaltsbuch",
                        style: TextStyle(color: Colors.black, fontSize: 24),
                      ),
                    )
                  ],
                );
              } else if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return const Text('Fehler beim Laden!');
                } else if (snapshot.hasData) {
                  if (snapshot.data == true) {
                    return const IntroductionScreens();
                  } else {
                    Categorie.createStartExpenditureCategories();
                    Categorie.createStartRevenueCategories();
                    Categorie.createStartInvestmentCategories();
                    Account.createStartAccounts();
                    GlobalState.createGlobalState();
                    IntroScreenState.setIntroScreenState();
                    return const BottomNavBar(screenIndex: 0);
                  }
                } else {
                  return const Text('Keine Daten vorhaden!');
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
