import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../deco/bottom_sheet_header.dart';
import '../deco/bottom_sheet_line.dart';

import '/models/enums/repeat_types.dart';

import '/utils/date_formatters/date_formatter.dart';

class DateInputField extends StatelessWidget {
  final dynamic cubit;
  final FocusNode focusNode;
  final bool enabled;

  const DateInputField({
    Key? key,
    required this.cubit,
    required this.focusNode,
    this.enabled = true,
  }) : super(key: key);

  void _openBottomSheetWithRepeatList(BuildContext context) {
    showCupertinoModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Material(
          child: SizedBox(
            height: MediaQuery.of(context).size.height / 2,
            child: ListView(
              children: [
                const BottomSheetLine(),
                const BottomSheetHeader(title: 'Wiederholung für Buchung:', leftPadding: 30.0),
              Center(
                child: GridView.count(
                  primary: false,
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                  crossAxisCount: 1,
                  // TODO hier weitermachen und Style wiederherstellen
                  childAspectRatio: (1 / 0.1),
                  //mainAxisSpacing: 5,
                  //crossAxisSpacing: 5,
                  shrinkWrap: true,
                  children: <Widget>[
                    for (int i = 0; i < RepeatType.values.length; i++)
                      ButtonTheme(
                        height: 20.0,
                        child: OutlinedButton(
                        onPressed: () => {
                            cubit.updateBookingRepeat(RepeatType.values[i].name),
                            if (RepeatType.values[i].name == RepeatType.beginningOfMonth.name)
                              {
                                cubit.updateBookingDate(DateTime(DateTime.now().year, DateTime.now().month + 1, 1).toString()),
                              }
                            else if (RepeatType.values[i].name == RepeatType.endOfMonth.name)
                              {
                                cubit.updateBookingDate(
                                    DateTime(DateTime.now().year, DateTime.now().month, DateTime(DateTime.now().year, DateTime.now().month + 1, 0).day).toString()),
                              },
                            Navigator.pop(context),
                          }, child: Text(RepeatType.values[i].name, textAlign: TextAlign.center),
                    ),
                      ),
                  ],
                ),
              ),
                /*Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: SizedBox(
                    height: 300.0,
                    child: ListView.builder(
                      itemCount: RepeatType.values.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 4.0),
                          child: ListTile(
                            title: Text(RepeatType.values[index].name, textAlign: TextAlign.center),
                            onTap: () => {
                              cubit.updateBookingRepeat(RepeatType.values[index].name),
                              if (RepeatType.values[index].name == RepeatType.beginningOfMonth.name)
                                {
                                  cubit.updateBookingDate(DateTime(DateTime.now().year, DateTime.now().month + 1, 1).toString()),
                                }
                              else if (RepeatType.values[index].name == RepeatType.endOfMonth.name)
                                {
                                  cubit.updateBookingDate(
                                      DateTime(DateTime.now().year, DateTime.now().month, DateTime(DateTime.now().year, DateTime.now().month + 1, 0).day).toString()),
                                },
                              Navigator.pop(context),
                            },
                            visualDensity: const VisualDensity(vertical: -4.0),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: cubit.state.bookingRepeat == RepeatType.values[index].name ? Colors.cyanAccent.shade400 : Colors.grey,
                                  width: cubit.state.bookingRepeat == RepeatType.values[index].name ? 1.2 : 0.4),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            tileColor: Colors.grey.shade800,
                          ),
                        );
                      },
                    ),
                  ),
                ),*/
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: UniqueKey(),
      enabled: enabled,
      focusNode: focusNode,
      initialValue: dateFormatterDDMMYYYYEE.format(DateTime.parse(cubit.state.bookingDate)),
      maxLength: 10,
      readOnly: true,
      textAlignVertical: TextAlignVertical.center,
      style: TextStyle(color: enabled ? Colors.white : Colors.grey),
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
              data: IconThemeData(color: cubit.state.bookingRepeat == RepeatType.noRepetition.name ? Colors.grey : Colors.cyanAccent),
              child: IconButton(
                onPressed: () => _openBottomSheetWithRepeatList(context),
                icon: Icon(Icons.repeat_rounded, color: enabled ? cubit.state.bookingRepeat == RepeatType.noRepetition.name ? Colors.grey : Colors.cyanAccent : Colors.grey),
                padding: cubit.state.bookingRepeat == RepeatType.noRepetition.name ? null : const EdgeInsets.only(top: 6.0),
                constraints: cubit.state.bookingRepeat == RepeatType.noRepetition.name ? null : const BoxConstraints(),
              ),
            ),
            cubit.state.bookingRepeat == RepeatType.noRepetition.name
                ? const SizedBox()
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    child: Text(cubit.state.bookingRepeat, style: TextStyle(fontSize: 10.0, color: enabled ? Colors.white : Colors.grey)),
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
          initialDate: DateTime.parse(cubit.state.bookingDate),
          firstDate: DateTime(2000),
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
          cubit.updateBookingDate(parsedDate.toString());
          if (cubit.state.bookingRepeat == RepeatType.beginningOfMonth.name && parsedDate.day != 1) {
            cubit.updateBookingRepeat(RepeatType.noRepetition.name);
          } else if (cubit.state.bookingRepeat == RepeatType.endOfMonth.name && parsedDate.day == 0) {
            cubit.updateBookingRepeat(RepeatType.noRepetition.name);
          }
        }
      },
    );
  }
}
