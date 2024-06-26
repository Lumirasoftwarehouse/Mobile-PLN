import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:pln/admin/dashboard.dart';
import 'package:pln/admin/projects.dart';
import 'package:pln/admin/kalender.dart';

class MenuAdmin extends StatefulWidget {
  @override
  _MenuAdminState createState() => _MenuAdminState();
}

class _MenuAdminState extends State<MenuAdmin> {
  int _selectedIndex = 0;
  int? _notificationCount;

  final List<Widget> _pages = [
    DashboardPage(),
    ProjectPage(),
    DashboardPage(),
    DashboardPage(),
  ];

  @override
  Widget build(BuildContext context) {
    // final authState = Provider.of<AuthState>(context);
    // setState(() {
    //   _notificationCount = authState.notifCount;
    // });

    // print('ini auth ${authState.notifCount}');
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        height: 50.0,
        items: const <Widget>[
          Icon(
            Icons.home, // Beranda
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.business_center, // Projects
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.monitor, // Monitoring
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.history, // History
            size: 30,
            color: Colors.white,
          ),
        ],
        color: Colors.blue,
        buttonBackgroundColor: Colors.blue,
        backgroundColor: Colors.white,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
