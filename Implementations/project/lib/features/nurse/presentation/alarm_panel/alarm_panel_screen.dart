import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/infusion_provider.dart';
import '../providers/audit_log_provider.dart';
import '../../domain/models/alarm.dart';
import '../../../../core/theme/nurse_theme.dart';

class AlarmPanelScreen extends ConsumerStatefulWidget {
  const AlarmPanelScreen({super.key});

  @override
  ConsumerState<AlarmPanelScreen> createState() => _AlarmPanelScreenState();
}

class _AlarmPanelScreenState extends ConsumerState<AlarmPanelScreen> {
  bool showActiveOnly = true;

  @override
  Widget build(BuildContext context) {
    final historyAsync = ref.watch(alarmHistoryProvider);
    final nurseColors = Theme.of(context).extension<NurseColors>()!;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('ALARMS & ALERTS'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.white,
            child: SegmentedButton<bool>(
              segments: const [
                ButtonSegment<bool>(
                  value: true,
                  label: Text('ACTIVE'),
                  icon: Icon(Icons.notifications_active),
                ),
                ButtonSegment<bool>(
                  value: false,
                  label: Text('HISTORY'),
                  icon: Icon(Icons.history),
                ),
              ],
              selected: {showActiveOnly},
              onSelectionChanged: (Set<bool> newSelection) {
                setState(() {
                  showActiveOnly = newSelection.first;
                });
              },
              style: SegmentedButton.styleFrom(
                selectedBackgroundColor: nurseColors.severityWarning.withValues(alpha: 0.1),
                selectedForegroundColor: nurseColors.severityWarning,
                side: BorderSide(color: nurseColors.severityWarning.withValues(alpha: 0.2)),
              ),
            ),
          ),
        ),
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
        data: (alarms) {
          final filteredAlarms = showActiveOnly 
              ? alarms.where((a) => !a.ackRes).toList()
              : alarms;

          if (filteredAlarms.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    showActiveOnly ? Icons.notifications_off_outlined : Icons.history_toggle_off,
                    size: 64,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    showActiveOnly ? 'No active alarms' : 'No history found',
                    style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filteredAlarms.length,
            itemBuilder: (context, index) {
              final alarm = filteredAlarms[index];
              final severity = (alarm.definition?.severity ?? 'low').toLowerCase();
              final isCritical = alarm.isHighSeverity;

              return Card(
                elevation: 0,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: _getSeverityColor(severity, nurseColors).withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                color: _getSeverityColor(severity, nurseColors).withValues(alpha: 0.05),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            isCritical ? Icons.warning_rounded : Icons.info_outline_rounded,
                            color: _getSeverityColor(severity, nurseColors),
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              alarm.definition?.name.replaceAll('_', ' ') ?? 'SYSTEM ALERT',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: _getSeverityColor(severity, nurseColors),
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Text(
                            DateFormat('HH:mm:ss').format(alarm.alarmTime),
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        alarm.definition?.description ?? 'System-generated clinical alert requires attention.',
                        style: TextStyle(fontSize: 13, color: Colors.grey.shade800),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (!alarm.ackRes)
                            ElevatedButton(
                              onPressed: () async {
                                if (isCritical) {
                                  await ref.read(alarmProvider.notifier).resolve(alarm.id);
                                } else {
                                  await ref.read(alarmProvider.notifier).acknowledge(alarm.id);
                                }
                                ref.invalidate(alarmHistoryProvider);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _getSeverityColor(severity, nurseColors),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(horizontal: 24),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              child: Text(isCritical ? 'RESOLVE' : 'ACKNOWLEDGE'),
                            )
                          else
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.green.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.check_circle, color: Colors.green, size: 16),
                                  SizedBox(width: 8),
                                  Text(
                                    'HANDLED',
                                    style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 10),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
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
