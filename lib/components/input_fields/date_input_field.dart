import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../deco/bottom_sheet_line.dart';

import '/models/enums/repeat_types.dart';

import '/screens/create_or_edit_booking_screen.dart';

import '/utils/date_formatters/date_formatter.dart';

typedef BookingDateCallback = void Function(DateTime bookingDate);
typedef RepeatCallback = void Function(String repeat);

class DateInputField extends StatefulWidget {
  final DateTime currentDate;
  final TextEditingController textController;
  final BookingDateCallback bookingDateCallback;
  final String repeat;
  final RepeatCallback repeatCallback;

  const DateInputField({
    Key? key,
    required this.currentDate,
    required this.textController,
    required this.bookingDateCallback,
    required this.repeat,
    required this.repeatCallback,
  }) : super(key: key);

  @override
  State<DateInputField> createState() => _DateInputFieldState();
}

class _DateInputFieldState extends State<DateInputField> {
  void _openBottomSheetWithRepeatList(BuildContext context) {
    showCupertinoModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Material(
          child: SizedBox(
            height: 584.0,
            child: ListView(
              children: [
                const BottomSheetLine(),
                const Padding(
                  padding: EdgeInsets.only(top: 16.0, left: 30.0),
                  child: Text('Wiederholung für Buchung:', style: TextStyle(fontSize: 18.0)),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: SizedBox(
                    height: 584.0,
                    child: ListView.builder(
                      itemCount: RepeatType.values.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 4.0),
                          child: ListTile(
                            title: Text(RepeatType.values[index].name, textAlign: TextAlign.center),
                            onTap: () => {
                              widget.repeatCallback(RepeatType.values[index].name),
                              if (RepeatType.values[index].name == RepeatType.beginningOfMonth.name)
                                {
                                  widget.textController.text = dateFormatterDDMMYYYYEE.format(DateTime(DateTime.now().year, DateTime.now().month + 1, 1)),
                                }
                              else if (RepeatType.values[index].name == RepeatType.endOfMonth.name)
                                {
                                  widget.textController.text = dateFormatterDDMMYYYYEE
                                      .format(DateTime(DateTime.now().year, DateTime.now().month, DateTime(DateTime.now().year, DateTime.now().month + 1, 0).day)),
                                },
                              Navigator.pop(context),
                            },
                            visualDensity: const VisualDensity(vertical: -4.0),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: widget.repeat == RepeatType.values[index].name ? Colors.cyanAccent.shade400 : Colors.grey,
                                  width: widget.repeat == RepeatType.values[index].name ? 1.2 : 0.4),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            tileColor: Colors.grey.shade800,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: widget.textController,
          maxLength: 10,
          readOnly: true,
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            hintText: 'Datum',
            counterText: '',
            prefixIcon: const IconTheme(
              data: IconThemeData(color: Colors.grey),
              child: Icon(Icons.today_rounded),
            ),
            suffixIcon: Column(
              children: [
                IconTheme(
                  data: IconThemeData(color: widget.repeat == RepeatType.noRepetition.name ? Colors.grey : Colors.cyanAccent),
                  child: IconButton(
                    onPressed: () => _openBottomSheetWithRepeatList(context),
                    icon: const Icon(Icons.repeat_rounded),
                    padding: widget.repeat == RepeatType.noRepetition.name ? null : const EdgeInsets.only(top: 6.0),
                    constraints: widget.repeat == RepeatType.noRepetition.name ? null : const BoxConstraints(),
                  ),
                ),
                widget.repeat == RepeatType.noRepetition.name
                    ? const SizedBox()
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0),
                        child: Text(widget.repeat, style: const TextStyle(fontSize: 10.0)),
                      ),
              ],
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.cyanAccent, width: 1.5),
            ),
          ),
          onTap: () async {
            DateTime? parsedDate = await showDatePicker(
              context: context,
              locale: const Locale('de', 'DE'),
              initialDate: widget.currentDate == DateTime.now() ? DateTime.now() : widget.currentDate,
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
              builder: (context, child) {
                return Theme(
                  child: child!,
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.dark(
                      primary: Colors.cyanAccent,
                      surface: Colors.grey.shade800,
                    ),
                    textButtonTheme: TextButtonThemeData(
                      style: TextButton.styleFrom(foregroundColor: Colors.cyanAccent),
                    ),
                  ),
                );
              },
            );
            if (parsedDate != null) {
              CreateOrEditBookingScreen.of(context)!.currentBookingDate = parsedDate;
              widget.textController.text = dateFormatterDDMMYYYYEE.format(parsedDate);
            }
          },
        ),
      ],
    );
  }
}
