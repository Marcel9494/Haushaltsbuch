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
  late List<bool> _selectedBookingOption = [true, false, false];

  void _setSelectedBooking(int selectedIndex) {
    setState(() {
      for (int i = 0; i < _selectedBookingOption.length; i++) {
        _selectedBookingOption[i] = i == selectedIndex;
      }
      if (_selectedBookingOption[0]) {
        _selectedBookingOption = [true, false, false];
      } else if (_selectedBookingOption[1]) {
        _selectedBookingOption = [false, true, false];
      } else if (_selectedBookingOption[2]) {
        _selectedBookingOption = [false, false, true];
      } else {
        _selectedBookingOption = [true, false, false];
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 14.0),
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
                      ).then((date) {
                        if (date != null) {
                          setState(() {
                            _selectedDate = date;
                          });
                        }
                      });
                    },
                    child: Text(dateFormatterMMMMYYYY.format(_selectedDate))),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 12.0, left: 12.0),
                child: ToggleButtons(
                  onPressed: (selectedIndex) => _setSelectedBooking(selectedIndex),
                  borderRadius: BorderRadius.circular(6.0),
                  selectedBorderColor: Colors.cyanAccent,
                  fillColor: Colors.cyanAccent.shade700,
                  selectedColor: Colors.white,
                  color: Colors.white60,
                  constraints: const BoxConstraints(
                    minHeight: 30.0,
                    minWidth: 60.0,
                  ),
                  isSelected: _selectedBookingOption,
                  children: const [
                    Icon(Icons.menu_book_rounded, size: 20.0),
                    Icon(Icons.pie_chart_rounded, size: 20.0),
                    Icon(Icons.bar_chart_rounded, size: 20.0),
                  ],
                ),
              ),
            ],
          ),
          _selectedBookingOption[0] ? DailyBookingTabView(selectedDate: _selectedDate) : DailyStatisticsTabView(selectedDate: _selectedDate),
        ],
      ),
    );
  }
}
