import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

import '/utils/consts/route_consts.dart';

import '/models/booking.dart';
import 'models/enums/booking_repeats.dart';
import 'models/enums/transaction_types.dart';

import '/components/bottom_nav_bar/bottom_nav_bar.dart';

import '/screens/create_or_edit_booking_screen.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Color(0xFF171717),
  ));
  await Hive.initFlutter();
  Hive.registerAdapter(BookingAdapter());
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
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('de', 'DE'),
      ],
      home: const BottomNavBar(),
      routes: {
        bottomNavBarRoute: (context) => const BottomNavBar(),
        createOrEditBookingRoute: (context) => const CreateOrEditBookingScreen(),
      },
    );
  }
}
