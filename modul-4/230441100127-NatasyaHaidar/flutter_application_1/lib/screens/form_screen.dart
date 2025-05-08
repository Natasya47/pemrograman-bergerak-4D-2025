import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/reservasi.dart';
import '../services/reservasi_services.dart';

class FormScreen extends StatefulWidget {
  final Reservasi? reservasi;

  const FormScreen({Key? key, this.reservasi}) : super(key: key);

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _jumlahController = TextEditingController();
  final _tanggalController = TextEditingController();

  DateTime? _selectedDate;
  String? _selectedStatus;

  final ReservasiService _service = ReservasiService();

  @override
  void initState() {
    super.initState();
    if (widget.reservasi != null) {
      _namaController.text = widget.reservasi!.namaPelanggan;
      _jumlahController.text = widget.reservasi!.jumlahOrang.toString();
      _selectedDate = widget.reservasi!.tanggalReservasi;
      _tanggalController.text = _selectedDate!.toLocal().toString().split(' ')[0];
      _selectedStatus = widget.reservasi!.statusReservasi;
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate() && _selectedDate != null && _selectedStatus != null) {
      final newReservasi = Reservasi(
        id: widget.reservasi?.id ?? '',
        namaPelanggan: _namaController.text,
        jumlahOrang: int.parse(_jumlahController.text),
        tanggalReservasi: _selectedDate!,
        statusReservasi: _selectedStatus!,
      );

      try {
        if (widget.reservasi == null) {
          await _service.addReservasi(newReservasi);
        } else {
          await _service.updateReservasi(newReservasi);
        }
        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan data: $e')),
        );
      }
    } else {
      if (_selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pilih tanggal reservasi terlebih dahulu')),
        );
      }
      if (_selectedStatus == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pilih status reservasi terlebih dahulu')),
        );
      }
    }
  }

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _tanggalController.text = picked.toLocal().toString().split(' ')[0];
      });
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _jumlahController.dispose();
    _tanggalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        title: Text(
          'Form Reservasi',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _namaController,
                        decoration: InputDecoration(
                          labelText: 'Nama Pelanggan',
                          labelStyle: GoogleFonts.poppins(),
                        ),
                        style: GoogleFonts.poppins(),
                        validator: (value) => value == null || value.isEmpty ? 'Nama wajib diisi' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _jumlahController,
                        decoration: InputDecoration(
                          labelText: 'Jumlah Orang',
                          labelStyle: GoogleFonts.poppins(),
                        ),
                        style: GoogleFonts.poppins(),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Jumlah wajib diisi';
                          final jumlah = int.tryParse(value);
                          if (jumlah == null || jumlah <= 0) return 'Jumlah harus lebih dari 0';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _tanggalController,
                        decoration: InputDecoration(
                          labelText: 'Tanggal Reservasi',
                          labelStyle: GoogleFonts.poppins(),
                          suffixIcon: const Icon(Icons.calendar_today),
                        ),
                        style: GoogleFonts.poppins(),
                        readOnly: true,
                        onTap: _pickDate,
                        validator: (_) {
                          if (_selectedDate == null) return 'Tanggal wajib dipilih';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedStatus,
                        decoration: InputDecoration(
                          labelText: 'Status Reservasi',
                          labelStyle: GoogleFonts.poppins(),
                          hintText: 'Pilih Status',
                          hintStyle: GoogleFonts.poppins(color: Colors.grey),
                        ),
                        style: GoogleFonts.poppins(color: Colors.black),
                        validator: (value) => value == null ? 'Pilih status dulu' : null,
                        items: ['Pending', 'Confirmed', 'Cancelled']
                            .map((status) => DropdownMenuItem(
                                  value: status,
                                  child: Text(status, style: GoogleFonts.poppins()),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedStatus = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _submitForm,
                  child: Text(
                    'Simpan',
                    style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
