import 'package:flutter/material.dart';
import '../models/menu.dart';
import '../services/api_service.dart';

class MenuFormPage extends StatefulWidget {
  final Menu? menu;

  const MenuFormPage({super.key, this.menu});

  @override
  State<MenuFormPage> createState() => _MenuFormPageState();
}

class _MenuFormPageState extends State<MenuFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController nameController;
  late final TextEditingController priceController;
  late final TextEditingController descController;

  final List<String> kategoriList = ['Makanan', 'Minuman', 'Snack'];
  String? selectedCategory;

  bool get isEdit => widget.menu != null;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.menu?.name ?? '');
    priceController = TextEditingController(text: widget.menu?.price.toString() ?? '');
    descController = TextEditingController(text: widget.menu?.description ?? '');
    selectedCategory = widget.menu?.category;
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    descController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final menu = Menu(
      id: widget.menu?.id ?? 0,
      name: nameController.text,
      price: double.tryParse(priceController.text) ?? 0,
      description: descController.text,
      category: selectedCategory ?? '',
    );

    try {
      bool success = isEdit
          ? await ApiService.updateMenu(menu.id, menu) // ✅ Fix di sini
          : await ApiService.addMenu(menu);

      if (success) {
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menyimpan data')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Menu' : 'Tambah Menu')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nama Menu'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Harga'),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Wajib diisi';
                  final price = double.tryParse(value);
                  if (price == null || price < 0) return 'Masukkan angka yang valid';
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: const InputDecoration(labelText: 'Kategori'),
                items: kategoriList.map((kategori) {
                  return DropdownMenuItem(
                    value: kategori,
                    child: Text(kategori),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value;
                  });
                },
                validator: (value) => value == null ? 'Pilih kategori' : null,
              ),
              TextFormField(
                controller: descController,
                decoration: const InputDecoration(labelText: 'Deskripsi'),
                maxLines: 2,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
