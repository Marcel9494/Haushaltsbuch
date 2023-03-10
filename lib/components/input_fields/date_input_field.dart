import 'package:flutter/material.dart';

import '/utils/date_formatters/date_formatter.dart';

import '/screens/create_or_edit_booking_screen.dart';

typedef BookingDateCallback = void Function(DateTime bookingDate);

class DateInputField extends StatelessWidget {
  final TextEditingController textController;
  final BookingDateCallback bookingDateCallback;

  const DateInputField({
    Key? key,
    required this.textController,
    required this.bookingDateCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textController,
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
        suffixIcon: IconTheme(
          data: const IconThemeData(color: Colors.grey),
          child: IconButton(
            onPressed: () => {},
            icon: const Icon(Icons.repeat_rounded),
          ),
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
                  style: TextButton.styleFrom(primary: Colors.cyanAccent),
                ),
              ),
            );
          },
        );
        if (parsedDate != null) {
          CreateOrEditBookingScreen.of(context)!.currentBookingDate = parsedDate;
          textController.text = dateFormatterDDMMYYYYEE.format(parsedDate);
        }
      },
    );
  }
}
