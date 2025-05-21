import 'package:flutter/material.dart';
import 'views/login_page.dart';
import 'views/dashboard_page.dart';
import 'views/menu_list_page.dart';
import 'views/pos_page.dart';
import 'views/riwayat_page.dart';

void main() {
  runApp(AyamGeprekApp());
}

class AyamGeprekApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ayam Geprek AA',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
      routes: {
        '/dashboard': (context) => DashboardPage(),
        '/menu': (context) => MenuListPage(),
        '/pos': (context) => PosPage(),
        '/riwayat': (context) => RiwayatPage(),
      },
    );
  }
}
