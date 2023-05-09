import 'package:flutter/material.dart';

import '/utils/date_formatters/date_formatter.dart';

typedef SelectedYearCallback = void Function(DateTime selectedYear);

class YearPickerButtons extends StatefulWidget {
  DateTime selectedYear;
  final SelectedYearCallback selectedYearCallback;

  YearPickerButtons({
    Key? key,
    required this.selectedYear,
    required this.selectedYearCallback,
  }) : super(key: key);

  @override
  State<YearPickerButtons> createState() => _YearPickerButtonsState();
}

class _YearPickerButtonsState extends State<YearPickerButtons> {
  void _nextYear() {
    setState(() {
      widget.selectedYear = DateTime(widget.selectedYear.year + 1);
      widget.selectedYearCallback(widget.selectedYear);
    });
  }

  void _previousYear() {
    setState(() {
      widget.selectedYear = DateTime(widget.selectedYear.year - 1);
      widget.selectedYearCallback(widget.selectedYear);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
                          selectedDate: widget.selectedYear,
                          onChanged: (DateTime date) {
                            setState(() {
                              widget.selectedYear = date;
                              widget.selectedYearCallback(widget.selectedYear);
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
                child: Text(dateFormatterYYYY.format(widget.selectedYear), textAlign: TextAlign.center),
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
    );
  }
}
