import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../doctor_repository.dart';
import '../../../core/theme.dart';

class LogsViewerScreen extends ConsumerWidget {
  const LogsViewerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logsAsync = ref.watch(clinicalAuditLogsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Clinical Audit Logs')),
      body: logsAsync.when(
        data: (logs) => ListView.separated(
          padding: const EdgeInsets.all(spaceMd),
          itemCount: logs.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (context, index) {
            final log = logs[index];
            final isCritical = log['action']?.toString().contains('HARD_LIMIT') ?? false;
            
            return ListTile(
              leading: Icon(
                isCritical ? Icons.warning : Icons.history_toggle_off, 
                color: isCritical ? Colors.red : Colors.blue
              ),
              title: Text(
                log['action'] ?? 'Unknown Action', 
                style: bodyStyle.copyWith(fontWeight: FontWeight.bold)
              ),
              subtitle: Text(
                'Entity: ${log['entity_type']} • ID: ${log['entity_id']}', 
                style: captionStyle
              ),
              trailing: Text(
                log['timestamp'] != null 
                  ? DateTime.parse(log['timestamp']).toString().substring(11, 16) 
                  : '--:--', 
                style: captionStyle
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}

class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportsAsync = ref.watch(clinicalReportsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Clinical Analytics')),
      body: reportsAsync.when(
        data: (reports) => reports.isEmpty 
          ? _buildEmptyState(context, ref)
          : ListView.separated(
              padding: const EdgeInsets.all(spaceMd),
              itemCount: reports.length,
              separatorBuilder: (_, __) => const SizedBox(height: spaceSm),
              itemBuilder: (context, index) {
                final report = reports[index];
                return ListTile(
                  tileColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(spaceSm)),
                  leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
                  title: Text('${report['type']} Report', style: bodyStyle.copyWith(fontWeight: FontWeight.bold)),
                  subtitle: Text('Generated at: ${report['generated_at'].toString().substring(0, 16)}', style: captionStyle),
                  trailing: const Icon(Icons.download_outlined),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Downloading report...')));
                  },
                );
              },
            ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _generateNewReport(context, ref),
        label: const Text('GENERATE REPORT', style: TextStyle(color: Colors.white)),
        icon: const Icon(Icons.add, color: Colors.white),
        backgroundColor: const Color(0xFF00685D),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.assessment, size: 64, color: Color(0xFF00685D)),
          const SizedBox(height: spaceMd),
          Text('No Reports Generated Yet', style: titleStyle),
          const SizedBox(height: spaceSm),
          ElevatedButton.icon(
            onPressed: () => _generateNewReport(context, ref),
            icon: const Icon(Icons.picture_as_pdf),
            label: const Text('GENERATE DAILY SUMMARY'),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00685D), foregroundColor: Colors.white),
          ),
        ],
      ),
    );
  }

  Future<void> _generateNewReport(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(doctorRepositoryProvider.notifier).generateReport(type: 'Clinical_Audit');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Report generated successfully!')));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error generating report: $e')));
      }
    }
  }
}
