import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

import '../buttons/month_picker_buttons.dart';
import '/utils/date_formatters/date_formatter.dart';

import 'monthly_booking_tab_view.dart';
import 'monthly_budget_tab_view.dart';
import 'monthly_statistics_tab_view.dart';

class MonthlyTabView extends StatefulWidget {
  const MonthlyTabView({Key? key}) : super(key: key);

  @override
  State<MonthlyTabView> createState() => _MonthlyTabViewState();
}

class _MonthlyTabViewState extends State<MonthlyTabView> {
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
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: MonthPickerButtons(selectedDate: _selectedDate, selectedDateCallback: (selectedDate) => setState(() => _selectedDate = selectedDate)),
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
                          minHeight: 30.0,
                          minWidth: 50.0,
                        ),
                        isSelected: _selectedTabOption,
                        children: const [
                          Icon(Icons.menu_book_rounded, size: 20.0),
                          Icon(Icons.pie_chart_rounded, size: 20.0),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          _selectedTabOption[0]
              ? MonthlyBookingTabView(selectedDate: _selectedDate)
              : _selectedTabOption[1]
                  ? MonthlyStatisticsTabView(selectedDate: _selectedDate)
                  : const MonthlyBudgetTabView(),
        ],
      ),
    );
  }
}
