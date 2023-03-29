import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

import '/utils/date_formatters/date_formatter.dart';

import 'daily_booking_tab_view.dart';
import 'daily_statistics_tab_view.dart';

class DailyTabView extends StatefulWidget {
  const DailyTabView({Key? key}) : super(key: key);

  @override
  State<DailyTabView> createState() => _DailyTabViewState();
}

class _DailyTabViewState extends State<DailyTabView> {
  late DateTime _selectedDate = DateTime.now();
  late List<bool> _selectedTabOption = [true, false, false];

  void _setSelectedTab(int selectedIndex) {
    setState(() {
      for (int i = 0; i < _selectedTabOption.length; i++) {
        _selectedTabOption[i] = i == selectedIndex;
      }
      if (_selectedTabOption[0]) {
        _selectedTabOption = [true, false, false];
      } else if (_selectedTabOption[1]) {
        _selectedTabOption = [false, true, false];
      } else if (_selectedTabOption[2]) {
        _selectedTabOption = [false, false, true];
      } else {
        _selectedTabOption = [true, false, false];
      }
    });
  }

  void _nextMonth() {
    setState(() {
      _selectedDate = DateTime(_selectedDate.year, _selectedDate.month + 1, _selectedDate.day);
    });
  }

  void _previousMonth() {
    setState(() {
      _selectedDate = DateTime(_selectedDate.year, _selectedDate.month - 1, _selectedDate.day);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.keyboard_arrow_left_rounded),
                      onPressed: () => _previousMonth(),
                      padding: const EdgeInsets.only(left: 8.0, right: 2.0),
                      constraints: const BoxConstraints(),
                      splashColor: Colors.transparent,
                    ),
                    SizedBox(
                      width: 120.0,
                      child: GestureDetector(
                        onTap: () {
                          showMonthPicker(
                            context: context,
                            initialDate: _selectedDate,
                            headerColor: Colors.grey.shade800,
                            selectedMonthBackgroundColor: Colors.cyanAccent,
                            unselectedMonthTextColor: Colors.white,
                            confirmWidget: const Text('OK', style: TextStyle(color: Colors.cyanAccent)),
                            cancelWidget: const Text('Abbrechen', style: TextStyle(color: Colors.cyanAccent)),
                            locale: const Locale('DE-de'),
                            roundedCornersRadius: 12.0,
                            dismissible: true,
                          ).then((date) {
                            if (date != null) {
                              setState(() {
                                _selectedDate = date;
                              });
                            }
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Text(dateFormatterMMMMYYYY.format(_selectedDate), textAlign: TextAlign.center),
                        ),
                        behavior: HitTestBehavior.translucent,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.keyboard_arrow_right_rounded),
                      onPressed: () => _nextMonth(),
                      padding: const EdgeInsets.only(left: 2.0),
                      constraints: const BoxConstraints(),
                      splashColor: Colors.transparent,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: Padding(
                  padding: const EdgeInsets.only(right: 12.0, left: 12.0),
                  child: ToggleButtons(
                    onPressed: (selectedIndex) => _setSelectedTab(selectedIndex),
                    borderRadius: BorderRadius.circular(6.0),
                    selectedBorderColor: Colors.cyanAccent,
                    fillColor: Colors.cyanAccent.shade700,
                    selectedColor: Colors.white,
                    color: Colors.white60,
                    constraints: const BoxConstraints(
                      minHeight: 30.0,
                      minWidth: 50.0,
                    ),
                    isSelected: _selectedTabOption,
                    children: const [
                      Icon(Icons.menu_book_rounded, size: 20.0),
                      Icon(Icons.pie_chart_rounded, size: 20.0),
                      Icon(Icons.bar_chart_rounded, size: 20.0),
                    ],
                  ),
                ),
              ),
            ],
          ),
          _selectedTabOption[0] ? DailyBookingTabView(selectedDate: _selectedDate) : DailyStatisticsTabView(selectedDate: _selectedDate),
        ],
      ),
    );
  }
}
