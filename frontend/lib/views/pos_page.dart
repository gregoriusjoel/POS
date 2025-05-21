import 'package:flutter/material.dart';
import '../models/menu.dart';
import '../services/api_service.dart';

class PosPage extends StatefulWidget {
  const PosPage({super.key});

  @override
  State<PosPage> createState() => _PosPageState();
}

class _PosPageState extends State<PosPage> {
  List<Menu> allMenu = [];
  Map<Menu, int> cart = {};

  @override
  void initState() {
    super.initState();
    fetchMenu();
  }

  Future<void> fetchMenu() async {
    final menuList = await ApiService.fetchMenus();
    setState(() {
      allMenu = menuList;
    });
  }

  void addToCart(Menu menu) {
    setState(() {
      cart.update(menu, (qty) => qty + 1, ifAbsent: () => 1);
    });
  }

  void removeFromCart(Menu menu) {
    setState(() {
      if (cart.containsKey(menu)) {
        if (cart[menu]! > 1) {
          cart[menu] = cart[menu]! - 1;
        } else {
          cart.remove(menu);
        }
      }
    });
  }

  double get total {
    double total = 0;
    cart.forEach((menu, qty) {
      total += menu.price * qty;
    });
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('POS - Ayam Geprek AA')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: allMenu.length,
              itemBuilder: (context, index) {
                final menu = allMenu[index];
                return ListTile(
                  title: Text(menu.name),
                  subtitle: Text('Rp ${menu.price.toStringAsFixed(0)}'),
                  trailing: ElevatedButton(
                    onPressed: () => addToCart(menu),
                    child: Text('Tambah'),
                  ),
                );
              },
            ),
          ),
          Divider(),
          Text('Keranjang:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Expanded(
            child: ListView(
              children: cart.entries.map((entry) {
                final menu = entry.key;
                final qty = entry.value;
                return ListTile(
                  title: Text(menu.name),
                  subtitle: Text('Jumlah: $qty'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(onPressed: () => removeFromCart(menu), icon: Icon(Icons.remove)),
                      IconButton(onPressed: () => addToCart(menu), icon: Icon(Icons.add)),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text('Total: Rp ${total.toStringAsFixed(0)}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    // TODO: simpan transaksi
                  },
                  child: Text('Simpan Transaksi'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
