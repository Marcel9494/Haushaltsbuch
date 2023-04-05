import 'package:flutter/material.dart';

import '../tab_views/monthly_tab_view.dart';
import '../tab_views/yearly_tab_view.dart';

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
      length: 2,
      child: Scaffold(
        appBar: TabBar(
          indicatorColor: Colors.cyanAccent,
          tabs: <Widget>[
            Tab(text: 'Monatlich'),
            Tab(text: 'Jährlich'),
          ],
        ),
        body: TabBarView(
          children: <Widget>[
            MonthlyTabView(),
            YearlyTabView(),
          ],
        ),
      ),
    );
  }
}
