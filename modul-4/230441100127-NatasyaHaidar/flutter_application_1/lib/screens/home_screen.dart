// // screens/home_screen.dart
// import 'package:flutter/material.dart';
// import '../models/reservasi.dart';
// import '../services/reservasi_services.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final ReservasiService _service = ReservasiService();
//   late Future<List<Reservasi>> _reservasiList;

//   @override
//   void initState() {
//     super.initState();
//     _loadReservasi();
//   }

//   void _loadReservasi() {
//     setState(() {
//       _reservasiList = _service.getReservasiList();
//     });
//   }

//   void _hapusReservasi(String id) async {
//     await _service.deleteReservasi(id);
//     _loadReservasi();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Daftar Reservasi")),
//       body: FutureBuilder<List<Reservasi>>(
//         future: _reservasiList,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
//           if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));
//           if (!snapshot.hasData || snapshot.data!.isEmpty) return const Center(child: Text('Belum ada data'));

//           final list = snapshot.data!;
//           return ListView.builder(
//             itemCount: list.length,
//             itemBuilder: (context, index) {
//               final r = list[index];
//               return ListTile(
//                 title: Text(r.namaPelanggan),
//                 subtitle: Text('${r.jumlahOrang} orang | ${r.tanggalReservasi.substring(0,10)}'),
//                 trailing: IconButton(
//                   icon: const Icon(Icons.delete, color: Colors.red),
//                   onPressed: () => _hapusReservasi(r.id),
//                 ),
//                 onTap: () {
//                   // TODO: buka halaman edit jika ingin
//                 },
//               );
//             },
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: const Icon(Icons.add),
//         onPressed: () {
//           // TODO: buka halaman form input
//         },
//       ),
//     );
//   }
// }
// screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/reservasi.dart';
import '../services/reservasi_services.dart';
import 'form_screen.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ReservasiService _service = ReservasiService();
  late Future<List<Reservasi>> _reservasiList;

  @override
  void initState() {
    super.initState();
    _loadReservasi();
  }

  void _loadReservasi() {
    setState(() {
      _reservasiList = _service.getReservasiList();
    });
  }

  void _hapusReservasi(String id) async {
    await _service.deleteReservasi(id);
    _loadReservasi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        title: Text(
          "Daftar Reservasi",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Reservasi>>(
        future: _reservasiList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Belum ada data'));
          }

          final list = snapshot.data!;
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              final r = list[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    title: Text(
                      r.namaPelanggan,
                      style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${r.jumlahOrang} orang | ${DateFormat('dd MMM yyyy').format(r.tanggalReservasi)}',
                      style: GoogleFonts.poppins(color: Colors.grey[700]),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _hapusReservasi(r.id),
                    ),
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => FormScreen(reservasi: r)),
                      );
                      if (result == true) _loadReservasi();
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const FormScreen()),
          );
          if (result == true) _loadReservasi();
        },
      ),
    );
  }
}
