import 'package:flutter/material.dart';

class DateInputField extends StatelessWidget {
  final TextEditingController textController;

  const DateInputField({
    Key? key,
    required this.textController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textController,
      maxLength: 10,
      readOnly: true,
      textAlignVertical: TextAlignVertical.center,
      decoration: const InputDecoration(
        hintText: 'Datum',
        counterText: '',
        prefixIcon: Icon(Icons.calendar_today_rounded),
        focusedBorder: UnderlineInputBorder(
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
        );
        if (parsedDate != null) {
          // TODO
          textController.text = parsedDate.toString();
          /*_birthdayTextController.text = dateFormatter.format(parsedBirthdayDate);
            savedBirthdayFormat = StringToSavedDateFormatYYYYMMDD(_birthdayTextController.text);
            setState(() {
              isContactInCreationProgress = true;
            });*/
        }
      },
    );
  }
}
