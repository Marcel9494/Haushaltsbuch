import 'package:flutter/material.dart';

import '/components/tab_views/yearly_booking_tab_view.dart';
import '/components/tab_views/yearly_statistics_tab_view.dart';

import '/utils/date_formatters/date_formatter.dart';

class YearlyTabView extends StatefulWidget {
  const YearlyTabView({Key? key}) : super(key: key);

  @override
  State<YearlyTabView> createState() => _YearlyTabViewState();
}

class _YearlyTabViewState extends State<YearlyTabView> {
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

  void _nextYear() {
    setState(() {
      _selectedDate = DateTime(_selectedDate.year + 1, _selectedDate.month, _selectedDate.day);
    });
  }

  void _previousYear() {
    setState(() {
      _selectedDate = DateTime(_selectedDate.year - 1, _selectedDate.month, _selectedDate.day);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.keyboard_arrow_left_rounded),
                    onPressed: () => _previousYear(),
                    padding: const EdgeInsets.only(left: 8.0, right: 2.0),
                    constraints: const BoxConstraints(),
                    splashColor: Colors.transparent,
                  ),
                  SizedBox(
                    width: 120.0,
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Jahr auswählen:'),
                              content: SizedBox(
                                width: 300,
                                height: 300,
                                child: YearPicker(
                                  firstDate: DateTime(1950, 1),
                                  lastDate: DateTime(DateTime.now().year + 100, 1),
                                  initialDate: DateTime.now(),
                                  selectedDate: _selectedDate,
                                  onChanged: (DateTime date) {
                                    setState(() {
                                      _selectedDate = date;
                                    });
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Text(dateFormatterYYYY.format(_selectedDate), textAlign: TextAlign.center),
                      ),
                      behavior: HitTestBehavior.translucent,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.keyboard_arrow_right_rounded),
                    onPressed: () => _nextYear(),
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
                  ],
                ),
              ),
            ),
          ],
        ),
        _selectedTabOption[0] ? YearlyBookingTabView(selectedDate: _selectedDate) : YearlyStatisticsTabView(selectedDate: _selectedDate)
      ],
    );
  }
}
