import 'package:flutter/material.dart';

import '/components/tab_views/yearly_statistics_tab_view.dart';

import '../buttons/month_picker_buttons.dart';
import '../buttons/year_picker_buttons.dart';
import '../tab_views/monthly_booking_tab_view.dart';
import '../tab_views/monthly_statistics_tab_view.dart';
import '../tab_views/yearly_booking_tab_view.dart';

class BookingsTabBar extends StatefulWidget {
  const BookingsTabBar({Key? key}) : super(key: key);

  @override
  State<BookingsTabBar> createState() => _BookingsTabBarState();
}

class _BookingsTabBarState extends State<BookingsTabBar> {
  DateTime _selectedDate = DateTime.now();
  List<bool> _selectedTabOption = [true, false];

  void _setSelectedTab(int selectedIndex) {
    setState(() {
      for (int i = 0; i < _selectedTabOption.length; i++) {
        _selectedTabOption[i] = i == selectedIndex;
      }
      if (_selectedTabOption[0]) {
        _selectedTabOption = [true, false];
      } else if (_selectedTabOption[1]) {
        _selectedTabOption = [false, true];
      } else {
        _selectedTabOption = [true, false];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: const TabBar(
          indicatorColor: Colors.cyanAccent,
          tabs: <Widget>[
            Tab(text: 'Buchungen'),
            Tab(text: 'Statistiken'),
          ],
        ),
        body: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: _selectedTabOption[0]
                      ? MonthPickerButtons(selectedDate: _selectedDate, selectedDateCallback: (selectedDate) => setState(() => _selectedDate = selectedDate))
                      : YearPickerButtons(selectedYear: _selectedDate, selectedYearCallback: (selectedYear) => setState(() => _selectedDate = selectedYear)),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 12.0, left: 12.0),
                        child: ToggleButtons(
                          onPressed: (selectedIndex) => _setSelectedTab(selectedIndex),
                          borderRadius: BorderRadius.circular(6.0),
                          selectedBorderColor: Colors.cyanAccent,
                          fillColor: Colors.cyanAccent.shade700,
                          selectedColor: Colors.white,
                          color: Colors.white60,
                          constraints: const BoxConstraints(
                            minHeight: 26.0,
                            minWidth: 50.0,
                          ),
                          isSelected: _selectedTabOption,
                          children: [
                            Row(
                              children: const [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 4.0),
                                  child: Icon(Icons.calendar_month_rounded, size: 17.0),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 6.0),
                                  child: Text('Monat', style: TextStyle(fontSize: 12.0)),
                                ),
                              ],
                            ),
                            Row(
                              children: const [
                                Padding(
                                  padding: EdgeInsets.only(left: 8.0, right: 4.0),
                                  child: Icon(Icons.today_rounded, size: 17.0),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 8.0),
                                  child: Text('Jahr', style: TextStyle(fontSize: 12.0)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: <Widget>[
                  _selectedTabOption[0] ? MonthlyBookingTabView(selectedDate: _selectedDate, categorie: '', account: '') : YearlyBookingTabView(selectedDate: _selectedDate),
                  _selectedTabOption[0] ? MonthlyStatisticsTabView(selectedDate: _selectedDate) : YearlyStatisticsTabView(selectedDate: _selectedDate),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
