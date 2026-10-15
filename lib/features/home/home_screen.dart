import 'package:app_ran_san_moi/data/services/storage_service.dart';
import 'package:app_ran_san_moi/features/game/game_screen.dart';
import 'package:app_ran_san_moi/features/home/widgets/home_header.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.storage});

  final StorageService storage;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> _openGame() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => GameScreen(storage: widget.storage),
      ),
    );
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                HomeHeader(highScore: widget.storage.highScore),
                const SizedBox(height: 48),
                ElevatedButton(
                  autofocus: true,
                  onPressed: _openGame,
                  child: const Text('PLAY'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
