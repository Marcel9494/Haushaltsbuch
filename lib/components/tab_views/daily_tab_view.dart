import 'package:flutter/material.dart';

class DailyTabView extends StatefulWidget {
  const DailyTabView({Key? key}) : super(key: key);

  @override
  State<DailyTabView> createState() => _DailyTabViewState();
}

class _DailyTabViewState extends State<DailyTabView> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Täglich'),
    );
  }
}
