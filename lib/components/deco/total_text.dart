import 'package:flutter/material.dart';

class TotalText extends StatelessWidget {
  final String total;

  const TotalText({
    Key? key,
    required this.total,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Gesamtsumme:'),
            Text(
              total,
              style: const TextStyle(fontSize: 22.0),
            )
          ],
        ),
      ),
    );
  }
}
