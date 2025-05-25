import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin notifPlugin = FlutterLocalNotificationsPlugin();

class ReservasiForm extends StatefulWidget {
  const ReservasiForm({super.key});

  @override
  State<ReservasiForm> createState() => _ReservasiFormState();
}

class _ReservasiFormState extends State<ReservasiForm> {
  final _namaController = TextEditingController();
  final _jumlahController = TextEditingController();
  final _hpController = TextEditingController();
  List<File> _buktiPembayaranList = [];
  DateTime? _tanggal;
  TimeOfDay? _waktu;

  @override
  void initState() {
    super.initState();
    _setupNotifications();
  }

  Future<void> _setupNotifications() async {
    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );
    await notifPlugin.initialize(settings);
  }

  Future<void> _showNotif(String title, String body) async {
    const androidDetails = AndroidNotificationDetails(
      'channelId', 'Reservasi Notif',
      importance: Importance.max,
      priority: Priority.high,
    );
    const notifDetails = NotificationDetails(android: androidDetails);
    await notifPlugin.show(0, title, body, notifDetails);
  }

  Future<bool> _hasInternet() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  Future<void> _checkConnection() async {
    bool online = await _hasInternet();
    String status = online ? 'Online (Internet Aktif)' : 'Offline';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Koneksi: $status')),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source);
    if (picked != null) {
      setState(() {
        _buktiPembayaranList.add(File(picked.path));
      });
    }
  }

  Future<void> _pickTanggal() async {
    DateTime now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        _tanggal = picked;
      });
    }
  }

  Future<void> _pickWaktu() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _waktu = picked;
      });
    }
  }

  Future<void> _submit() async {
    await _checkConnection();

    String nama = _namaController.text.trim();
    String jumlah = _jumlahController.text.trim();

    final isNamaValid = RegExp(r"^[a-zA-Z\s]+$").hasMatch(nama);
    final isJumlahValid = int.tryParse(jumlah) != null && int.parse(jumlah) > 0;

    if (nama.isEmpty || !isNamaValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama harus huruf dan tidak boleh kosong')),
      );
      return;
    }

    if (jumlah.isEmpty || !isJumlahValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Jumlah orang harus angka > 0')),
      );
      return;
    }

    if (_buktiPembayaranList.isEmpty || _tanggal == null || _waktu == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lengkapi semua data dan foto')),
      );
      return;
    }

    Position pos = await Geolocator.getCurrentPosition();

    for (var file in _buktiPembayaranList) {
      final bytes = await file.readAsBytes();
      await ImageGallerySaver.saveImage(bytes,
          name: "reservasi_${DateTime.now().millisecondsSinceEpoch}");
    }

    await _showNotif("Reservasi Berhasil", "Atas nama $nama");

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reservasi berhasil disimpan!')),
    );

    Navigator.pop(context, {
      'nama': nama,
      'jumlah': jumlah,
      'hp': _hpController.text,
      'bukti': _buktiPembayaranList,
      'tanggal': "${_tanggal!.day}/${_tanggal!.month}/${_tanggal!.year}",
      'waktu': _waktu!.format(context),
      'lat': pos.latitude,
      'lng': pos.longitude,
    });
  }

  Widget _buildFotoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("🧾 Bukti Pembayaran", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        _buktiPembayaranList.isNotEmpty
            ? SizedBox(
                height: 150,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: _buktiPembayaranList
                      .map((f) => Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Image.file(f, height: 150),
                          ))
                      .toList(),
                ),
              )
            : const Text('Belum ada foto'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: () => _pickImage(ImageSource.camera),
              icon: const Icon(Icons.camera_alt),
              label: const Text("Kamera"),
            ),
            ElevatedButton.icon(
              onPressed: () => _pickImage(ImageSource.gallery),
              icon: const Icon(Icons.photo_library),
              label: const Text("Galeri"),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Form Reservasi')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _namaController,
              decoration: const InputDecoration(labelText: 'Nama Pemesan'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _jumlahController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Jumlah Orang'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _hpController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Nomor HP'),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text("Tanggal Reservasi: "),
                Text(_tanggal != null
                    ? "${_tanggal!.day}/${_tanggal!.month}/${_tanggal!.year}"
                    : "Belum dipilih"),
                const Spacer(),
                ElevatedButton(
                  onPressed: _pickTanggal,
                  child: const Text("Pilih Tanggal"),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text("Waktu Reservasi: "),
                Text(_waktu != null ? _waktu!.format(context) : "Belum dipilih"),
                const Spacer(),
                ElevatedButton(
                  onPressed: _pickWaktu,
                  child: const Text("Pilih Waktu"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildFotoSection(),
            ElevatedButton(
              onPressed: _submit,
              child: const Text('Simpan Reservasi'),
            ),
          ],
        ),
      ),
    );
  }
}
