import 'package:flutter/material.dart';

import '/screens/create_or_edit_booking_screen.dart';

import '/models/enums/repeat_types.dart';

import '/utils/date_formatters/date_formatter.dart';
import '/utils/helper_components/scrolling_behavior.dart';

typedef BookingDateCallback = void Function(DateTime bookingDate);
typedef RepeatCallback = void Function(String repeat);

class DateInputField extends StatefulWidget {
  final TextEditingController textController;
  final BookingDateCallback bookingDateCallback;
  final String repeat;
  final RepeatCallback repeatCallback;

  const DateInputField({
    Key? key,
    required this.textController,
    required this.bookingDateCallback,
    required this.repeat,
    required this.repeatCallback,
  }) : super(key: key);

  @override
  State<DateInputField> createState() => _DateInputFieldState();
}

class _DateInputFieldState extends State<DateInputField> {
  void _showRepeatTypeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Wiederholung:'),
          content: SizedBox(
            height: 400.0,
            child: ScrollConfiguration(
              behavior: ScrollingBehavior(),
              child: ListView.builder(
                itemCount: RepeatType.values.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(RepeatType.values[index].name),
                    onTap: () => {
                      setState(() {
                        widget.repeatCallback(RepeatType.values[index].name);
                        if (RepeatType.values[index].name == RepeatType.beginningOfMonth.name) {
                          widget.textController.text = dateFormatterDDMMYYYYEE.format(DateTime(DateTime.now().year, DateTime.now().month + 1, 1));
                        } else if (RepeatType.values[index].name == RepeatType.endOfMonth.name) {
                          widget.textController.text =
                              dateFormatterDDMMYYYYEE.format(DateTime(DateTime.now().year, DateTime.now().month, DateTime(DateTime.now().year, DateTime.now().month + 1, 0).day));
                        }
                      }),
                      Navigator.pop(context),
                    },
                  );
                },
              ),
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
                    onPressed: () => _showRepeatTypeDialog(context),
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
              initialDate: DateTime.now(),
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
