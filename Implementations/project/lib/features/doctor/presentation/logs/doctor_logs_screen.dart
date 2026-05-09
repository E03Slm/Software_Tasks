import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/audit_provider.dart';
import '../../../../core/theme/app_theme.dart';

class DoctorLogsScreen extends ConsumerStatefulWidget {
  const DoctorLogsScreen({super.key});

  @override
  ConsumerState<DoctorLogsScreen> createState() => _DoctorLogsScreenState();
}

class _DoctorLogsScreenState extends ConsumerState<DoctorLogsScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final logsAsync = ref.watch(auditLogListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AUDIT LOGS'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(auditLogListProvider.notifier).refresh(),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(spaceMd),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Filter by action (e.g., CREATE_DRUG)',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),
          Expanded(
            child: logsAsync.when(
              data: (logs) {
                final filteredLogs = logs.where((log) => 
                  log.action.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                  log.entityType.toLowerCase().contains(_searchQuery.toLowerCase())
                ).toList();

                if (filteredLogs.isEmpty) {
                  return const Center(child: Text('No matching logs found.'));
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: spaceMd),
                  itemCount: filteredLogs.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final log = filteredLogs[index];
                    return ExpansionTile(
                      leading: _getIconForAction(log.action),
                      title: Text(
                        log.action.replaceAll('_', ' '),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '${log.entityType} • ${DateFormat('yyyy-MM-dd HH:mm:ss').format(log.timestamp)}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(spaceMd),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Clinician: ${log.userName ?? log.userId}', 
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                              Text('Target: ${log.entityType.replaceAll('_', ' ').toUpperCase()} ${log.entityName != null ? "(${log.entityName})" : ""}', 
                                style: const TextStyle(fontSize: 12)),
                              if (log.ipAddress != null) Text('IP Address: ${log.ipAddress}', style: const TextStyle(fontSize: 12)),
                              const SizedBox(height: 8),
                              if (log.oldValue != null) ...[
                                const Text('OLD VALUE:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(log.oldValue!, style: const TextStyle(fontFamily: 'monospace', fontSize: 10)),
                                ),
                                const SizedBox(height: 8),
                              ],
                              if (log.newValue != null) ...[
                                const Text('NEW VALUE:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(log.newValue!, style: const TextStyle(fontFamily: 'monospace', fontSize: 10)),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error loading logs: $err')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getIconForAction(String action) {
    if (action.contains('CREATE')) return const Icon(Icons.add_circle_outline, color: Colors.green);
    if (action.contains('UPDATE')) return const Icon(Icons.edit_note, color: Colors.blue);
    if (action.contains('DELETE')) return const Icon(Icons.delete_forever, color: Colors.red);
    if (action.contains('LOGIN')) return const Icon(Icons.login, color: Colors.orange);
    return const Icon(Icons.history);
  }
}
