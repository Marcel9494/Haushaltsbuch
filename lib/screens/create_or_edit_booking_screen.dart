import 'package:flutter/material.dart';

import '/components/buttons/transaction_toggle_buttons.dart';
import '/components/input_fields/title_input_field.dart';
import '/components/input_fields/amount_input_field.dart';
import '/components/input_fields/account_input_field.dart';

class CreateOrEditBookingScreen extends StatefulWidget {
  const CreateOrEditBookingScreen({Key? key}) : super(key: key);

  @override
  State<CreateOrEditBookingScreen> createState() => _CreateOrEditBookingScreenState();
}

class _CreateOrEditBookingScreenState extends State<CreateOrEditBookingScreen> {
  //final TextEditingController _titleTextController = TextEditingController();
  final TextEditingController _amountTextController = TextEditingController();
  final TextEditingController _accountTextController = TextEditingController();
  String _title = '';

  void _setTitleState(String title) {
    setState(() {
      _title = title;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO hier weitermachen und erste Testbuchungen erstellen können, um diese in den
    // unterschiedlichen Tab Views (Kalender, Täglich & Monatlich) anzeigen lassen zu können.
    return Scaffold(
      backgroundColor: const Color(0x00ffffff),
      appBar: AppBar(
        title: const Text('Buchung erstellen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Card(
          color: const Color(0x1fffffff),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
          child: Column(
            children: [
              const TransactionToggleButtons(),
              TitleInputField(
                title: _title,
                titleCallback: _setTitleState,
              ),
              AmountInputField(textController: _amountTextController),
              AccountInputField(textController: _accountTextController),
            ],
          ),
        ),
      ),
    );
  }
}
