import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import '../dashboard/dashboard_screen.dart';
import '../../services/ai_service.dart';

class UploadScreen extends ConsumerStatefulWidget {
  const UploadScreen({super.key});

  @override
  ConsumerState<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends ConsumerState<UploadScreen> {
  final AiService _aiService = AiService();
  bool isLoading = false;
  String statusMessage = "Finansal veri dosyanızı yükleyin";
  String? _fileName;
  Map<String, dynamic>? _analysisResult;

  Future<void> pickAndUpload() async {
    final picked = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
      withData: true,
    );

    if (picked == null) return;

    setState(() {
      isLoading = true;
      _fileName = picked.files.first.name;
      statusMessage = "Dosya yükleniyor...";
    });

    await Future.delayed(const Duration(seconds: 1));
    setState(() => statusMessage = "Veri analiz ediliyor...");

    try {
      final result = await _aiService.uploadCSV(
        picked.files.first.bytes!,
        picked.files.first.name,
      );

      setState(() => statusMessage = "Blockchain hash oluşturuluyor...");
      await Future.delayed(const Duration(seconds: 1));

      setState(() {
        _analysisResult = result;
        isLoading = false;
        statusMessage = "Analiz tamamlandı ✅";
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        statusMessage = "Hata: $e";
      });
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
              if (_fileName != null) ...[
                const SizedBox(height: 8),

                Text(
                  "📄 $_fileName",
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
              const SizedBox(height: 30),
              if (isLoading)
                const CircularProgressIndicator()
              else ...[
                ElevatedButton(
                  onPressed: pickAndUpload,
                  child: const Text("Dosya Seç"),
                ),
                if (_analysisResult != null) ...[
                  const SizedBox(height: 16),
                  // Analiz özeti
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Satır: ${_analysisResult!['row_count']}",
                            style: const TextStyle(fontSize: 15),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Sütunlar: ${(_analysisResult!['columns'] as List).join(', ')}",
                            style: const TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const DashboardScreen(),
                        ),
                      );
                    },
                    child: const Text("Analizi Görüntüle →"),
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}
