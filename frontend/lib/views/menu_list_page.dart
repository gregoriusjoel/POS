import 'package:flutter/material.dart';
import '../models/menu.dart';
import '../services/api_service.dart';
import 'menu_form_page.dart';

class MenuListPage extends StatefulWidget {
  const MenuListPage({super.key});

  @override
  State<MenuListPage> createState() => _MenuListPageState();
}

class _MenuListPageState extends State<MenuListPage> {
  late Future<List<Menu>> menuList;

  @override
  void initState() {
    super.initState();
    menuList = ApiService.fetchMenus();
  }

  void refreshMenu() {
    setState(() {
      menuList = ApiService.fetchMenus();
    });
  }

  void _delete(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Hapus Menu'),
        content: Text('Yakin ingin menghapus menu ini?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Batal')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: Text('Hapus')),
        ],
      ),
    );
    if (confirm == true) {
      await ApiService.deleteMenu(id);
      refreshMenu();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Daftar Menu')),
      body: FutureBuilder<List<Menu>>(
        future: menuList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final menus = snapshot.data!;
            return ListView.builder(
              itemCount: menus.length,
              itemBuilder: (context, index) {
                final menu = menus[index];
                return ListTile(
                  title: Text(menu.name),
                  subtitle: Text('Rp${menu.price} - ${menu.category}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(icon: Icon(Icons.edit), onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MenuFormPage(menu: menu),
                          ),
                        ).then((_) => refreshMenu());
                      }),
                      IconButton(icon: Icon(Icons.delete), onPressed: () => _delete(menu.id)),
                    ],
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => MenuFormPage()))
              .then((_) => refreshMenu());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
