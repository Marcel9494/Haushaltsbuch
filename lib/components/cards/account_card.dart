import 'package:flutter/material.dart';

import '/models/account.dart';

class AccountCard extends StatelessWidget {
  final Account account;

  const AccountCard({
    Key? key,
    required this.account,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0x0fffffff),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14.0),
      ),
      child: ClipPath(
        clipper: ShapeBorderClipper(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
        ),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(left: BorderSide(color: Colors.cyanAccent, width: 5)),
          ),
          child: Column(
            children: [
              Text(account.name),
              Text(account.accountType),
              Text(account.bankBalance),
            ],
          ),
        ),
      ),
    );
  }
}
