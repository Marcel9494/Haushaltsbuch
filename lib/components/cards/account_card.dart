import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '/utils/consts/route_consts.dart';

import '/models/account.dart';
import '/models/screen_arguments/account_details_screen_arguments.dart';

class AccountCard extends StatelessWidget {
  final Account account;

  const AccountCard({
    Key? key,
    required this.account,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(context, accountDetailsRoute, arguments: AccountDetailsScreenArguments(account)),
        child: Card(
          color: const Color(0xff1c2b30),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(account.name),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0, bottom: 16.0, right: 16.0),
                    child: Text(account.bankBalance),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
