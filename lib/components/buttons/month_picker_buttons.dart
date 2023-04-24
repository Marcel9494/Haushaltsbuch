import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

import '/utils/date_formatters/date_formatter.dart';

typedef SelectedDateCallback = void Function(DateTime selectedDate);

class MonthPickerButtons extends StatefulWidget {
  DateTime selectedDate;
  final SelectedDateCallback selectedDateCallback;

  MonthPickerButtons({
    Key? key,
    required this.selectedDate,
    required this.selectedDateCallback,
  }) : super(key: key);

  @override
  State<MonthPickerButtons> createState() => _MonthPickerButtonsState();
}

class _MonthPickerButtonsState extends State<MonthPickerButtons> {
  void _nextMonth() {
    setState(() {
      widget.selectedDate = DateTime(widget.selectedDate.year, widget.selectedDate.month + 1, widget.selectedDate.day);
      widget.selectedDateCallback(widget.selectedDate);
    });
  }

  void _previousMonth() {
    setState(() {
      widget.selectedDate = DateTime(widget.selectedDate.year, widget.selectedDate.month - 1, widget.selectedDate.day);
      widget.selectedDateCallback(widget.selectedDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
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
                initialDate: widget.selectedDate,
                headerColor: Colors.grey.shade800,
                selectedMonthBackgroundColor: Colors.cyanAccent,
                unselectedMonthTextColor: Colors.white,
                confirmWidget: const Text('OK', style: TextStyle(color: Colors.cyanAccent)),
                cancelWidget: const Text('Abbrechen', style: TextStyle(color: Colors.grey)),
                locale: const Locale('DE-de'),
                roundedCornersRadius: 12.0,
                dismissible: true,
              ).then((date) {
                if (date != null) {
                  setState(() {
                    widget.selectedDate = date;
                    widget.selectedDateCallback(widget.selectedDate);
                  });
                }
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Text(dateFormatterMMMMYYYY.format(widget.selectedDate), textAlign: TextAlign.center),
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
    );
  }
}
