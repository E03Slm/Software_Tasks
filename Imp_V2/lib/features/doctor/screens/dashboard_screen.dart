import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../doctor_repository.dart';
import '../../../core/theme.dart';

class DoctorDashboardScreen extends ConsumerWidget {
  const DoctorDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(doctorDashboardStatsProvider);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(spaceMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Clinical Overview', style: titleStyle.copyWith(fontSize: 24)),
            const SizedBox(height: spaceMd),
            
            // Stats Grid
            statsAsync.when(
              data: (stats) => GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: spaceMd,
                crossAxisSpacing: spaceMd,
                childAspectRatio: 1.5,
                children: [
                  _StatCard(label: 'ACTIVE DRUGS', value: '${stats['active_drugs']}', icon: Icons.medication, color: const Color(0xFF00685D)),
                  _StatCard(label: 'TOTAL SESSIONS', value: '${stats['total_sessions']}', icon: Icons.monitor_heart, color: Colors.blue),
                  _StatCard(label: 'PENDING ALARMS', value: '${stats['pending_alarms']}', icon: Icons.warning, color: Colors.red),
                  _StatCard(label: 'AUDIT EVENTS', value: 'Live', icon: Icons.list_alt, color: Colors.amber),
                ],
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
            const SizedBox(height: spaceLg),

            Text('Recent System Activity', style: titleStyle),
            const SizedBox(height: spaceSm),
            const _RecentActivityList(),
          ],
        ),
      ),
    );
  }
}

class _RecentActivityList extends ConsumerWidget {
  const _RecentActivityList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logsAsync = ref.watch(clinicalAuditLogsProvider);

    return logsAsync.when(
      data: (logs) => Card(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(spaceMd)),
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: logs.length > 5 ? 5 : logs.length,
          separatorBuilder: (_, __) => const Divider(indent: 16, endIndent: 16),
          itemBuilder: (context, index) {
            final log = logs[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: const Color(0xFFE0F2F1), 
                child: Icon(log['action'].toString().contains('UPDATE') ? Icons.edit : Icons.add, color: const Color(0xFF00685D), size: 18)
              ),
              title: Text(log['action'], style: bodyStyle.copyWith(fontWeight: FontWeight.bold)),
              subtitle: Text('${log['entity_type']} updated', style: captionStyle),
              trailing: Text(log['timestamp'].toString().substring(11, 16), style: captionStyle),
            );
          },
        ),
      ),
      loading: () => const SizedBox(height: 100, child: Center(child: CircularProgressIndicator())),
      error: (err, stack) => Text('Error loading activity: $err'),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(spaceMd)),
      child: Padding(
        padding: const EdgeInsets.all(spaceMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: spaceSm),
            Text(value, style: dataDisplay.copyWith(color: color)),
            Text(label, style: labelCaps.copyWith(fontSize: 10)),
          ],
        ),
      ),
    );
  }
}
