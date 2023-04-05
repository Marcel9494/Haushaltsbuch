import 'package:flutter/material.dart';

import '../../models/categorie_stats.dart';

class YearlyStatisticsTabView extends StatefulWidget {
  final DateTime selectedDate;

  const YearlyStatisticsTabView({
    Key? key,
    required this.selectedDate,
  }) : super(key: key);

  @override
  State<YearlyStatisticsTabView> createState() => _YearlyStatisticsTabViewState();
}

class _YearlyStatisticsTabViewState extends State<YearlyStatisticsTabView> {
  List<CategorieStats> _categorieStats = [];

  Future<List<CategorieStats>> _loadYearlyExpendituresStatistic() async {
    return _categorieStats;
  }

  @override
  Widget build(BuildContext context) {
    return const Text('TODO');
  }
}
