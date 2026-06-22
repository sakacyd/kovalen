import 'package:flutter/material.dart';

class MessagesPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const MessagesPage());
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        // Anda bisa menambahkan aksi atau tombol di sini nantinya
      ),
      body: const Center(
        child: Text('Halaman Messages Kosong', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
