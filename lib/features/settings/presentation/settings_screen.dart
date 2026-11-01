import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../data/providers.dart';
import '../../../data/services/backup_service.dart';
import '../../follow_ups/services/battery_optimization_service.dart';
import '../providers/settings_providers.dart';
import '../services/app_preferences_service.dart';

final _backupServiceProvider = Provider<BackupService>((ref) {
  return BackupService(ref.watch(appDatabaseProvider));
});

/// App preferences, backup/restore, and destructive data actions.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final countryCode = ref.watch(defaultCountryCodeProvider);
    final duplicatePolicy = ref.watch(duplicatePolicyProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const _SectionHeader('Appearance'),
          RadioListTile<ThemeMode>(
            title: const Text('System'),
            value: ThemeMode.system,
            groupValue: themeMode,
            onChanged: (m) => ref.read(themeModeProvider.notifier).setMode(m!),
          ),
          RadioListTile<ThemeMode>(
            title: const Text('Light'),
            value: ThemeMode.light,
            groupValue: themeMode,
            onChanged: (m) => ref.read(themeModeProvider.notifier).setMode(m!),
          ),
          RadioListTile<ThemeMode>(
            title: const Text('Dark'),
            value: ThemeMode.dark,
            groupValue: themeMode,
            onChanged: (m) => ref.read(themeModeProvider.notifier).setMode(m!),
          ),
          const _SectionHeader('Calling'),
          ListTile(
            title: const Text('Default country code'),
            subtitle: Text(countryCode == null || countryCode.isEmpty
                ? 'Not set'
                : '+$countryCode'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _editCountryCode(context, ref, countryCode),
          ),
          const _SectionHeader('Import'),
          ListTile(
            title: const Text('Duplicate handling'),
            subtitle: Text(_policyLabel(duplicatePolicy)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _pickDuplicatePolicy(context, ref, duplicatePolicy),
          ),
          ListTile(
            leading: const Icon(Icons.battery_charging_full_outlined),
            title: const Text('Allow reminders to ignore battery optimization'),
            subtitle: const Text(
              'Some phones silently kill scheduled reminders unless this is allowed',
            ),
            onTap: () => _requestBatteryExemption(context),
          ),
          const _SectionHeader('Backup'),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Text(
              'Android also backs up this data automatically to your Google '
              'account over time, but that can take up to a day and depends '
              'on your device settings. For an instant, guaranteed copy '
              '(e.g. right before uninstalling), use Export below and save '
              'it to Downloads, Drive, or another app.',
              style: TextStyle(fontSize: 12),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.upload_outlined),
            title: const Text('Export all data'),
            subtitle: const Text('Save a JSON backup of all leads, lists, and history'),
            onTap: () => _exportBackup(context, ref),
          ),
          ListTile(
            leading: const Icon(Icons.download_outlined),
            title: const Text('Import backup'),
            subtitle: const Text('Restore from a previously exported backup file'),
            onTap: () => _importBackup(context, ref),
          ),
          const _SectionHeader('Danger Zone'),
          ListTile(
            leading: Icon(Icons.delete_forever_outlined, color: Theme.of(context).colorScheme.error),
            title: Text('Clear all application data',
                style: TextStyle(color: Theme.of(context).colorScheme.error)),
            onTap: () => _clearAllData(context, ref),
          ),
          const _SectionHeader('About'),
          const ListTile(
            title: Text('MyLeads'),
            subtitle: Text('Version 1.0.0 • All data stays on this device'),
          ),
        ],
      ),
    );
  }

  String _policyLabel(DuplicatePolicy policy) {
    switch (policy) {
      case DuplicatePolicy.askEachTime:
        return 'Ask each time';
      case DuplicatePolicy.skipDuplicates:
        return 'Skip duplicates automatically';
      case DuplicatePolicy.importAnyway:
        return 'Import anyway';
    }
  }

  Future<void> _editCountryCode(
    BuildContext context,
    WidgetRef ref,
    String? current,
  ) async {
    final controller = TextEditingController(text: current);
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Default Country Code'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(hintText: 'e.g. 91 for India'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (result != null) {
      await ref.read(defaultCountryCodeProvider.notifier).setCode(result);
    }
  }

  Future<void> _pickDuplicatePolicy(
    BuildContext context,
    WidgetRef ref,
    DuplicatePolicy current,
  ) async {
    final selected = await showModalBottomSheet<DuplicatePolicy>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: DuplicatePolicy.values
              .map((p) => RadioListTile<DuplicatePolicy>(
                    value: p,
                    groupValue: current,
                    title: Text(_policyLabel(p)),
                    onChanged: (v) => Navigator.of(ctx).pop(v),
                  ))
              .toList(),
        ),
      ),
    );
    if (selected != null) {
      await ref.read(duplicatePolicyProvider.notifier).setPolicy(selected);
    }
  }

  Future<void> _requestBatteryExemption(BuildContext context) async {
    final alreadyExempt =
        await BatteryOptimizationService.isIgnoringBatteryOptimizations();
    if (alreadyExempt) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Already allowed - this app is exempt from battery optimization'),
          ),
        );
      }
      return;
    }
    await BatteryOptimizationService.requestIgnoreBatteryOptimizations();
  }

  Future<void> _exportBackup(BuildContext context, WidgetRef ref) async {
    try {
      final service = ref.read(_backupServiceProvider);
      final bytes = await service.buildBackupBytes();
      final fileName =
          'myleads_backup_${DateTime.now().millisecondsSinceEpoch}.json';

      final savedPath = await FilePicker.platform.saveFile(
        dialogTitle: 'Save backup',
        fileName: fileName,
        bytes: bytes,
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (savedPath == null) return; // user cancelled

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Backup saved')),
        );
      }
    } catch (_) {
      // Fall back to the share sheet if direct saving isn't supported.
      try {
        final file = await ref.read(_backupServiceProvider).exportBackupToFile();
        await Share.shareXFiles([XFile(file.path)]);
      } catch (_) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not export a backup')),
          );
        }
      }
    }
  }

  Future<void> _importBackup(BuildContext context, WidgetRef ref) async {
    final path = await BackupService.pickBackupFilePath();
    if (path == null) return;

    final service = ref.read(_backupServiceProvider);
    final preview = await service.validateBackupFile(path);
    if (preview == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('This file is not a valid MyLeads backup')),
        );
      }
      return;
    }

    if (!context.mounted) return;
    final listCount = (preview['leadLists'] as List).length;
    final leadCount = (preview['leads'] as List).length;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Restore Backup?'),
        content: Text(
          'This backup contains $listCount lists and $leadCount leads. '
          'Restoring will replace all data currently on this device. '
          'This cannot be undone.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Restore'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await service.restoreFromBackup(preview);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Backup restored successfully')),
        );
      }
    }
  }

  Future<void> _clearAllData(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear All Data?'),
        content: const Text(
          'This will permanently delete every list, lead, and call history '
          'record on this device. This cannot be undone.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Theme.of(ctx).colorScheme.error),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Delete Everything'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(_backupServiceProvider).clearAllData();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('All application data has been cleared')),
        );
      }
    }
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .labelLarge
            ?.copyWith(color: Theme.of(context).colorScheme.primary),
      ),
    );
  }
}
