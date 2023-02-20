import 'package:flutter/material.dart';

class BottomSheetLine extends StatelessWidget {
  const BottomSheetLine({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0, bottom: 4.0),
        child: Container(
          width: 75,
          height: 2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Colors.white70,
          ),
        ),
      ),
    );
  }
}
