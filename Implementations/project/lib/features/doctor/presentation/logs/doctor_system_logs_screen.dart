import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:project/features/admin/presentation/providers/admin_providers.dart';
import 'package:project/features/doctor/presentation/providers/drug_provider.dart';
import 'package:project/features/nurse/presentation/providers/infusion_provider.dart';
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
    final userNamesAsync = ref.watch(userNamesMapProvider);
    final drugNamesAsync = ref.watch(drugNamesMapProvider);
    final sessionsAsync = ref.watch(sessionNamesMapProvider);
    
    final userMap = userNamesAsync.value ?? {};
    final drugMap = drugNamesAsync.value ?? {};
    final sessionMap = sessionsAsync.value ?? {};
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
          logsAsync.when(
            data: (logs) {
              final actions = logs
                .where((l) => l.action != 'LOGIN' && l.action != 'LOGOUT')
                .map((l) => l.action)
                .toSet()
                .toList()
                ..sort();
                
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: DropdownButtonFormField<String>(
                  value: _searchQuery.isEmpty ? 'All Actions' : _searchQuery,
                  decoration: InputDecoration(
                    labelText: 'Filter by Action',
                    prefixIcon: const Icon(Icons.filter_list, color: Colors.teal),
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
                  items: ['All Actions', ...actions].map((action) => DropdownMenuItem(
                    value: action,
                    child: Text(action.replaceAll('_', ' ')),
                  )).toList(),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = (value == 'All Actions') ? '' : value!;
                    });
                  },
                ),
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          Expanded(
            child: logsAsync.when(
              data: (logs) {
                // Filter out LOGIN and LOGOUT actions in the UI as requested for Doctors
                final filteredLogs = logs.where((log) {
                  final matchesAction = log.action != 'LOGIN' && log.action != 'LOGOUT';
                  final matchesFilter = _searchQuery.isEmpty || log.action == _searchQuery;
                  return matchesAction && matchesFilter;
                }).toList();

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
                        '${log.entityType}${log.entityName != null ? ' (${log.entityName})' : ''} • ${DateFormat('yyyy-MM-dd HH:mm:ss').format(log.timestamp)}',
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
                              Row(
                                children: [
                                  Icon(Icons.person, size: 14, color: Colors.teal[300]),
                                  const SizedBox(width: 8),
                                  Text(
                                    log.userName, 
                                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)
                                  ),
                                  if (log.userRole != null) ...[
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.teal.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        log.userRole!,
                                        style: TextStyle(fontSize: 10, color: Colors.teal.shade800, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.fingerprint, size: 14, color: Colors.teal[300]),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Entity: ${_resolveEntity(log.entityId, log.entityType, userMap, drugMap, sessionMap)}', 
                                    style: const TextStyle(fontSize: 12)
                                  ),
                                ],
                              ),

                              const Divider(height: 24),
                              const Text('DATA CHANGES', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 0.5, color: Colors.grey)),
                              const SizedBox(height: 8),
                              _buildDataDiff(log.oldValue, log.newValue, userMap, drugMap, sessionMap),
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

  Widget _buildDataDiff(String? oldJson, String? newJson, Map<String, String> userMap, Map<String, String> drugMap, Map<String, String> sessionMap) {
    try {
      final oldData = (oldJson != null && oldJson != '{}') ? jsonDecode(oldJson) as Map<String, dynamic> : <String, dynamic>{};
      final newData = (newJson != null && newJson != '{}') ? jsonDecode(newJson) as Map<String, dynamic> : <String, dynamic>{};

      final allKeys = {...oldData.keys, ...newData.keys};
      final List<Widget> changes = [];

      for (final key in allKeys) {
        final oldValue = oldData[key];
        final newValue = newData[key];

        if (oldValue.toString() == newValue.toString()) continue;

        changes.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_formatKey(key), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.teal.shade700)),
                const SizedBox(height: 2),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (oldValue != null)
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(4)),
                          child: Text(
                            _formatValue(key, oldValue, userMap, drugMap, sessionMap),
                            style: TextStyle(color: Colors.red.shade800, fontSize: 12, decoration: TextDecoration.lineThrough),
                          ),
                        ),
                      ),
                    if (oldValue != null && newValue != null)
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Icon(Icons.arrow_forward_rounded, size: 16, color: Colors.grey),
                      ),
                    if (newValue != null)
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(4)),
                          child: Text(
                            _formatValue(key, newValue, userMap, drugMap, sessionMap),
                            style: TextStyle(color: Colors.green.shade800, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      }

      if (changes.isEmpty) {
        return const Text('No detailed field changes recorded.', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 11, color: Colors.grey));
      }

      return Column(children: changes);
    } catch (e) {
      return Text('Error displaying changes: $e', style: const TextStyle(color: Colors.red, fontSize: 11));
    }
  }

  String _formatValue(String key, dynamic value, Map<String, String> userMap, Map<String, String> drugMap, Map<String, String> sessionMap) {
    if (value == null) return 'N/A';
    final valStr = value.toString();

    final normalizedKey = key.toLowerCase();
    if (normalizedKey.contains('user') || normalizedKey.contains('patient') || normalizedKey.contains('by')) {
      if (userMap.containsKey(valStr)) return userMap[valStr]!;
    }
    if (normalizedKey.contains('drug')) {
      if (drugMap.containsKey(valStr)) return drugMap[valStr]!;
    }
    if (normalizedKey.contains('session')) {
      if (sessionMap.containsKey(valStr)) return sessionMap[valStr]!;
    }

    if (valStr.length >= 32) {
      if (userMap.containsKey(valStr)) return userMap[valStr]!;
      if (drugMap.containsKey(valStr)) return drugMap[valStr]!;
      if (sessionMap.containsKey(valStr)) return sessionMap[valStr]!;
    }

    return valStr;
  }

  String _resolveEntity(String? id, String type, Map<String, String> userMap, Map<String, String> drugMap, Map<String, String> sessionMap) {
    if (id == null) return 'N/A';
    if (userMap.containsKey(id)) return userMap[id]!;
    if (drugMap.containsKey(id)) return drugMap[id]!;
    if (sessionMap.containsKey(id)) return sessionMap[id]!;
    return id;
  }

  String _formatKey(String key) {
    return key.split('_').map((word) {
      if (word.isEmpty) return '';
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
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
