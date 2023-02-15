import 'package:flutter/material.dart';

import '/components/calendar/calendar.dart';

class CalendarTabView extends StatefulWidget {
  const CalendarTabView({Key? key}) : super(key: key);

  @override
  State<CalendarTabView> createState() => _CalendarTabViewState();
}

class _CalendarTabViewState extends State<CalendarTabView> {
  @override
  Widget build(BuildContext context) {
    return const Calendar();
  }
}
