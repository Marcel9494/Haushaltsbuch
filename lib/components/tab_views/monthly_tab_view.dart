import 'package:flutter/material.dart';

class MonthlyTabView extends StatefulWidget {
  const MonthlyTabView({Key? key}) : super(key: key);

  @override
  State<MonthlyTabView> createState() => _MonthlyTabViewState();
}

class _MonthlyTabViewState extends State<MonthlyTabView> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Monatlich'),
    );
  }
}
