import 'package:flutter/material.dart';

import '../../models/enums/categorie_types.dart';
import '../../screens/create_or_edit_categorie_screen.dart';

typedef CategorieTypeStringCallback = void Function(String currentCategorieType);

class CategorieTypeToggleButtons extends StatefulWidget {
  final String currentCategorieType;
  final CategorieTypeStringCallback categorieTypeStringCallback;

  const CategorieTypeToggleButtons({
    Key? key,
    required this.currentCategorieType,
    required this.categorieTypeStringCallback,
  }) : super(key: key);

  @override
  State<CategorieTypeToggleButtons> createState() => _CategorieTypeToggleButtonsState();
}

class _CategorieTypeToggleButtonsState extends State<CategorieTypeToggleButtons> {
  late List<bool> _selectedCategorieType = [];

  @override
  void initState() {
    super.initState();
    _getSelectedCategorieType();
  }

  void _getSelectedCategorieType() {
    if (widget.currentCategorieType == CategorieType.income.name) {
      _selectedCategorieType = <bool>[true, false];
    } else if (widget.currentCategorieType == CategorieType.outcome.name) {
      _selectedCategorieType = <bool>[false, true];
    }
  }

  void _setSelectedTransaction(int selectedIndex) {
    setState(() {
      for (int i = 0; i < _selectedCategorieType.length; i++) {
        _selectedCategorieType[i] = i == selectedIndex;
      }
      if (_selectedCategorieType[0]) {
        CreateOrEditCategorieScreen.of(context)!.currentCategorieType = CategorieType.income.name;
      } else if (_selectedCategorieType[1]) {
        CreateOrEditCategorieScreen.of(context)!.currentCategorieType = CategorieType.outcome.name;
      } else {
        CreateOrEditCategorieScreen.of(context)!.currentCategorieType = '';
      }
    });
  }

  Color _getSelectedBorderColor() {
    if (_selectedCategorieType[0]) {
      return Colors.greenAccent;
    } else if (_selectedCategorieType[1]) {
      return Colors.redAccent;
    }
    return Colors.white54;
  }

  Color _getFillColor() {
    if (_selectedCategorieType[0]) {
      return Colors.greenAccent.withOpacity(0.2);
    } else if (_selectedCategorieType[1]) {
      return Colors.redAccent.withOpacity(0.2);
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
        minWidth: 162.0,
      ),
      isSelected: _selectedCategorieType,
      children: [
        Text(CategorieType.income.name),
        Text(CategorieType.outcome.name),
      ],
    );
  }
}
