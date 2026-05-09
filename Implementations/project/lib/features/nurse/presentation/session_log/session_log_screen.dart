import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:project/features/nurse/presentation/providers/infusion_provider.dart';
import 'package:project/features/nurse/presentation/providers/audit_log_provider.dart';
import 'package:project/features/doctor/data/repositories/audit_repository.dart';
import 'package:project/features/doctor/domain/models/audit_log.dart';
import 'package:project/core/theme/nurse_theme.dart';


class SessionLogScreen extends ConsumerWidget {
  const SessionLogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logsAsync = ref.watch(sessionLogsProvider);
    // ignore: unused_local_variable
    final nurseColors = Theme.of(context).extension<NurseColors>()!;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('SESSION AUDIT TRAIL'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(sessionLogsProvider),
          ),
        ],
      ),
      body: logsAsync.when(
        data: (logs) => logs.isEmpty
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.history_toggle_off, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text('No activity recorded for this session', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: logs.length,
                itemBuilder: (context, index) {
                  final log = logs[index];
                  final isLast = index == logs.length - 1;

                  return IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Timeline line and dot
                        Column(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: _getActionColor(log.action),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                                boxShadow: [
                                  BoxShadow(
                                    color: _getActionColor(log.action).withValues(alpha: 0.3),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                            ),
                            if (!isLast)
                              Expanded(
                                child: Container(
                                  width: 2,
                                  color: Colors.grey.shade300,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        // Content card
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 24),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      log.action.replaceAll('_', ' '),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: _getActionColor(log.action),
                                      ),
                                    ),
                                    Text(
                                      DateFormat('HH:mm:ss').format(log.timestamp),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                if (log.newValue != null && log.newValue != '{}')
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade50,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      log.newValue ?? '',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontFamily: 'monospace',
                                        color: Colors.blueGrey.shade700,
                                      ),
                                    ),
                                  ),
                                if (log.oldValue != null && log.oldValue != '{}')
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      'Modified from: ${log.oldValue}',
                                      style: TextStyle(fontSize: 10, color: Colors.grey.shade400),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Color _getActionColor(String action) {
    if (action.contains('START')) return Colors.green;
    if (action.contains('STOP') || action.contains('EMERGENCY')) return Colors.red;
    if (action.contains('ALARM')) return Colors.orange;
    return Colors.blue;
  }
}
