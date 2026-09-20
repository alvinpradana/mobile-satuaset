import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'features/main/presentation/screens/main_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: SatuAsetApp(),
    ),
  );
}

class SatuAsetApp extends StatelessWidget {
  const SatuAsetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SatuAset Dashboard',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const MainScreen(),
    );
  }
}
