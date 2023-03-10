import 'package:flutter/material.dart';

class ChangeMonthButtons extends StatefulWidget {
  const ChangeMonthButtons({Key? key}) : super(key: key);

  @override
  State<ChangeMonthButtons> createState() => _ChangeMonthButtonsState();
}

class _ChangeMonthButtonsState extends State<ChangeMonthButtons> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.keyboard_arrow_left_rounded),
          onPressed: () => {},
        ),
        const Text('März 2023'),
        IconButton(
          icon: const Icon(Icons.keyboard_arrow_right_rounded),
          onPressed: () => {},
        ),
      ],
    );
  }
}
