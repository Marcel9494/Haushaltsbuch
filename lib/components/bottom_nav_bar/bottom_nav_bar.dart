import 'package:flutter/material.dart';

import '/screens/bookings_screen.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  static List<Widget> _screens = [];
  late int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _screens = <Widget>[
      const BookingsScreen(),
      const BookingsScreen(),
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
      appBar: AppBar(
        title: const Text('Haushaltsbuch'),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/addOrEditBooking', (route) => false),
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
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
        currentIndex: _selectedIndex,
        backgroundColor: const Color(0x0fffffff),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.auto_stories_rounded), label: 'Buchungen'),
          BottomNavigationBarItem(icon: Icon(Icons.monetization_on_rounded), label: 'Konten'),
        ],
      ),
    );
  }
}
