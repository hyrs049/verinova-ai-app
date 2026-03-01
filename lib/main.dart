import 'package:flutter/material.dart';
import 'theme/theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:risea/features/upload/upload_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      home: const UploadScreen(),
    );
  }
}
