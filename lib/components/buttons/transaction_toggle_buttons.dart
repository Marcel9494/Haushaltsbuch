import 'package:flutter/material.dart';

enum TransactionType { income, outcome, transfer }

class TransactionToggleButtons extends StatefulWidget {
  const TransactionToggleButtons({Key? key}) : super(key: key);

  @override
  State<TransactionToggleButtons> createState() => _TransactionToggleButtonsState();
}

class _TransactionToggleButtonsState extends State<TransactionToggleButtons> {
  final List<bool> _selectedTransaction = <bool>[false, true, false];

  void _setSelectedTransaction(int index) {
    setState(() {
      for (int i = 0; i < _selectedTransaction.length; i++) {
        _selectedTransaction[i] = i == index;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      onPressed: (index) => _setSelectedTransaction(index),
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(18.0),
        topLeft: Radius.circular(18.0),
        bottomRight: Radius.circular(2.0),
        bottomLeft: Radius.circular(2.0),
      ),
      selectedBorderColor: Colors.cyanAccent.shade700,
      selectedColor: Colors.black87,
      fillColor: Colors.cyanAccent.shade700,
      color: Colors.white60,
      constraints: const BoxConstraints(
        minHeight: 40.0,
        minWidth: 107.5,
      ),
      isSelected: _selectedTransaction,
      children: const [
        Text('Einnahme'),
        Text('Ausgabe'),
        Text('Übertrag'),
      ],
    );
  }
}
