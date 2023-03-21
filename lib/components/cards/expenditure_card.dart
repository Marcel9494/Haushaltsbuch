import 'package:flutter/material.dart';

class ExpenditureCard extends StatelessWidget {
  const ExpenditureCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xff1c2b30),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14.0),
      ),
      child: ClipPath(
        clipper: ShapeBorderClipper(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
        ),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(left: BorderSide(color: Colors.cyanAccent, width: 5)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Test'),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16.0, bottom: 16.0, right: 16.0),
                child: Text('Test'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
