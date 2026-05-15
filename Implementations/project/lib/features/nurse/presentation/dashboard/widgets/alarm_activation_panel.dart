import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/infusion_provider.dart';
import '../../../domain/enums/alarm_type.dart';
import '../../../domain/enums/severity_level.dart';

class AlarmActivationPanel extends ConsumerWidget {
  const AlarmActivationPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(infusionProvider.notifier);
    final definitionsAsync = ref.watch(alarmDefinitionsProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SIMULATION: TRIGGER ALARMS',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Select an alarm to test system response:',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            definitionsAsync.when(
              data: (definitions) => ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: definitions.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final def = definitions[index];
                  return _AlarmTriggerRow(
                    label: '${def.name} (${def.severity})',
                    color: _getColorForSeverity(def.severity),
                    onTap: () => notifier.triggerAlarm(
                      _mapType(def.name), 
                      _mapSeverity(def.severity),
                      definition: def,
                    ),
                  );
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, s) => Text('Error loading alarms: $e', style: const TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }

  Color _getColorForSeverity(String severity) {
    switch (severity.toUpperCase()) {
      case 'CRITICAL':
      case 'HIGH': return Colors.red;
      case 'MEDIUM': return Colors.orange;
      case 'LOW': return Colors.blue;
      default: return Colors.grey;
    }
  }

  AlarmType _mapType(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('occlusion')) return AlarmType.occlusion;
    if (lower.contains('air')) return AlarmType.airInLine;
    if (lower.contains('battery')) return AlarmType.batteryLow;
    if (lower.contains('door')) return AlarmType.manualTraining; // Door open fallback
    if (lower.contains('flow')) return AlarmType.hardLimitExceeded; // Flow error fallback
    return AlarmType.softLimitWarning;
  }

  AlarmSeverity _mapSeverity(String severity) {
    switch (severity.toUpperCase()) {
      case 'CRITICAL': return AlarmSeverity.critical;
      case 'HIGH': return AlarmSeverity.high;
      case 'MEDIUM': return AlarmSeverity.medium;
      case 'LOW': return AlarmSeverity.low;
      default: return AlarmSeverity.low;
    }
  }
}

class _AlarmTriggerRow extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _AlarmTriggerRow({
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(Icons.warning_amber_rounded, color: color),
      title: Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.play_arrow, size: 16),
      onTap: onTap,
    );
  }
}
