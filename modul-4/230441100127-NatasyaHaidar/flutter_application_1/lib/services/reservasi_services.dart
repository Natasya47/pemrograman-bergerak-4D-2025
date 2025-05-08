import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/reservasi.dart';

class ReservasiService {
  final String baseUrl =
      'https://firestore.googleapis.com/v1/projects/reservasi-restoran/databases/(default)/documents/reservasi';

  Future<List<Reservasi>> getReservasiList() async {
    final response = await http.get(Uri.parse(baseUrl));

    print('Status code: ${response.statusCode}');
    print('Raw response: ${response.body}');

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      print('Parsed JSON: ${jsonEncode(jsonData)}'); // Tambahkan log

      if (jsonData['documents'] != null) {
        return (jsonData['documents'] as List)
            .map((doc) => Reservasi.fromJson(doc))
            .toList();
      }
      return [];
    } else {
      throw Exception('Gagal mengambil data: ${response.body}');
    }
  }

  Future<void> addReservasi(Reservasi reservasi) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'fields': {
          'namaPelanggan': {'stringValue': reservasi.namaPelanggan},
          'jumlahOrang': {'integerValue': reservasi.jumlahOrang.toString()},
          'tanggalReservasi': {
            'timestampValue':
                reservasi.tanggalReservasi.toUtc().toIso8601String()
          },
          'statusReservasi': {'stringValue': reservasi.statusReservasi},
        },
      }),
    );

    print('Add Status code: ${response.statusCode}');
    print('Add Response body: ${response.body}');

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Gagal menambah data: ${response.body}');
    }
  }

  Future<void> updateReservasi(Reservasi reservasi) async {
    final url = '$baseUrl/${reservasi.id}';
    final response = await http.patch(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'fields': {
          'namaPelanggan': {'stringValue': reservasi.namaPelanggan},
          'jumlahOrang': {'integerValue': reservasi.jumlahOrang.toString()},
          'tanggalReservasi': {
            'timestampValue':
                reservasi.tanggalReservasi.toUtc().toIso8601String()
          },
          'statusReservasi': {'stringValue': reservasi.statusReservasi},
        },
      }),
    );

    print('Update Status code: ${response.statusCode}');
    print('Update Response: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Gagal update data');
    }
  }

  Future<void> deleteReservasi(String id) async {
    final url = '$baseUrl/$id';
    final response = await http.delete(Uri.parse(url));

    print('Delete Status code: ${response.statusCode}');
    print('Delete Response: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Gagal hapus data');
    }
  }
}
