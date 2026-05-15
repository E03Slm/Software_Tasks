import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:project/features/admin/presentation/providers/admin_providers.dart';
import 'package:project/core/theme/doctor_theme.dart';

class DoctorSystemLogsScreen extends ConsumerStatefulWidget {
  const DoctorSystemLogsScreen({super.key});

  @override
  ConsumerState<DoctorSystemLogsScreen> createState() => _DoctorSystemLogsScreenState();
}

class _DoctorSystemLogsScreenState extends ConsumerState<DoctorSystemLogsScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final logsAsync = ref.watch(adminAuditLogsProvider);
    final doctorColors = Theme.of(context).extension<DoctorColors>() ?? 
                         doctorTheme.extension<DoctorColors>()!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('SYSTEM-WIDE AUDIT (ADMIN COPY)'),
        backgroundColor: doctorColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            color: doctorColors.primary.withOpacity(0.05),
            child: const Row(
              children: [
                Icon(Icons.info_outline, color: Colors.teal),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'This is a simulation of the Admin Audit View inside the Doctor interface. (Login logs are excluded per policy)',
                    style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search system logs...',
                prefixIcon: const Icon(Icons.search, color: Colors.teal),
                filled: true,
                fillColor: Colors.grey[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.teal.withOpacity(0.1)),
                ),
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),
          Expanded(
            child: logsAsync.when(
              data: (logs) {
                // Filter out LOGIN and LOGOUT actions in the UI as requested for Doctors
                final filteredLogs = logs.where((log) => 
                  !['LOGIN', 'LOGOUT'].contains(log.action.toUpperCase()) &&
                  (log.action.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                  log.entityType.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                  (log.userName?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false))
                ).toList();

                if (filteredLogs.isEmpty) {
                  return const Center(child: Text('No matching system logs found.'));
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
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.teal[800],
                        ),
                      ),
                      subtitle: Text(
                        '${log.entityType} • ${DateFormat('yyyy-MM-dd HH:mm:ss').format(log.timestamp)}',
                        style: const TextStyle(fontSize: 12),
                      ),
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.teal.withOpacity(0.02),
                            border: Border(top: BorderSide(color: Colors.teal.withOpacity(0.05))),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildDetailRow(Icons.person, 'Performer', log.userName ?? log.userId),
                              _buildDetailRow(Icons.fingerprint, 'Entity ID', log.entityId ?? 'N/A'),
                              if (log.ipAddress != null) 
                                _buildDetailRow(Icons.lan, 'IP Address', log.ipAddress!),
                              const SizedBox(height: 12),
                              if (log.oldValue != '{}' && log.oldValue != null) ...[
                                const Text('PREVIOUS STATE', 
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Colors.grey)),
                                const SizedBox(height: 4),
                                _buildDataContainer(log.oldValue!),
                                const SizedBox(height: 12),
                              ],
                              if (log.newValue != '{}' && log.newValue != null) ...[
                                const Text('NEW STATE', 
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Colors.grey)),
                                const SizedBox(height: 4),
                                _buildDataContainer(log.newValue!),
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

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.teal[300]),
          const SizedBox(width: 8),
          Text('$label: ', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildDataContainer(String jsonString) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.03),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
      ),
      child: Text(
        jsonString,
        style: const TextStyle(
          fontFamily: 'monospace',
          fontSize: 11,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _getIconForAction(String action) {
    if (action.contains('CREATE')) return const Icon(Icons.add_circle, color: Colors.green);
    if (action.contains('UPDATE')) return const Icon(Icons.edit, color: Colors.blue);
    if (action.contains('DELETE')) return const Icon(Icons.delete, color: Colors.red);
    if (action.contains('LOGIN')) return const Icon(Icons.login, color: Colors.orange);
    if (action.contains('ALARM')) return const Icon(Icons.warning, color: Colors.amber);
    return const Icon(Icons.history, color: Colors.teal);
  }
}
