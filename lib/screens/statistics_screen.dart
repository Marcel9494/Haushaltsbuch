import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../components/deco/bottom_sheet_line.dart';
import 'asset_development_statistic_screen.dart';
import 'asset_allocation_statistic_screen.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  List<bool> _selectedStatisticTabOption = [true, false];

  void _setSelectedStatisticTab(int selectedStatisticIndex) {
    setState(() {
      for (int i = 0; i < _selectedStatisticTabOption.length; i++) {
        _selectedStatisticTabOption[i] = i == selectedStatisticIndex;
      }
      if (_selectedStatisticTabOption[0]) {
        _selectedStatisticTabOption = [true, false];
      } else if (_selectedStatisticTabOption[1]) {
        _selectedStatisticTabOption = [false, true];
      } else {
        _selectedStatisticTabOption = [true, false];
      }
    });
    Navigator.pop(context);
  }

  void _openStatisticBottomSheetMenu(BuildContext context) {
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
                child: Text('Statistik auswählen:', style: TextStyle(fontSize: 18.0)),
              ),
              Column(
                children: [
                  ListTile(
                    onTap: () => _setSelectedStatisticTab(0),
                    leading: const Icon(Icons.show_chart_rounded, color: Colors.cyanAccent),
                    title: const Text('Vermögensentwicklung'),
                  ),
                  ListTile(
                    onTap: () => _setSelectedStatisticTab(1),
                    leading: const Icon(Icons.pie_chart_rounded, color: Colors.cyanAccent),
                    title: const Text('Vermögensaufteilung'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_selectedStatisticTabOption[0] ? 'Vermögensentwicklung' : 'Vermögensaufteilung'),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: IconButton(
                onPressed: () => _openStatisticBottomSheetMenu(context),
                icon: Icon(_selectedStatisticTabOption[0] ? Icons.show_chart_rounded : Icons.pie_chart_rounded),
              ),
            ),
          ],
        ),
        body: _selectedStatisticTabOption[0] ? const AssetDevelopmentStatisticScreen() : const AssetAllocationStatisticScreen());
  }
}
