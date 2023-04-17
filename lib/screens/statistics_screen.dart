import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../components/deco/bottom_sheet_line.dart';
import '../models/enums/statistic_types.dart';

import '../components/tab_views/asset_development_statistic_tab_view.dart';
import '../components/tab_views/asset_allocation_statistic_tab_view.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  List<bool> _selectedStatisticTabOption = [true, false];
  StatisticType? _selectedStatistic;

  void _setSelectedStatisticTab(StatisticType selectedStatisticType) {
    setState(() {
      if (selectedStatisticType.name == StatisticType.assetDevelopment.name) {
        _selectedStatisticTabOption = [true, false];
      } else if (selectedStatisticType.name == StatisticType.assetAllocation.name) {
        _selectedStatisticTabOption = [false, true];
      } else {
        _selectedStatisticTabOption = [true, false];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_selectedStatisticTabOption[0] ? StatisticType.assetDevelopment.name : StatisticType.assetAllocation.name),
          actions: [
            Center(
              child: PopupMenuButton<StatisticType>(
                initialValue: _selectedStatistic,
                onSelected: (StatisticType item) {
                  setState(() {
                    _selectedStatistic = item;
                    _setSelectedStatisticTab(item);
                  });
                },
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(12.0),
                  ),
                ),
                itemBuilder: (BuildContext context) => <PopupMenuEntry<StatisticType>>[
                  PopupMenuItem<StatisticType>(
                    value: StatisticType.assetDevelopment,
                    padding: EdgeInsets.zero,
                    child: ListTile(
                      leading: const Icon(Icons.show_chart_rounded),
                      horizontalTitleGap: 0.0,
                      visualDensity: const VisualDensity(horizontal: 0.0, vertical: -4.0),
                      title: Text(
                        StatisticType.assetDevelopment.name,
                        style: const TextStyle(fontSize: 14.0),
                      ),
                    ),
                  ),
                  PopupMenuItem<StatisticType>(
                    value: StatisticType.assetAllocation,
                    padding: EdgeInsets.zero,
                    child: ListTile(
                      leading: const Icon(Icons.pie_chart_rounded),
                      horizontalTitleGap: 0.0,
                      visualDensity: const VisualDensity(horizontal: 0.0, vertical: -4.0),
                      title: Text(
                        StatisticType.assetAllocation.name,
                        style: const TextStyle(fontSize: 14.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        body: _selectedStatisticTabOption[0] ? const AssetDevelopmentStatisticTabView() : const AssetAllocationStatisticTabView());
  }
}
