import 'package:flutter/material.dart';

class DailyStatisticsTabView extends StatefulWidget {
  const DailyStatisticsTabView({Key? key}) : super(key: key);

  @override
  State<DailyStatisticsTabView> createState() => _DailyStatisticsTabViewState();
}

class _DailyStatisticsTabViewState extends State<DailyStatisticsTabView> {
  @override
  Widget build(BuildContext context) {
    return const Text('Tägliche Statistiken');
  }
}
