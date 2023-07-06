import 'package:flutter/material.dart';
import 'package:haushaltsbuch/components/tab_views/yearly_statistics_tab_view.dart';

import '/models/enums/transaction_types.dart';

import '/components/tab_views/monthly_statistics_tab_view.dart';

class TransactionStatsToggleButtons extends StatefulWidget {
  final String currentTransaction;
  final bool monthlyStatistics;

  const TransactionStatsToggleButtons({
    Key? key,
    required this.currentTransaction,
    required this.monthlyStatistics,
  }) : super(key: key);

  @override
  State<TransactionStatsToggleButtons> createState() => _TransactionStatsToggleButtonsState();
}

class _TransactionStatsToggleButtonsState extends State<TransactionStatsToggleButtons> {
  late List<bool> _selectedTransaction = [];

  @override
  void initState() {
    super.initState();
    _getSelectedTransaction();
  }

  void _getSelectedTransaction() {
    if (widget.currentTransaction == TransactionType.outcome.pluralName) {
      _selectedTransaction = <bool>[true, false, false];
    } else if (widget.currentTransaction == TransactionType.income.pluralName) {
      _selectedTransaction = <bool>[false, true, false];
    } else if (widget.currentTransaction == TransactionType.investment.pluralName) {
      _selectedTransaction = <bool>[false, false, true];
    }
  }

  void _setSelectedTransaction(int selectedIndex) {
    setState(() {
      for (int i = 0; i < _selectedTransaction.length; i++) {
        _selectedTransaction[i] = i == selectedIndex;
      }
      if (_selectedTransaction[0]) {
        if (widget.monthlyStatistics) {
          MonthlyStatisticsTabView.of(context)!.currentCategorieType = TransactionType.outcome.pluralName;
        } else {
          YearlyStatisticsTabView.of(context)!.currentCategorieType = TransactionType.outcome.pluralName;
        }
      } else if (_selectedTransaction[1]) {
        if (widget.monthlyStatistics) {
          MonthlyStatisticsTabView.of(context)!.currentCategorieType = TransactionType.income.pluralName;
        } else {
          YearlyStatisticsTabView.of(context)!.currentCategorieType = TransactionType.income.pluralName;
        }
      } else if (_selectedTransaction[2]) {
        if (widget.monthlyStatistics) {
          MonthlyStatisticsTabView.of(context)!.currentCategorieType = TransactionType.investment.pluralName;
        } else {
          YearlyStatisticsTabView.of(context)!.currentCategorieType = TransactionType.investment.pluralName;
        }
      } else {
        if (widget.monthlyStatistics) {
          MonthlyStatisticsTabView.of(context)!.currentCategorieType = '';
        } else {
          YearlyStatisticsTabView.of(context)!.currentCategorieType = '';
        }
      }
    });
  }

  Color _getSelectedBorderColor() {
    if (_selectedTransaction[0]) {
      return Colors.redAccent;
    } else if (_selectedTransaction[1]) {
      return Colors.greenAccent;
    } else if (_selectedTransaction[2]) {
      return Colors.cyanAccent;
    }
    return Colors.white54;
  }

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      onPressed: (selectedIndex) => _setSelectedTransaction(selectedIndex),
      selectedBorderColor: _getSelectedBorderColor(),
      selectedColor: Colors.white,
      color: Colors.white60,
      fillColor: Colors.transparent,
      borderColor: Colors.transparent,
      borderWidth: 0.75,
      constraints: BoxConstraints(
        minHeight: 34.0,
        minWidth: (MediaQuery.of(context).size.width / 3) - 8.0,
      ),
      isSelected: _selectedTransaction,
      children: [
        Text(TransactionType.outcome.pluralName, style: const TextStyle(fontSize: 12.0)),
        Text(TransactionType.income.pluralName, style: const TextStyle(fontSize: 12.0)),
        Text(TransactionType.investment.pluralName, style: const TextStyle(fontSize: 12.0)),
      ],
    );
  }
}
