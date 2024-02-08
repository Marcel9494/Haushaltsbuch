import 'package:flutter/material.dart';

class BottomSheetEmptyList extends StatelessWidget {
  final String text;

  const BottomSheetEmptyList({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 2 - 100.0,
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
