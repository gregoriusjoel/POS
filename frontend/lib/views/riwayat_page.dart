import 'package:flutter/material.dart';
import '../services/api_service.dart';

class RiwayatPage extends StatefulWidget {
  @override
  _RiwayatPageState createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  late Future<List<dynamic>> _riwayatList;

  @override
  void initState() {
    super.initState();
    _riwayatList = ApiService.getRiwayatTransaksi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Riwayat Transaksi')),
      body: FutureBuilder<List<dynamic>>(
        future: _riwayatList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final transaksiList = snapshot.data!;
            if (transaksiList.isEmpty) {
              return Center(child: Text("Belum ada transaksi"));
            }
            return ListView.builder(
              itemCount: transaksiList.length,
              itemBuilder: (context, index) {
                final transaksi = transaksiList[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text('Total: Rp ${transaksi['total']}'),
                    subtitle: Text('Tanggal: ${transaksi['created_at']}'),
                    trailing: Icon(Icons.receipt_long),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Gagal memuat data'));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
