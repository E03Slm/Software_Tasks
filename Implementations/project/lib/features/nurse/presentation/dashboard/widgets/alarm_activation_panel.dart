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
            const SizedBox(height: 16),
            Consumer(
              builder: (context, ref, child) {
                final powerState = ref.watch(batteryProvider);
                return SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      if (powerState.isACConnected) {
                        ref.read(batteryProvider.notifier).disconnectAC(ref.read(infusionProvider).id);
                      } else {
                        ref.read(batteryProvider.notifier).connectAC();
                      }
                    },
                    icon: Icon(powerState.isACConnected ? Icons.power_off : Icons.power),
                    label: Text(powerState.isACConnected ? 'Disconnect AC Power' : 'Connect AC Power'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: powerState.isACConnected ? Colors.red : Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            definitionsAsync.when(
              data: (definitions) {
                final filteredDefs = definitions.where((d) {
                  final lower = d.name.toLowerCase();
                  return !lower.contains('soft limit') && !lower.contains('battery');
                }).toList();

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredDefs.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final def = filteredDefs[index];
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
                );
              },
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
