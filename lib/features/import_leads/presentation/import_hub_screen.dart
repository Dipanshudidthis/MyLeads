import 'package:flutter/material.dart';

import 'paste_import_screen.dart';
import 'photo_import_screen.dart';
import 'file_import_screen.dart';

/// Entry point for the three supported import methods.
class ImportHubScreen extends StatelessWidget {
  const ImportHubScreen({super.key, this.targetListId});

  /// When set, imported leads are saved directly into this list.
  final String? targetListId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Import Leads')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _ImportOptionCard(
            icon: Icons.content_paste_rounded,
            title: 'Paste Numbers',
            subtitle:
                'Paste text copied from documents, spreadsheets, or websites',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => PasteImportScreen(targetListId: targetListId),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _ImportOptionCard(
            icon: Icons.photo_camera_outlined,
            title: 'Scan a Photo',
            subtitle: 'Capture or choose a photo of a printed list',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => PhotoImportScreen(targetListId: targetListId),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _ImportOptionCard(
            icon: Icons.table_chart_outlined,
            title: 'Import a File',
            subtitle: 'Import a CSV spreadsheet of names and phone numbers',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => FileImportScreen(targetListId: targetListId),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ImportOptionCard extends StatelessWidget {
  const _ImportOptionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: scheme.primaryContainer,
                child: Icon(icon, color: scheme.onPrimaryContainer),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }
}
