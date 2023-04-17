import 'package:flutter/material.dart';

import '../../models/account.dart';
import '../cards/account_card.dart';
import '../deco/loading_indicator.dart';

class AccountOverviewTabView extends StatefulWidget {
  const AccountOverviewTabView({Key? key}) : super(key: key);

  @override
  State<AccountOverviewTabView> createState() => _AccountOverviewTabViewState();
}

class _AccountOverviewTabViewState extends State<AccountOverviewTabView> {
  List<Account> _accountList = [];

  Future<List<Account>> _loadAccountList() async {
    _accountList = await Account.loadAccounts();
    return _accountList;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadAccountList(),
      builder: (BuildContext context, AsyncSnapshot<List<Account>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const LoadingIndicator();
          case ConnectionState.done:
            if (_accountList.isEmpty) {
              return const Expanded(
                child: Center(
                  child: Text('Noch keine Konten erstellt.'),
                ),
              );
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
    );
  }
}
