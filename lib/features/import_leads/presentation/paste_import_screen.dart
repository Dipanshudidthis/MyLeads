import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/phone_utils.dart';
import '../../settings/providers/settings_providers.dart';
import '../providers/import_review_provider.dart';
import 'import_review_screen.dart';

/// Paste free-form text and extract plausible phone numbers from it.
class PasteImportScreen extends ConsumerStatefulWidget {
  const PasteImportScreen({super.key, this.targetListId});

  final String? targetListId;

  @override
  ConsumerState<PasteImportScreen> createState() => _PasteImportScreenState();
}

class _PasteImportScreenState extends ConsumerState<PasteImportScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _extract() {
    final text = _controller.text;
    if (text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Paste some text first')),
      );
      return;
    }

    final countryCode = ref.read(defaultCountryCodeProvider);
    final records = PhoneUtils.extractFromText(
      text,
      defaultCountryCode: countryCode,
    );

    if (records.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No phone numbers found in this text')),
      );
      return;
    }

    ref.read(importReviewProvider.notifier).loadFromExtracted(records);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ImportReviewScreen(targetListId: widget.targetListId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Paste Numbers')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Paste names and phone numbers below. One per line, or '
              'copy directly from a spreadsheet.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: TextField(
                controller: _controller,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  hintText: 'Rahul 9876543210\nPriya, +91 9876543212\n...',
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _extract,
                icon: const Icon(Icons.search_rounded),
                label: const Text('Extract Numbers'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
