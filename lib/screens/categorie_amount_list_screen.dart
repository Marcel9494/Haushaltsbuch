import 'package:flutter/material.dart';

import '/components/tab_views/monthly_booking_tab_view.dart';

class CategorieAmountListScreen extends StatefulWidget {
  final DateTime selectedDate;

  const CategorieAmountListScreen({
    Key? key,
    required this.selectedDate,
  }) : super(key: key);

  @override
  State<CategorieAmountListScreen> createState() => _CategorieAmountListScreenState();
}

class _CategorieAmountListScreenState extends State<CategorieAmountListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Monatliche Buchungen')),
      body: Column(
        children: [
          MonthlyBookingTabView(
            selectedDate: DateTime(2023, 1, 1),
          ),
        ],
      ),
    );
  }
}
