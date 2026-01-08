import 'package:flutter/material.dart';

import 'events/events_screen.dart';
import 'registration/registration_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [EventsScreen(), RegistrationScreen()];

  void _onTap(int index) {
    if (_currentIndex == index) return;
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Sự kiện'),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Đăng ký',
          ),
        ],
      ),
    );
  }
}
