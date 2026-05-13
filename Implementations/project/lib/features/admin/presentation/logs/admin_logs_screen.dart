import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/admin_providers.dart';

class AdminLogsScreen extends ConsumerStatefulWidget {
  const AdminLogsScreen({super.key});

  @override
  ConsumerState<AdminLogsScreen> createState() => _AdminLogsScreenState();
}

class _AdminLogsScreenState extends ConsumerState<AdminLogsScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final logsAsync = ref.watch(adminAuditLogsProvider);

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by action, user, or entity...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),
          Expanded(
            child: logsAsync.when(
              data: (logs) {
                final filteredLogs = logs.where((log) => 
                  log.action.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                  log.entityType.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                  (log.userName?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false)
                ).toList();

                if (filteredLogs.isEmpty) {
                  return const Center(child: Text('No matching logs found.'));
                }

                return ListView.separated(
                  itemCount: filteredLogs.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
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
                        style: const TextStyle(fontSize: 12),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('User: ${log.userName ?? log.userId}', 
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                              Text('Entity ID: ${log.entityId}', style: const TextStyle(fontSize: 12)),
                              if (log.ipAddress != null) Text('IP Address: ${log.ipAddress}', style: const TextStyle(fontSize: 12)),
                              const SizedBox(height: 12),
                              if (log.oldValue != '{}') ...[
                                const Text('OLD DATA:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(log.oldValue ?? '{}', style: const TextStyle(fontFamily: 'monospace', fontSize: 11)),
                                ),
                                const SizedBox(height: 8),
                              ],
                              if (log.newValue != '{}') ...[
                                const Text('NEW DATA:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(log.newValue ?? '{}', style: const TextStyle(fontFamily: 'monospace', fontSize: 11)),
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
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getIconForAction(String action) {
    if (action.contains('CREATE')) return const Icon(Icons.add_circle, color: Colors.green);
    if (action.contains('UPDATE')) return const Icon(Icons.edit, color: Colors.blue);
    if (action.contains('DELETE')) return const Icon(Icons.delete, color: Colors.red);
    if (action.contains('LOGIN')) return const Icon(Icons.login, color: Colors.orange);
    if (action.contains('ALARM')) return const Icon(Icons.warning, color: Colors.amber);
    return const Icon(Icons.history);
  }
}
