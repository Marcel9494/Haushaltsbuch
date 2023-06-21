import 'package:flutter/material.dart';

import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../components/tab_views/asset_future_development_statistic_tab_view.dart';
import '../models/booking.dart';
import '/components/tab_views/asset_development_statistic_tab_view.dart';
import '/components/tab_views/asset_allocation_statistic_tab_view.dart';
import '/components/tab_views/account_overview_tab_view.dart';
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
  double _assetValues = 0.0;
  double _liabilityValues = 0.0;
  List<bool> _selectedTabOption = [true, false, false, false];

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
                    title: const Text('Kategorien verwalten'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _getAssetAndLiabilityValues() async {
    _assetValues = await Account.getAssetValue();
    _liabilityValues = await Account.getLiabilityValue();
  }

  void _setSelectedTab(int selectedIndex) {
    setState(() {
      for (int i = 0; i < _selectedTabOption.length; i++) {
        _selectedTabOption[i] = i == selectedIndex;
      }
      if (_selectedTabOption[0]) {
        _selectedTabOption = [true, false, false, false];
      } else if (_selectedTabOption[1]) {
        _selectedTabOption = [false, true, false, false];
      } else if (_selectedTabOption[2]) {
        _selectedTabOption = [false, false, true, false];
      } else if (_selectedTabOption[3]) {
        _selectedTabOption = [false, false, false, true];
      } else {
        _selectedTabOption = [true, false, false, false];
      }
    });
  }

  Widget _showSelectedTabView() {
    Booking.checkForNewSerieBookings();
    if (_selectedTabOption[0]) {
      return const AccountOverviewTabView();
    } else if (_selectedTabOption[1]) {
      return const AssetDevelopmentStatisticTabView();
    } else if (_selectedTabOption[2]) {
      return const AssetFutureDevelopmentStatisticTabView();
    } else if (_selectedTabOption[3]) {
      return const AssetAllocationStatisticTabView();
    } else {
      return const AccountOverviewTabView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Konten'),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, settingsRoute),
            icon: const Icon(Icons.settings_rounded),
          ),
          IconButton(
            onPressed: () => _openBottomSheetMenu(context),
            icon: const Icon(Icons.more_vert_rounded),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 74.0,
              child: FutureBuilder(
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
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 16.0, left: 16.0),
                  child: ToggleButtons(
                    onPressed: (selectedIndex) => _setSelectedTab(selectedIndex),
                    borderRadius: BorderRadius.circular(6.0),
                    selectedBorderColor: Colors.cyanAccent,
                    fillColor: Colors.cyanAccent.shade700,
                    selectedColor: Colors.white,
                    color: Colors.white60,
                    constraints: const BoxConstraints(
                      minHeight: 30.0,
                      minWidth: 50.0,
                    ),
                    isSelected: _selectedTabOption,
                    children: const [
                      Icon(Icons.account_balance_wallet_rounded, size: 20.0),
                      Icon(Icons.show_chart_rounded, size: 20.0),
                      Icon(Icons.auto_graph_rounded, size: 20.0),
                      Icon(Icons.pie_chart_rounded, size: 20.0),
                    ],
                  ),
                ),
              ],
            ),
            _showSelectedTabView(),
          ],
        ),
      ),
    );
  }
}
