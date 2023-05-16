import 'package:flutter/material.dart';

import '/models/enums/categorie_types.dart';

typedef SelectedCategorieTypeCallback = void Function(String categorieType);

class TransactionStatsButton extends StatelessWidget {
  String categorieType;
  final SelectedCategorieTypeCallback selectedCategorieTypeCallback;

  TransactionStatsButton({
    Key? key,
    required this.categorieType,
    required this.selectedCategorieTypeCallback,
  }) : super(key: key);

  void _changeCategorieType() {
    if (categorieType == CategorieType.outcome.pluralName) {
      categorieType = CategorieType.income.pluralName;
    } else if (categorieType == CategorieType.income.pluralName) {
      categorieType = CategorieType.investment.pluralName;
    } else if (categorieType == CategorieType.investment.pluralName) {
      categorieType = CategorieType.outcome.pluralName;
    }
    selectedCategorieTypeCallback(categorieType);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0),
      child: OutlinedButton(
        onPressed: () => _changeCategorieType(),
        child: Text(
          categorieType,
          style: const TextStyle(color: Colors.cyanAccent),
        ),
      ),
    );
  }
}
