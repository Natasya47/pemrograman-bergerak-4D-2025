import 'dart:io';
import 'package:flutter/material.dart';
import 'reservasi_form.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Reservasi Restoran',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> _reservasiList = [];

  void _navigateToForm() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ReservasiForm()),
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        _reservasiList.insert(0, result); // Tambah data baru ke atas
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Reservasi')),
      body: _reservasiList.isEmpty
          ? const Center(child: Text('Belum ada reservasi'))
          : ListView.builder(
              itemCount: _reservasiList.length,
              itemBuilder: (context, index) {
                final data = _reservasiList[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("💼 Nama: ${data['nama']}", style: const TextStyle(fontSize: 16)),
                        Text("👥 Jumlah Orang: ${data['jumlah']}"),
                        Text("📞 HP: ${data['hp']}"),
                        Text("📅 Tanggal: ${data['tanggal'] ?? '-'}"),
                        Text("⏰ Waktu: ${data['waktu'] ?? '-'}"),
                        const SizedBox(height: 8),
                        const Text("📟 Bukti Pembayaran:"),
                        SizedBox(
                          height: 150,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: (data['bukti'] as List<File>).map<Widget>((f) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Image.file(f, height: 150),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text("📍 Lokasi: ${data['lat']}, ${data['lng']}"),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToForm,
        child: const Icon(Icons.add),
      ),
    );
  }
}
