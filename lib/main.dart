import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '/utils/consts/route_consts.dart';

import 'models/account/account_model.dart';
import 'models/booking.dart';
import 'models/categorie.dart';
import 'models/budget.dart';
import 'models/subbudget.dart';
import 'models/default_budget.dart';
import 'models/enums/transaction_types.dart';
import 'models/global_state.dart';
import 'models/intro_screen_state.dart';
import 'models/primary_account.dart';
import 'models/screen_arguments/create_or_edit_subcategorie_screen_arguments.dart';
import 'models/screen_arguments/edit_budget_screen_arguments.dart';
import 'models/screen_arguments/edit_subbudget_screen_arguments.dart';
import 'models/screen_arguments/bottom_nav_bar_screen_arguments.dart';
import 'models/screen_arguments/account_details_screen_arguments.dart';
import 'models/screen_arguments/categorie_amount_list_screen_arguments.dart';
import 'models/screen_arguments/create_or_edit_account_screen_arguments.dart';
import 'models/screen_arguments/create_or_edit_booking_screen_arguments.dart';
import 'models/screen_arguments/create_or_edit_budget_screen_arguments.dart';
import 'models/screen_arguments/create_or_edit_categorie_screen_arguments.dart';

import '/components/bottom_nav_bar/bottom_nav_bar.dart';

import '/screens/overview_budgets_screen.dart';
import '/screens/create_or_edit_booking_screen.dart';
import '/screens/create_or_edit_account_screen.dart';
import '/screens/create_or_edit_categorie_screen.dart';
import '/screens/create_or_edit_subcategorie_screen.dart';
import '/screens/categories_screen.dart';
import '/screens/account_details_screen.dart';
import '/screens/create_or_edit_budget_screen.dart';
import '/screens/categorie_amount_list_screen.dart';
import '/screens/edit_budget_screen.dart';
import '/screens/edit_subbudget_screen.dart';
import '/screens/settings_screen.dart';
import '/screens/splash_screen.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Color(0xFF171717),
  ));
  await Hive.initFlutter();
  Hive.registerAdapter(BookingAdapter());
  Hive.registerAdapter(AccountAdapter());
  Hive.registerAdapter(PrimaryAccountAdapter());
  Hive.registerAdapter(CategorieAdapter());
  Hive.registerAdapter(BudgetAdapter());
  Hive.registerAdapter(SubbudgetAdapter());
  Hive.registerAdapter(DefaultBudgetAdapter());
  Hive.registerAdapter(TransactionTypeAdapter());
  Hive.registerAdapter(GlobalStateAdapter());
  Hive.registerAdapter(IntroScreenStateAdapter());
  IntroScreenState.init();
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
        cardColor: const Color(0xff1c2b30),
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('de', 'DE'),
      ],
      home: const SplashScreen(),
      routes: {
        categoriesRoute: (context) => const CategoriesScreen(),
        overviewBudgetsRoute: (context) => const OverviewBudgetsScreen(),
        settingsRoute: (context) => const SettingsScreen(),
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
                serieEditMode: args.serieEditMode,
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
          case createOrEditSubcategorieRoute:
            final args = settings.arguments as CreateOrEditSubcategorieScreenArguments;
            return MaterialPageRoute<String>(
              builder: (BuildContext context) => CreateOrEditSubcategorieScreen(
                categorie: args.categorie,
                mode: args.mode,
                subcategorieIndex: args.subcategorieIndex,
              ),
              settings: settings,
            );
          case createOrEditBudgetRoute:
            final args = settings.arguments as CreateOrEditBudgetScreenArguments;
            return MaterialPageRoute<String>(
              builder: (BuildContext context) => CreateOrEditBudgetScreen(
                budgetModeType: args.budgetModeType,
                budgetBoxIndex: args.budgetBoxIndex,
                budgetCategorie: args.budgetCategorie,
              ),
              settings: settings,
            );
          case editBudgetRoute:
            final args = settings.arguments as EditBudgetScreenArguments;
            return MaterialPageRoute<String>(
              builder: (BuildContext context) => EditBudgetScreen(
                budget: args.budget,
              ),
              settings: settings,
            );
          case editSubbudgetRoute:
            final args = settings.arguments as EditSubbudgetScreenArguments;
            return MaterialPageRoute<String>(
              builder: (BuildContext context) => EditSubbudgetScreen(
                subbudget: args.subbudget,
              ),
              settings: settings,
            );
          case categorieAmountListRoute:
            final args = settings.arguments as CategorieAmountListScreenArguments;
            return MaterialPageRoute<String>(
              builder: (BuildContext context) => CategorieAmountListScreen(
                selectedDate: args.selectedDate,
                categorie: args.categorie,
              ),
              settings: settings,
            );
        }
        return null;
      },
    );
  }
}
