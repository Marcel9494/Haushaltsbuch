import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '/components/cards/account_card.dart';
import '/components/deco/bottom_sheet_line.dart';
import '/components/deco/loading_indicator.dart';
import '/components/deco/overview_tile.dart';

import '/utils/consts/route_consts.dart';

import '/models/account.dart';
import '/models/screen_arguments/create_or_edit_account_screen_arguments.dart';

class AccountsScreen extends StatefulWidget {
  const AccountsScreen({Key? key}) : super(key: key);

  @override
  State<AccountsScreen> createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
  late List<Account> _accountList = [];
  late double _assetValues = 0.0;
  late double _liabilityValues = 0.0;

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
                    onTap: () => Navigator.popAndPushNamed(context, createOrEditAccountRoute, arguments: CreateOrEditAccountScreenArguments(-1)),
                    leading: const Icon(Icons.add_circle_outline_rounded, color: Colors.cyanAccent),
                    title: const Text('Konto erstellen'),
                  ),
                  ListTile(
                    onTap: () => Navigator.popAndPushNamed(context, categoriesRoute),
                    leading: const Icon(Icons.list_rounded, color: Colors.cyanAccent),
                    title: const Text('Kategorien'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<List<Account>> _loadAccountList() async {
    _accountList = await Account.loadAccounts();
    return _accountList;
  }

  Future<void> _getAssetAndLiabilityValues() async {
    _assetValues = await Account.getAssetValue();
    _liabilityValues = await Account.getLiabilityValue();
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
            FutureBuilder(
              future: _getAssetAndLiabilityValues(),
              builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const LoadingIndicator();
                  case ConnectionState.done:
                    return OverviewTile(shouldText: 'Vermögen', should: _assetValues, haveText: 'Schulden', have: _liabilityValues, balanceText: 'Saldo');
                  default:
                    return const SizedBox();
                }
              },
            ),
            FutureBuilder(
              future: _loadAccountList(),
              builder: (BuildContext context, AsyncSnapshot<List<Account>> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const LoadingIndicator();
                  case ConnectionState.done:
                    if (_accountList.isEmpty) {
                      return const Text('Noch keine Konten erstellt.');
                    } else {
                      return Expanded(
                        child: RefreshIndicator(
                          onRefresh: () async {
                            _accountList = await _loadAccountList();
                            setState(() {});
                            return;
                          },
                          color: Colors.cyanAccent,
                          child: ListView.builder(
                            itemCount: _accountList.length,
                            itemBuilder: (BuildContext context, int index) {
                              if (index == 0 || _accountList[index - 1].accountType != _accountList[index].accountType) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(_accountList[index].accountType, style: const TextStyle(fontSize: 16.0)),
                                    ),
                                    AccountCard(account: _accountList[index]),
                                  ],
                                );
                              } else if (_accountList[index - 1].accountType == _accountList[index].accountType) {
                                return AccountCard(account: _accountList[index]);
                              }
                              return const SizedBox();
                            },
                          ),
                        ),
                      );
                    }
                  default:
                    if (snapshot.hasError) {
                      return const Text('Konten Übersicht konnte nicht geladen werden.');
                    }
                    return const LoadingIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
