import 'package:flutter/material.dart';

import '/models/enums/categorie_types.dart';

class CategorieTypeToggleButtons extends StatelessWidget {
  final dynamic cubit;

  const CategorieTypeToggleButtons({
    Key? key,
    required this.cubit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      onPressed: (selectedIndex) => cubit.setSelectedCategorieType(selectedIndex, cubit.state.selectedCategorieType, context),
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(18.0),
        topLeft: Radius.circular(18.0),
        bottomRight: Radius.circular(2.0),
        bottomLeft: Radius.circular(2.0),
      ),
      selectedBorderColor: cubit.state.borderColor,
      fillColor: cubit.state.fillColor,
      selectedColor: Colors.white,
      color: Colors.white60,
      constraints: const BoxConstraints(
        minHeight: 45.0,
        minWidth: 108.0,
      ),
      isSelected: cubit.state.selectedCategorieType,
      children: [
        Text(CategorieType.income.name, style: const TextStyle(fontSize: 12.0)),
        Text(CategorieType.outcome.name, style: const TextStyle(fontSize: 12.0)),
        Text(CategorieType.investment.name, style: const TextStyle(fontSize: 12.0)),
      ],
    );
  }
}
