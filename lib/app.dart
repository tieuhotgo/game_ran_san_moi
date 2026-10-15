import 'package:app_ran_san_moi/core/theme/app_theme.dart';
import 'package:app_ran_san_moi/data/services/storage_service.dart';
import 'package:app_ran_san_moi/features/game/game_screen.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key, required this.storage});

  final StorageService storage;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Snake',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: GameScreen(storage: storage),
    );
  }
}
