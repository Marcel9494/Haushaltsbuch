import 'package:flutter/material.dart';

import '../tab_views/calendar_tab_view.dart';
import '../tab_views/daily_tab_view.dart';
import '../tab_views/monthly_tab_view.dart';

class BookingsTabBar extends StatefulWidget {
  const BookingsTabBar({Key? key}) : super(key: key);

  @override
  State<BookingsTabBar> createState() => _BookingsTabBarState();
}

class _BookingsTabBarState extends State<BookingsTabBar> {
  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: TabBar(
          indicatorColor: Colors.cyanAccent,
          tabs: <Widget>[
            Tab(text: 'Kalender'),
            Tab(text: 'Täglich'),
            Tab(text: 'Monatlich'),
          ],
        ),
        body: TabBarView(
          children: <Widget>[
            CalendarTabView(),
            DailyTabView(),
            MonthlyTabView(),
          ],
        ),
      ),
    );
  }
}
