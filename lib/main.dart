import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';

import '/utils/consts/route_consts.dart';

import '/components/bottom_nav_bar/bottom_nav_bar.dart';

import '/screens/create_or_edit_booking_screen.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Color(0xFF171717),
  ));
  initializeDateFormatting().then((_) => runApp(const BudgetBookApp()));
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
      home: const BottomNavBar(),
      routes: {
        createOrEditBookingRoute: (context) => const CreateOrEditBookingScreen(),
      },
    );
  }
}
