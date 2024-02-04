import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '/utils/consts/route_consts.dart';

import 'models/account/account_model.dart';
import 'models/booking/booking_model.dart';
import 'models/budget/budget_model.dart';
import 'models/categorie/categorie_model.dart';
import 'models/default_budget/default_budget_model.dart';
import 'models/enums/transaction_types.dart';
import 'models/global_state/global_state_model.dart';
import 'models/intro_screen_state/intro_screen_state_model.dart';
import 'models/intro_screen_state/intro_screen_state_repository.dart';
import 'models/primary_account/primary_account_model.dart';
import 'models/subbudget/subbudget_model.dart';
import 'models/screen_arguments/bottom_nav_bar_screen_arguments.dart';
import 'models/screen_arguments/account_details_screen_arguments.dart';
import 'models/screen_arguments/categorie_amount_list_screen_arguments.dart';

import 'blocs/budget_bloc/budget_bloc.dart';
import 'blocs/booking_bloc/booking_bloc.dart';
import 'blocs/account_bloc/account_bloc.dart';
import 'blocs/categorie_bloc/categorie_bloc.dart';
import 'blocs/subbudget_bloc/subbudget_bloc.dart';
import 'blocs/primary_account_bloc/primary_account_bloc.dart';
import 'blocs/input_field_blocs/text_input_field_bloc/text_input_field_cubit.dart';
import 'blocs/input_field_blocs/money_input_field_bloc/money_input_field_cubit.dart';
import 'blocs/input_field_blocs/account_input_field_bloc/from_account_input_field_cubit.dart';
import 'blocs/input_field_blocs/categorie_input_field_bloc/categorie_input_field_cubit.dart';
import 'blocs/input_field_blocs/subcategorie_input_field_bloc/subcategorie_input_field_cubit.dart';
import 'blocs/button_blocs/categorie_type_toggle_buttons_bloc/categorie_type_toggle_buttons_cubit.dart';
import 'blocs/button_blocs/transaction_stats_toggle_buttons_bloc/transaction_stats_toggle_buttons_cubit.dart';
import 'blocs/input_field_blocs/date_input_field_bloc/date_input_field_cubit.dart';
import 'blocs/input_field_blocs/account_type_input_field_bloc/account_type_input_field_cubit.dart';
import 'blocs/input_field_blocs/account_input_field_bloc/to_account_input_field_cubit.dart';
import 'blocs/input_field_blocs/preselect_account_input_field_bloc/preselect_account_input_field_cubit.dart';

import '/components/bottom_nav_bar/bottom_nav_bar.dart';

import 'screens/budget_screens/edit_subbudget_screen.dart';
import 'screens/budget_screens/edit_budget_screen.dart';
import 'screens/budget_screens/overview_all_budgets_screen.dart';
import 'screens/booking_screens/create_or_edit_booking_screen.dart';
import 'screens/account_screens/create_or_edit_account_screen.dart';
import 'screens/categorie_screens/create_or_edit_categorie_screen.dart';
import 'screens/categorie_screens/create_or_edit_subcategorie_screen.dart';
import 'screens/categorie_screens/categories_screen.dart';
import 'screens/account_screens/account_details_screen.dart';
import 'screens/budget_screens/create_budget_screen.dart';
import 'screens/categorie_screens/categorie_amount_list_screen.dart';
import 'screens/budget_screens/overview_one_budget_screen.dart';
import 'screens/budget_screens/overview_one_subbudget_screen.dart';
import 'screens/other_screens/settings_screen.dart';
import 'screens/other_screens/splash_screen.dart';

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
  IntroScreenStateRepository introScreenStateRepository = IntroScreenStateRepository();
  introScreenStateRepository.init();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<BookingBloc>(
          create: (context) => BookingBloc(),
        ),
        BlocProvider<AccountBloc>(
          create: (context) => AccountBloc(),
        ),
        BlocProvider<BudgetBloc>(
          create: (context) => BudgetBloc(),
        ),
        BlocProvider<SubbudgetBloc>(
          create: (context) => SubbudgetBloc(),
        ),
        BlocProvider<CategorieBloc>(
          create: (context) => CategorieBloc(),
        ),
        BlocProvider<PrimaryAccountBloc>(
          create: (context) => PrimaryAccountBloc(),
        ),
        BlocProvider<TextInputFieldCubit>(
          create: (context) => TextInputFieldCubit(),
        ),
        BlocProvider<MoneyInputFieldCubit>(
          create: (context) => MoneyInputFieldCubit(),
        ),
        BlocProvider<CategorieInputFieldCubit>(
          create: (context) => CategorieInputFieldCubit(),
        ),
        BlocProvider<SubcategorieInputFieldCubit>(
          create: (context) => SubcategorieInputFieldCubit(),
        ),
        BlocProvider<FromAccountInputFieldCubit>(
          create: (context) => FromAccountInputFieldCubit(),
        ),
        BlocProvider<ToAccountInputFieldCubit>(
          create: (context) => ToAccountInputFieldCubit(),
        ),
        BlocProvider<PreselectAccountInputFieldCubit>(
          create: (context) => PreselectAccountInputFieldCubit(),
        ),
        BlocProvider<TransactionStatsToggleButtonsCubit>(
          create: (context) => TransactionStatsToggleButtonsCubit(),
        ),
        BlocProvider<CategorieTypeToggleButtonsCubit>(
          create: (context) => CategorieTypeToggleButtonsCubit(),
        ),
        BlocProvider<DateInputFieldCubit>(
          create: (context) => DateInputFieldCubit(),
        ),
        BlocProvider<AccountTypeInputFieldCubit>(
          create: (context) => AccountTypeInputFieldCubit(),
        ),
      ],
      child: const BudgetBookApp(),
    ),
  );
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
        createOrEditBookingRoute: (context) => const CreateOrEditBookingScreen(),
        overviewOneBudgetRoute: (context) => const OverviewOneBudgetScreen(),
        overviewOneSubbudgetRoute: (context) => const OverviewOneSubbudgetScreen(),
        createBudgetRoute: (context) => const CreateBudgetScreen(),
        editBudgetRoute: (context) => const EditBudgetScreen(),
        editSubbudgetRoute: (context) => const EditSubbudgetScreen(),
        createOrEditAccountRoute: (context) => const CreateOrEditAccountScreen(),
        createOrEditCategorieRoute: (context) => const CreateOrEditCategorieScreen(),
        createOrEditSubcategorieRoute: (context) => const CreateOrEditSubcategorieScreen(),
        categoriesRoute: (context) => const CategoriesScreen(),
        overviewBudgetsRoute: (context) => const OverviewAllBudgetsScreen(),
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
          case categorieAmountListRoute:
            final args = settings.arguments as CategorieAmountListScreenArguments;
            return MaterialPageRoute<String>(
              builder: (BuildContext context) => CategorieAmountListScreen(
                selectedDate: args.selectedDate,
                categorie: args.categorie,
                transactionType: args.transactionType,
              ),
              settings: settings,
            );
        }
        return null;
      },
    );
  }
}
