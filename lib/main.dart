import 'package:app_ran_san_moi/app.dart';
import 'package:app_ran_san_moi/data/services/storage_service.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = await StorageService.create();
  runApp(App(storage: storage));
}
