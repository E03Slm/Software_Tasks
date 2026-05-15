import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/infusion_provider.dart';
import '../providers/audit_log_provider.dart';
import '../../domain/models/alarm.dart';
import '../../../../core/theme/nurse_theme.dart';

class AlarmPanelScreen extends ConsumerWidget {
  const AlarmPanelScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(alarmHistoryProvider);
    final nurseColors = Theme.of(context).extension<NurseColors>()!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ALARM HISTORY'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(alarmHistoryProvider);
            },
          ),
        ],
      ),
      body: historyAsync.when(
        data: (alarms) => alarms.isEmpty
            ? const Center(child: Text('No active or recent alarms found for this session'))
            : ListView.builder(
                itemCount: alarms.length,
                itemBuilder: (context, index) {
                  final alarm = alarms[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    color: _getSeverityColor(alarm.severity, nurseColors).withValues(alpha: 0.1),
                    child: ListTile(
                      leading: Icon(
                        Icons.warning_amber_rounded,
                        color: _getSeverityColor(alarm.severity, nurseColors),
                      ),
                      title: Text(alarm.type.replaceAll('_', ' ')),
                      subtitle: Text('Time: ${DateFormat('HH:mm:ss').format(alarm.timestamp)}\n${alarm.description ?? 'System-generated alert'}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (!alarm.acknowledged && 
                              alarm.severity.toLowerCase() != 'high' && 
                              alarm.severity.toLowerCase() != 'critical')
                            ElevatedButton(
                              onPressed: () async {
                                await ref.read(alarmProvider.notifier).acknowledge(alarm.id);
                                ref.invalidate(alarmHistoryProvider);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _getSeverityColor(alarm.severity, nurseColors),
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('ACKNOWLEDGE'),
                            )
                          else if (alarm.acknowledged)
                            const Icon(Icons.check_circle, color: Colors.green),
                          
                          const SizedBox(width: 8),
                          
                          if ((alarm.severity.toLowerCase() == 'high' || alarm.severity.toLowerCase() == 'critical'))
                            if (!alarm.resolved)
                              ElevatedButton(
                                onPressed: () async {
                                  await ref.read(alarmProvider.notifier).resolve(alarm.id);
                                  ref.invalidate(alarmHistoryProvider);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('RESOLVE'),
                              )
                            else
                              const Icon(Icons.verified, color: Colors.blue),
                        ],
                      ),
                    ),
                  );
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Color _getSeverityColor(String severity, NurseColors colors) {
    switch (severity.toLowerCase()) {
      case 'critical':
      case 'high':
        return colors.severityCritical;
      case 'warning':
      case 'medium':
        return colors.severityWarning;
      default:
        return colors.severityInfo;
    }
  }
}
