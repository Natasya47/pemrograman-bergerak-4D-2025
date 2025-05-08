class Reservasi {
  final String id;
  final String namaPelanggan;
  final int jumlahOrang;
  final DateTime tanggalReservasi;
  final String statusReservasi;

  Reservasi({
    required this.id,
    required this.namaPelanggan,
    required this.jumlahOrang,
    required this.tanggalReservasi,
    required this.statusReservasi,
  });

  factory Reservasi.fromJson(Map<String, dynamic> json) {
    final fields = json['fields'] ?? {};

    final tanggalStr = fields['tanggalReservasi']?['timestampValue'];
    final tanggal = tanggalStr != null
        ? DateTime.tryParse(tanggalStr) ?? DateTime(2000)
        : DateTime(2000); // fallback default

    return Reservasi(
      id: json['name']?.toString().replaceAll('\n', '').trim().split('/').last ?? '',
      namaPelanggan: fields['namaPelanggan']?['stringValue'] ?? '',
      jumlahOrang: int.tryParse(fields['jumlahOrang']?['integerValue'] ?? '0') ?? 0,
      tanggalReservasi: tanggal,
      statusReservasi: fields['statusReservasi']?['stringValue'] ?? '',
    );
  }
}
