import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/menu.dart';
import '../models/user.dart';

class ApiService {
  static const baseUrl = 'http://127.0.0.1:8000/api'; // Ganti IP sesuai kebutuhan
  static String? _token;

  static void setToken(String token) {
    _token = token;
  }

  static Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (_token != null) 'Authorization': 'Bearer $_token',
  };

  // ✅ Login
  static Future<User?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final user = User.fromJson(json['data']);
      setToken(user.token); // simpan token
      return user;
    } else {
      return null;
    }
  }

  // ✅ Fetch menu
  static Future<List<Menu>> fetchMenus() async {
    final response = await http.get(
      Uri.parse('$baseUrl/menus'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body)['data'];
      return data.map((e) => Menu.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat data menu');
    }
  }

  // ✅ Tambah menu
  static Future<bool> addMenu(Menu menu) async {
    final response = await http.post(
      Uri.parse('$baseUrl/menus'),
      headers: _headers,
      body: jsonEncode(menu.toJson()),
    );
    return response.statusCode == 201;
  }

  // ✅ Update menu
  static Future<bool> updateMenu(int id, Menu menu) async {
    final response = await http.put(
      Uri.parse('$baseUrl/menus/$id'),
      headers: _headers,
      body: jsonEncode(menu.toJson()),
    );
    return response.statusCode == 200;
  }

  // ✅ Hapus menu
  static Future<bool> deleteMenu(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/menus/$id'),
      headers: _headers,
    );
    return response.statusCode == 200;
  }

  // ✅ Submit transaksi
  static Future<bool> submitTransaksi(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/transaksis'),
      headers: _headers,
      body: jsonEncode(data),
    );
    return response.statusCode == 201;
  }

  // ✅ Ambil riwayat transaksi
  static Future<List<dynamic>> getRiwayatTransaksi() async {
    final response = await http.get(
      Uri.parse('$baseUrl/transaksis'),
      headers: _headers,
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'];
    } else {
      throw Exception('Gagal memuat riwayat transaksi');
    }
  }

  // ✅ Ambil ringkasan dashboard
  static Future<Map<String, dynamic>> getDashboardSummary() async {
    final response = await http.get(
      Uri.parse('$baseUrl/dashboard/summary'),
      headers: _headers,
    );

    print('DASHBOARD STATUS: ${response.statusCode}');
    print('DASHBOARD BODY: ${response.body}');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Gagal memuat ringkasan dashboard');
    }
  }
}
