import 'package:flutter/material.dart';
import 'package:haushaltsbuch/components/deco/overview_tile.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '/components/cards/account_card.dart';
import '/components/deco/bottom_sheet_line.dart';

import '/utils/consts/route_consts.dart';

import '/models/account.dart';

class AccountsScreen extends StatefulWidget {
  const AccountsScreen({Key? key}) : super(key: key);

  @override
  State<AccountsScreen> createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
  late List<Account> accountList = [];

  void _openBottomSheetMenu(BuildContext context) {
    showCupertinoModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Material(
          child: ListView(
            shrinkWrap: true,
            children: [
              const BottomSheetLine(),
              const Padding(
                padding: EdgeInsets.only(top: 16.0, left: 20.0),
                child: Text('Auswählen:', style: TextStyle(fontSize: 18.0)),
              ),
              Column(
                children: [
                  ListTile(
                    onTap: () => Navigator.popAndPushNamed(context, createOrEditAccountRoute),
                    leading: const Icon(Icons.add_circle_outline_rounded, color: Colors.cyanAccent),
                    title: const Text('Konto erstellen'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<List<Account>> loadAccountList() async {
    accountList = await Account.loadAccount();
    return accountList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Konten'),
        actions: [
          IconButton(
            onPressed: () => _openBottomSheetMenu(context),
            icon: const Icon(Icons.more_vert_rounded),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            const OverviewTile(shouldText: 'Vermögen', should: 100000, haveText: 'Schulden', have: 50000, balanceText: 'Saldo'),
            FutureBuilder(
              future: loadAccountList(),
              builder: (BuildContext context, AsyncSnapshot<List<Account>> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const Text('Warten');
                  case ConnectionState.done:
                    if (accountList.isEmpty) {
                      return const Text('Noch keine Konten vorhanden.');
                    } else {
                      return Expanded(
                        child: RefreshIndicator(
                          onRefresh: () async {
                            accountList = await loadAccountList();
                            setState(() {});
                            return;
                          },
                          color: Colors.cyanAccent,
                          child: ListView.builder(
                            itemCount: accountList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return AccountCard(account: accountList[index]);
                            },
                          ),
                        ),
                      );
                    }
                  default:
                    return const Text('Warten');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
