import 'package:flutter/material.dart';

import '../../../../core/constants/lead_status.dart';
import '../../../../data/database/app_database.dart';
import '../../../calling/services/external_action_launcher.dart';
import '../lead_details_screen.dart';

/// Compact lead row with quick call/WhatsApp actions, used by any screen
/// that lists leads (a single list's workspace, or an all-leads filter).
class LeadRow extends StatelessWidget {
  const LeadRow({super.key, required this.lead});

  final Lead lead;

  @override
  Widget build(BuildContext context) {
    final status = LeadStatus.fromDb(lead.status);
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => LeadDetailsScreen(leadId: lead.id)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lead.name?.isNotEmpty == true ? lead.name! : 'Unknown Contact',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 2),
                    Text(lead.phoneNumber, style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        LeadStatusBadge(status: status),
                        if (lead.nextFollowUpAt != null) ...[
                          const SizedBox(width: 6),
                          Icon(Icons.alarm_outlined,
                              size: 14, color: Theme.of(context).colorScheme.tertiary),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.call_outlined),
                onPressed: () => ExternalActionLauncher.callNumber(
                  lead.normalizedPhoneNumber,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chat_outlined),
                onPressed: () async {
                  final result = await ExternalActionLauncher.openWhatsApp(
                    lead.normalizedPhoneNumber,
                  );
                  if (result != LaunchResult.success && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('WhatsApp is not available on this device.')),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LeadStatusBadge extends StatelessWidget {
  const LeadStatusBadge({super.key, required this.status});

  final LeadStatus status;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: scheme.secondaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status.label,
        style: TextStyle(fontSize: 11, color: scheme.onSecondaryContainer),
      ),
    );
  }
}
