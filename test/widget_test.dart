import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/app.dart';
import 'package:flutter_application_1/features/settings/providers/settings_providers.dart';
import 'package:flutter_application_1/features/settings/services/app_preferences_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('App shows the home dashboard with bottom navigation', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await AppPreferencesService.create();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appPreferencesServiceProvider.overrideWithValue(prefs)],
        child: const MaterialApp(home: AppShell()),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('MyLeads'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Leads'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
  });
}
