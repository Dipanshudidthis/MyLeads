import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/theme/app_theme.dart';
import 'features/settings/providers/settings_providers.dart';
import 'features/settings/services/app_preferences_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final preferences = await AppPreferencesService.create();

  runApp(
    ProviderScope(
      overrides: [
        appPreferencesServiceProvider.overrideWithValue(preferences),
      ],
      child: const LeadFlowApp(),
    ),
  );
}

class LeadFlowApp extends ConsumerWidget {
  const LeadFlowApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'MyLeads',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      home: const AppShell(),
    );
  }
}
