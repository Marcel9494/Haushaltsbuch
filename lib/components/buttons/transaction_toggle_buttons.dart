import 'package:flutter/material.dart';

import '/models/enums/transaction_types.dart';

class TransactionToggleButtons extends StatelessWidget {
  final dynamic cubit;

  const TransactionToggleButtons({
    Key? key,
    required this.cubit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      onPressed: (selectedIndex) => cubit.setSelectedTransaction(selectedIndex, cubit.state.selectedTransaction, context),
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
      isSelected: cubit.state.selectedTransaction,
      children: [
        SizedBox(
          width: (MediaQuery.of(context).size.width - 37.0) / 4,
          child: Text(
            TransactionType.income.name,
            style: const TextStyle(fontSize: 12.0),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          width: (MediaQuery.of(context).size.width - 37.0) / 4,
          child: Text(
            TransactionType.outcome.name,
            style: const TextStyle(fontSize: 12.0),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          width: (MediaQuery.of(context).size.width - 37.0) / 4,
          child: Text(
            TransactionType.transfer.name,
            style: const TextStyle(fontSize: 12.0),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          width: (MediaQuery.of(context).size.width - 37.0) / 4,
          child: Text(
            TransactionType.investment.name,
            style: const TextStyle(fontSize: 12.0),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
