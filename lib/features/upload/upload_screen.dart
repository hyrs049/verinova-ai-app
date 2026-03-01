import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../dashboard/dashboard_screen.dart';

class UploadScreen extends ConsumerStatefulWidget {
  const UploadScreen({super.key});

  @override
  ConsumerState<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends ConsumerState<UploadScreen> {
  bool isLoading = false;
  String statusMessage = "Finansal veri dosyanızı yükleyin";

  Future<void> simulateUpload() async {
    setState(() {
      isLoading = true;
      statusMessage = "Dosya yükleniyor...";
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      statusMessage = "Veri temizleniyor...";
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      statusMessage = "Blockchain hash oluşturuluyor...";
    });

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Veri Yükleme")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.upload_file, size: 80),
              const SizedBox(height: 20),
              Text(
                statusMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 30),
              if (isLoading)
                const CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: simulateUpload,
                  child: const Text("Dosya Yükle"),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
