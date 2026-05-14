import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../nurse_providers.dart';
import '../../../core/theme.dart';

class AlarmPanelScreen extends ConsumerWidget {
  const AlarmPanelScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alarmsAsync = ref.watch(activeAlarmsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Active Alarms')),
      body: alarmsAsync.when(
        data: (alarms) {
          if (alarms.isEmpty) {
            return const Center(child: Text('No active alarms'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(spaceMd),
            itemCount: alarms.length,
            separatorBuilder: (_, __) => const SizedBox(height: spaceSm),
            itemBuilder: (context, index) {
              final alarm = alarms[index];
              return _AlarmCard(alarm: alarm);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}

class _AlarmCard extends StatelessWidget {
  final Map<String, dynamic> alarm;
  const _AlarmCard({required this.alarm});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.red[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(spaceSm),
        side: const BorderSide(color: Colors.red),
      ),
      child: ListTile(
        leading: const Icon(Icons.warning, color: Colors.red),
        title: Text(
          alarm['alarm_id'] ?? 'System Alarm',
          style: bodyStyle.copyWith(fontWeight: FontWeight.bold, color: Colors.red),
        ),
        subtitle: Text(
          'Triggered at: ${alarm['alarm_time']}',
          style: captionStyle,
        ),
        trailing: TextButton(
          onPressed: () {
            // Acknowledge logic
          },
          child: const Text('ACKNOWLEDGE'),
        ),
      ),
    );
  }
}
