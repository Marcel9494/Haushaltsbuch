import 'package:flutter/material.dart';

import '/components/tab_views/monthly_booking_tab_view.dart';

class CategorieAmountListScreen extends StatefulWidget {
  final DateTime selectedDate;
  final String categorie;

  const CategorieAmountListScreen({
    Key? key,
    required this.selectedDate,
    required this.categorie,
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
            selectedDate: widget.selectedDate,
            categorie: widget.categorie,
            account: '',
          ),
        ],
      ),
    );
  }
}
