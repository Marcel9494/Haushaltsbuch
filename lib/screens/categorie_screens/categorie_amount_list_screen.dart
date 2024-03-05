import 'package:flutter/material.dart';

import '/components/tab_views/monthly_booking_tab_view.dart';

class CategorieAmountListScreen extends StatefulWidget {
  final DateTime selectedDate;
  final String categorie;
  final String transactionType;

  const CategorieAmountListScreen({
    Key? key,
    required this.selectedDate,
    required this.categorie,
    required this.transactionType,
  }) : super(key: key);

  @override
  State<CategorieAmountListScreen> createState() => _CategorieAmountListScreenState();
}

class _CategorieAmountListScreenState extends State<CategorieAmountListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.categorie + ' - ' + widget.transactionType, overflow: TextOverflow.ellipsis)),
      body: Column(
        children: [
          Expanded(
            child: MonthlyBookingTabView(
              selectedDate: widget.selectedDate,
              categorie: widget.categorie,
              account: '',
              transactionType: widget.transactionType,
              showOverviewTile: false,
              showBarChart: true,
            ),
          ),
        ],
      ),
    );
  }
}
