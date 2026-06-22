import 'package:flutter/material.dart';

class MatchmakingPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const MatchmakingPage());
  const MatchmakingPage({super.key});

  @override
  State<MatchmakingPage> createState() => _MatchmakingPageState();
}

class _MatchmakingPageState extends State<MatchmakingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Matchmaking'),
        // Anda bisa menambahkan aksi atau tombol di sini nantinya
      ),
      body: const Center(
        child: Text('Halaman Matchmaking Kosong', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
