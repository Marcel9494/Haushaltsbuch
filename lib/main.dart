import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:hive_flutter/adapters.dart';

import '/utils/consts/route_consts.dart';

import 'models/booking.dart';
import 'models/account.dart';
import 'models/categorie.dart';
import 'models/enums/booking_repeats.dart';
import 'models/enums/transaction_types.dart';
import 'models/screen_arguments/bottom_nav_bar_screen_arguments.dart';
import 'models/screen_arguments/account_details_screen_arguments.dart';
import 'models/screen_arguments/create_or_edit_account_screen_arguments.dart';
import 'models/screen_arguments/create_or_edit_booking_screen_arguments.dart';
import 'models/screen_arguments/create_or_edit_categorie_screen_arguments.dart';

import '/components/bottom_nav_bar/bottom_nav_bar.dart';

import '/screens/introduction_screens.dart';
import '/screens/create_or_edit_booking_screen.dart';
import '/screens/create_or_edit_account_screen.dart';
import '/screens/create_or_edit_categorie_screen.dart';
import '/screens/categories_screen.dart';
import '/screens/account_details_screen.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Color(0xFF171717),
  ));
  await Hive.initFlutter();
  Hive.registerAdapter(BookingAdapter());
  Hive.registerAdapter(AccountAdapter());
  Hive.registerAdapter(CategorieAdapter());
  Hive.registerAdapter(TransactionTypeAdapter());
  Hive.registerAdapter(BookingRepeatsAdapter());
  runApp(const BudgetBookApp());
}

class BudgetBookApp extends StatelessWidget {
  const BudgetBookApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'Haushaltsbuch',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xff112025),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xff112025),
        ),
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('de', 'DE'),
      ],
      home: const IntroductionScreens(),
      routes: {
        categoriesRoute: (context) => const CategoriesScreen(),
      },
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case bottomNavBarRoute:
            final args = settings.arguments as BottomNavBarScreenArguments;
            return MaterialPageRoute<String>(
              builder: (BuildContext context) => BottomNavBar(
                screenIndex: args.screenIndex,
              ),
              settings: settings,
            );
          case accountDetailsRoute:
            final args = settings.arguments as AccountDetailsScreenArguments;
            return MaterialPageRoute<String>(
              builder: (BuildContext context) => AccountDetailsScreen(
                account: args.account,
              ),
              settings: settings,
            );
          case createOrEditBookingRoute:
            final args = settings.arguments as CreateOrEditBookingScreenArguments;
            return MaterialPageRoute<String>(
              builder: (BuildContext context) => CreateOrEditBookingScreen(
                bookingBoxIndex: args.bookingBoxIndex,
              ),
              settings: settings,
            );
          case createOrEditAccountRoute:
            final args = settings.arguments as CreateOrEditAccountScreenArguments;
            return MaterialPageRoute<String>(
              builder: (BuildContext context) => CreateOrEditAccountScreen(
                accountBoxIndex: args.accountBoxIndex,
              ),
              settings: settings,
            );
          case createOrEditCategorieRoute:
            final args = settings.arguments as CreateOrEditCategorieScreenArguments;
            return MaterialPageRoute<String>(
              builder: (BuildContext context) => CreateOrEditCategorieScreen(
                categorieName: args.categorieName,
                categorieType: args.categorieType,
              ),
              settings: settings,
            );
        }
        return null;
      },
    );
  }
}
