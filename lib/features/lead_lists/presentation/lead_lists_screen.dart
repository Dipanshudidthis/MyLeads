import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/database/app_database.dart';
import '../../../data/providers.dart';
import '../../import_leads/presentation/import_hub_screen.dart';
import '../../leads/presentation/lead_list_workspace_screen.dart';

final leadListsStreamProvider = StreamProvider<List<LeadList>>((ref) {
  return ref.watch(leadListRepositoryProvider).watchAll();
});

/// All lead lists, with create/rename/delete management.
class LeadListsScreen extends ConsumerWidget {
  const LeadListsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listsAsync = ref.watch(leadListsStreamProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Lead Lists')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _createList(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('New List'),
      ),
      body: listsAsync.when(
        data: (lists) {
          if (lists.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.folder_outlined,
                        size: 64, color: Theme.of(context).colorScheme.outline),
                    const SizedBox(height: 16),
                    const Text('No lists yet. Create one to start organizing leads.'),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const ImportHubScreen()),
                      ),
                      icon: const Icon(Icons.file_download_outlined),
                      label: const Text('Import Leads'),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: lists.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final list = lists[index];
              return _LeadListCard(list: list);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => const Center(child: Text('Could not load lists')),
      ),
    );
  }

  Future<void> _createList(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('New List'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'e.g. New Prospects'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(controller.text.trim()),
            child: const Text('Create'),
          ),
        ],
      ),
    );

    if (name == null || name.isEmpty) return;

    final repo = ref.read(leadListRepositoryProvider);
    if (await repo.nameExists(name)) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('A list with this name already exists')),
      );
      return;
    }
    await repo.createList(name);
  }
}

class _LeadListCard extends ConsumerWidget {
  const _LeadListCard({required this.list});

  final LeadList list;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => LeadListWorkspaceScreen(list: list),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(list.name, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(
                      'Updated ${_formatDate(list.updatedAt)}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) => _onMenuSelected(context, ref, value),
                itemBuilder: (context) => const [
                  PopupMenuItem(value: 'rename', child: Text('Rename')),
                  PopupMenuItem(value: 'delete', child: Text('Delete')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onMenuSelected(
    BuildContext context,
    WidgetRef ref,
    String value,
  ) async {
    final repo = ref.read(leadListRepositoryProvider);
    if (value == 'rename') {
      final controller = TextEditingController(text: list.name);
      final newName = await showDialog<String>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Rename List'),
          content: TextField(controller: controller, autofocus: true),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(ctx).pop(controller.text.trim()),
              child: const Text('Save'),
            ),
          ],
        ),
      );
      if (newName != null && newName.isNotEmpty) {
        await repo.renameList(list.id, newName);
      }
    } else if (value == 'delete') {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Delete List?'),
          content: Text(
            'This will permanently delete "${list.name}" and all of its '
            'leads and call history. This cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(ctx).colorScheme.error,
              ),
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Delete'),
            ),
          ],
        ),
      );
      if (confirmed == true) {
        await repo.deleteList(list.id);
      }
    }
  }
}

String _formatDate(DateTime date) {
  return '${date.day}/${date.month}/${date.year}';
}
