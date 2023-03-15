import 'package:flutter/material.dart';

import '../../utils/date_formatters/date_formatter.dart';

class DateText extends StatelessWidget {
  final String dateString;

  const DateText({
    Key? key,
    required this.dateString,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: RichText(
        text: TextSpan(
          children: [
            WidgetSpan(
              child: Container(
                padding: const EdgeInsets.fromLTRB(8.0, 2.0, 6.0, 2.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.0),
                  color: Colors.grey.shade800,
                ),
                child: Text(
                  dateFormatterEEDD.format(DateTime.parse(dateString)),
                  style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            const WidgetSpan(
              child: SizedBox(width: 6.0),
            ),
            WidgetSpan(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  dateFormatterMMYYYY.format(DateTime.parse(dateString)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
