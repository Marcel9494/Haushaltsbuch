import 'package:flutter/material.dart';

enum TransactionType { income, outcome, transfer }

class TransactionToggleButtons extends StatefulWidget {
  const TransactionToggleButtons({Key? key}) : super(key: key);

  @override
  State<TransactionToggleButtons> createState() => _TransactionToggleButtonsState();
}

class _TransactionToggleButtonsState extends State<TransactionToggleButtons> {
  final List<bool> _selectedTransaction = <bool>[false, true, false];

  void _setSelectedTransaction(int selectedIndex) {
    setState(() {
      for (int i = 0; i < _selectedTransaction.length; i++) {
        _selectedTransaction[i] = i == selectedIndex;
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
