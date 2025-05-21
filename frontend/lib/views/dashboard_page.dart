import 'package:flutter/material.dart';
import '../services/api_service.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int totalTransaksi = 0;
  int totalPendapatan = 0;
  int totalItem = 0;

  @override
  void initState() {
    super.initState();
    _loadSummary();
  }

  void _loadSummary() async {
    try {
      final data = await ApiService.getDashboardSummary();
      setState(() {
        totalTransaksi = data['total_transaksi'];
        totalPendapatan = data['total_pendapatan'];
        totalItem = data['total_item_terjual'];
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Gagal memuat dashboard')));
    }
  }

  Widget _buildCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(title),
        subtitle:
            Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard Penjualan'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.orange),
              child: Text(
                'Menu Navigasi',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.dashboard),
              title: Text('Dashboard'),
              onTap: () {
                Navigator.pop(context); // tutup drawer
              },
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text('Menu'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/menu');
              },
            ),
            ListTile(
              leading: Icon(Icons.point_of_sale),
              title: Text('POS'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/pos');
              },
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text('Riwayat'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/riwayat');
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                Navigator.pop(context);
                // Tambahkan logic logout kalau ada
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
          ],
        ),
      ),
      body: ListView(
        children: [
          _buildCard('Total Transaksi', '$totalTransaksi', Icons.swap_horiz, Colors.blue),
          _buildCard('Total Pendapatan', 'Rp $totalPendapatan', Icons.attach_money, Colors.green),
          _buildCard('Item Terjual', '$totalItem', Icons.fastfood, Colors.orange),
        ],
      ),
    );
  }
}
