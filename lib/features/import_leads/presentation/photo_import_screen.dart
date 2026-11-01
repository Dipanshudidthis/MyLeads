import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/utils/phone_utils.dart';
import '../../settings/providers/settings_providers.dart';
import '../providers/import_review_provider.dart';
import 'import_review_screen.dart';

/// Capture or choose a photo of a printed list and extract numbers using
/// on-device OCR. The photo itself is never uploaded anywhere.
class PhotoImportScreen extends ConsumerStatefulWidget {
  const PhotoImportScreen({super.key, this.targetListId});

  final String? targetListId;

  @override
  ConsumerState<PhotoImportScreen> createState() => _PhotoImportScreenState();
}

class _PhotoImportScreenState extends ConsumerState<PhotoImportScreen> {
  File? _image;
  bool _processing = false;
  String? _error;

  Future<void> _pickImage(ImageSource source) async {
    setState(() => _error = null);
    try {
      final picked = await ImagePicker().pickImage(
        source: source,
        imageQuality: 90,
      );
      if (picked == null) return;
      setState(() => _image = File(picked.path));
      await _runOcr();
    } catch (_) {
      setState(() => _error = 'Could not access the camera or photo library');
    }
  }

  Future<void> _runOcr() async {
    final image = _image;
    if (image == null) return;

    setState(() {
      _processing = true;
      _error = null;
    });

    final recognizer = TextRecognizer(script: TextRecognitionScript.latin);
    try {
      final input = InputImage.fromFile(image);
      final result = await recognizer.processImage(input);
      final text = result.text;

      if (text.trim().isEmpty) {
        setState(() => _error = 'No phone numbers found in this image');
        return;
      }

      final countryCode = ref.read(defaultCountryCodeProvider);
      final records = PhoneUtils.extractFromText(
        text,
        defaultCountryCode: countryCode,
      );

      if (records.isEmpty) {
        setState(() => _error = 'No phone numbers found in this image');
        return;
      }

      ref.read(importReviewProvider.notifier).loadFromExtracted(records);

      if (!mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ImportReviewScreen(targetListId: widget.targetListId),
        ),
      );
    } catch (_) {
      setState(() => _error = 'Could not read text from this image');
    } finally {
      await recognizer.close();
      if (mounted) setState(() => _processing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan a Photo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: _image != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(_image!, fit: BoxFit.contain),
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.image_outlined,
                            size: 64,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                          const SizedBox(height: 12),
                          const Text('Choose or capture a photo of your list'),
                        ],
                      ),
              ),
            ),
            if (_processing) const LinearProgressIndicator(),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _processing ? null : () => _pickImage(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt_outlined),
                    label: const Text('Camera'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _processing ? null : () => _pickImage(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library_outlined),
                    label: const Text('Gallery'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
