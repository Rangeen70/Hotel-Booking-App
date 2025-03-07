import 'package:flutter/material.dart';

import 'app/app.dart';
import 'app/di/di.dart';
import 'core/network/hive_service.dart';

// Initialize once in the very beginning
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Hive Database
  await HiveService().init();
  await initDependencies(); // Initialize dependencies
  runApp(
    App(),
  );
}
