import 'package:flutter/material.dart';

import '/screens/create_or_edit_booking_screen.dart';

import '/models/enums/transaction_types.dart';

typedef TransactionStringCallback = void Function(String currentTransaction);

class TransactionToggleButtons extends StatefulWidget {
  final String currentTransaction;
  final TransactionStringCallback transactionStringCallback;

  const TransactionToggleButtons({
    Key? key,
    required this.currentTransaction,
    required this.transactionStringCallback,
  }) : super(key: key);

  @override
  State<TransactionToggleButtons> createState() => _TransactionToggleButtonsState();
}

class _TransactionToggleButtonsState extends State<TransactionToggleButtons> {
  late List<bool> _selectedTransaction = [];

  @override
  void initState() {
    super.initState();
    _getSelectedTransaction();
  }

  void _getSelectedTransaction() {
    if (widget.currentTransaction == TransactionType.income.name) {
      _selectedTransaction = <bool>[true, false, false, false];
    } else if (widget.currentTransaction == TransactionType.outcome.name) {
      _selectedTransaction = <bool>[false, true, false, false];
    } else if (widget.currentTransaction == TransactionType.transfer.name) {
      _selectedTransaction = <bool>[false, false, true, false];
    } else if (widget.currentTransaction == TransactionType.investment.name) {
      _selectedTransaction = <bool>[false, false, false, true];
    }
  }

  void _setSelectedTransaction(int selectedIndex) {
    setState(() {
      for (int i = 0; i < _selectedTransaction.length; i++) {
        _selectedTransaction[i] = i == selectedIndex;
      }
      if (_selectedTransaction[0]) {
        CreateOrEditBookingScreen.of(context)!.currentTransaction = TransactionType.income.name;
      } else if (_selectedTransaction[1]) {
        CreateOrEditBookingScreen.of(context)!.currentTransaction = TransactionType.outcome.name;
      } else if (_selectedTransaction[2]) {
        CreateOrEditBookingScreen.of(context)!.currentTransaction = TransactionType.transfer.name;
      } else if (_selectedTransaction[3]) {
        CreateOrEditBookingScreen.of(context)!.currentTransaction = TransactionType.investment.name;
      } else {
        CreateOrEditBookingScreen.of(context)!.currentTransaction = '';
      }
    });
  }

  Color _getSelectedBorderColor() {
    if (_selectedTransaction[0]) {
      return Colors.greenAccent;
    } else if (_selectedTransaction[1]) {
      return Colors.redAccent;
    } else if (_selectedTransaction[2]) {
      return Colors.cyanAccent;
    } else if (_selectedTransaction[3]) {
      return Colors.cyanAccent;
    }
    return Colors.white54;
  }

  Color _getFillColor() {
    if (_selectedTransaction[0]) {
      return Colors.greenAccent.withOpacity(0.2);
    } else if (_selectedTransaction[1]) {
      return Colors.redAccent.withOpacity(0.2);
    } else if (_selectedTransaction[2]) {
      return Colors.cyanAccent.withOpacity(0.2);
    } else if (_selectedTransaction[3]) {
      return Colors.cyanAccent.withOpacity(0.2);
    }
    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      onPressed: (selectedIndex) => _setSelectedTransaction(selectedIndex),
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(18.0),
        topLeft: Radius.circular(18.0),
        bottomRight: Radius.circular(2.0),
        bottomLeft: Radius.circular(2.0),
      ),
      selectedBorderColor: _getSelectedBorderColor(),
      fillColor: _getFillColor(),
      selectedColor: Colors.white,
      color: Colors.white60,
      constraints: const BoxConstraints(
        minHeight: 45.0,
        minWidth: 80.0,
      ),
      isSelected: _selectedTransaction,
      children: [
        Text(TransactionType.income.name, style: const TextStyle(fontSize: 12.0)),
        Text(TransactionType.outcome.name, style: const TextStyle(fontSize: 12.0)),
        Text(TransactionType.transfer.name, style: const TextStyle(fontSize: 12.0)),
        Text(TransactionType.investment.name, style: const TextStyle(fontSize: 12.0)),
      ],
    );
  }
}
