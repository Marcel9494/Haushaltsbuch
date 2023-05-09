import 'package:flutter/material.dart';

import '../buttons/year_picker_buttons.dart';

import '/components/tab_views/yearly_booking_tab_view.dart';
import '/components/tab_views/yearly_statistics_tab_view.dart';

class YearlyTabView extends StatefulWidget {
  const YearlyTabView({Key? key}) : super(key: key);

  @override
  State<YearlyTabView> createState() => _YearlyTabViewState();
}

class _YearlyTabViewState extends State<YearlyTabView> {
  DateTime _selectedYear = DateTime.now();
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
    return Column(
      children: [
        Row(
          children: [
            YearPickerButtons(selectedYear: _selectedYear, selectedYearCallback: (selectedYear) => setState(() => _selectedYear = selectedYear)),
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
        _selectedTabOption[0] ? YearlyBookingTabView(selectedDate: _selectedYear) : YearlyStatisticsTabView(selectedDate: _selectedYear)
      ],
    );
  }
}
