import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beranda'),
        // Anda bisa menambahkan aksi atau tombol di sini nantinya
      ),
      body: const Center(
        child: Text(
          'Halaman Homepage Kosong',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}