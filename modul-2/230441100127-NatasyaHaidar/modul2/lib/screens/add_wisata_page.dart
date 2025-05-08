import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';

class AddWisataPage extends StatefulWidget {
  const AddWisataPage({super.key});

  @override
  State<AddWisataPage> createState() => _AddWisataPageState();
}

class _AddWisataPageState extends State<AddWisataPage> {
  final _formKey = GlobalKey<FormState>();

  String? _nama;
  String? _lokasi;
  String? _harga;
  String? _deskripsi;
  String? _jenisWisata;
  File? _image;
  Uint8List? _webImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _webImage = bytes;
        });
      } else {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    }
  }

  void _submitForm() {
    final isValid = _formKey.currentState!.validate();
    final hasImage = _image != null || _webImage != null;

    if (isValid && hasImage) {
      _formKey.currentState!.save();

      final newWisata = {
        'nama': _nama,
        'lokasi': _lokasi,
        'harga': _harga,
        'deskripsi': _deskripsi,
        'jenis': _jenisWisata,
        'image': _webImage ?? _image,
      };

      Navigator.pop(context, newWisata);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data berhasil disimpan!', style: GoogleFonts.poppins())),
      );
    } else if (!hasImage) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gambar harus dipilih', style: GoogleFonts.poppins())),
      );
    }
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    setState(() {
      _jenisWisata = null;
      _image = null;
      _webImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Wisata', style: GoogleFonts.poppins()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: _webImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.memory(_webImage!, fit: BoxFit.cover),
                      )
                    : _image != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(_image!, fit: BoxFit.cover),
                          )
                        : const Center(
                            child: Icon(Icons.add_photo_alternate, size: 50),
                          ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _pickImage,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
                  child: Text('Upload Image', style: GoogleFonts.poppins(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 10),

           _buildFormField(
              label: 'Nama Wisata',
              hint: 'Masukkan Nama Wisata',
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Nama wisata tidak boleh kosong atau hanya spasi';
                }
                if (RegExp(r'[0-9]').hasMatch(value)) {
                  return 'Nama wisata tidak boleh mengandung angka';
                }
                return null;
              },
              onSaved: (value) => _nama = value!.trim(),
            ),
            const SizedBox(height: 10),

            _buildFormField(
              label: 'Lokasi',
              hint: 'Masukkan Lokasi Wisata',
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Lokasi tidak boleh kosong atau hanya spasi';
                }
                if (RegExp(r'[0-9]').hasMatch(value)) {
                  return 'Lokasi tidak boleh mengandung angka';
                }
                return null;
              },
              onSaved: (value) => _lokasi = value!.trim(),
            ),
            const SizedBox(height: 10),


              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Jenis Wisata :',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  DropdownButtonFormField<String>(
                    value: _jenisWisata,
                    decoration: _inputDecoration(''),
                    hint: Text('Pilih Jenis Wisata', style: GoogleFonts.poppins()),
                    items: const [
                      DropdownMenuItem(value: 'Alam', child: Text('Alam')),
                      DropdownMenuItem(value: 'Budaya', child: Text('Budaya')),
                      DropdownMenuItem(value: 'Religi', child: Text('Religi')),
                      DropdownMenuItem(value: 'Kuliner', child: Text('Kuliner')),
                    ],
                    style: GoogleFonts.poppins(),
                    onChanged: (value) => setState(() => _jenisWisata = value),
                    validator: (value) => value == null ? 'Pilih jenis wisata' : null,
                  ),
                ],
              ),
              const SizedBox(height: 10),

            _buildFormField(
                label: 'Harga',
                hint: 'Masukkan Harga',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Harga tidak boleh kosong atau hanya spasi';
                  }
                  if (!RegExp(r'^\d+$').hasMatch(value.trim())) {
                    return 'Harga harus berupa angka saja';
                  }
                  return null;
                },
                onSaved: (value) => _harga = value!.trim(),
              ),
              const SizedBox(height: 10),


           _buildFormField(
                label: 'Deskripsi',
                hint: 'Masukkan Deskripsi',
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Deskripsi tidak boleh kosong atau hanya spasi';
                  }
                  if (value.trim().split(RegExp(r'\s+')).length < 5) {
                    return 'Deskripsi minimal 5 kata';
                  }
                  if (RegExp(r'\d').hasMatch(value)) {
                    return 'Deskripsi tidak boleh mengandung angka';
                  }
                  return null;
                },
                onSaved: (value) => _deskripsi = value!.trim(),
              ),
              const SizedBox(height: 20),


              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
                  child: Text('Simpan', style: GoogleFonts.poppins(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 10),

              GestureDetector(
                onTap: _resetForm,
                child: Text(
                  'Reset',
                  style: GoogleFonts.poppins(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required String hint,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    required String? Function(String?) validator,
    required void Function(String?) onSaved,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        TextFormField(
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: _inputDecoration(hint),
          style: GoogleFonts.poppins(),
          validator: validator,
          onSaved: onSaved,
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.poppins(color: Colors.grey[600]),
      filled: true,
      fillColor: Colors.grey[200],
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    );
  }
}
