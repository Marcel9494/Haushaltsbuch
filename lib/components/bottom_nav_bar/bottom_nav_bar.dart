import 'package:flutter/material.dart';

import '/screens/bookings_screen.dart';
import '/screens/statistics_screen.dart';
import '/screens/accounts_screen.dart';

import '/models/screen_arguments/create_or_edit_booking_screen_arguments.dart';

import '/utils/consts/route_consts.dart';

class BottomNavBar extends StatefulWidget {
  final int screenIndex;

  const BottomNavBar({
    Key? key,
    required this.screenIndex,
  }) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  static List<Widget> _screens = [];
  late int _selectedIndex = widget.screenIndex;

  @override
  void initState() {
    super.initState();
    _screens = <Widget>[
      const BookingsScreen(),
      const StatisticsScreen(),
      const AccountsScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: _screens,
        ),
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () => Navigator.pushNamed(context, createOrEditBookingRoute, arguments: CreateOrEditBookingScreenArguments(-1)),
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.cyanAccent, Colors.cyan.shade700],
                  ),
                ),
                child: const Icon(
                  Icons.add_rounded,
                  size: 28.0,
                ),
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
        currentIndex: _selectedIndex,
        backgroundColor: const Color(0x0fffffff),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.auto_stories_rounded), label: 'Buchungen'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart_rounded), label: 'Budgets'),
          BottomNavigationBarItem(icon: Icon(Icons.monetization_on_rounded), label: 'Konten'),
        ],
      ),
    );
  }
}
