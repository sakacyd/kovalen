import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const HomePage());
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beranda'),
        // Anda bisa menambahkan aksi atau tombol di sini nantinya
      ),
      body: const Center(
        child: Text('Halaman Homepage Kosong', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
