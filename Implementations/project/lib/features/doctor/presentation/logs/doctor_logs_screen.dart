import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'dart:convert';
import '../providers/audit_provider.dart';
import '../providers/drug_provider.dart';
import '../../../nurse/presentation/providers/infusion_provider.dart';
import 'package:project/features/admin/presentation/providers/admin_providers.dart';
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
    final userNamesAsync = ref.watch(userNamesMapProvider);
    final drugNamesAsync = ref.watch(drugNamesMapProvider);
    final sessionsAsync = ref.watch(sessionNamesMapProvider);
    final alarmNamesAsync = ref.watch(alarmNamesMapProvider);
    
    final userMap = userNamesAsync.value ?? {};
    final drugMap = drugNamesAsync.value ?? {};
    final sessionMap = sessionsAsync.value ?? {};
    final alarmMap = alarmNamesAsync.value ?? {};

    return Scaffold(
      appBar: AppBar(
        title: const Text('AUDIT LOGS'),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.admin_panel_settings_outlined, color: Colors.white, size: 18),
            label: const Text('SYSTEM VIEW', style: TextStyle(color: Colors.white, fontSize: 12)),
            onPressed: () => context.push('/doctor/logs/system'),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(auditLogListProvider.notifier).refresh(),
          ),
        ],
      ),
      body: Column(
        children: [
          logsAsync.when(
            data: (logs) {
              final actions = logs.map((l) => l.action).toSet().toList()..sort();
              return Padding(
                padding: const EdgeInsets.all(spaceMd),
                child: DropdownButtonFormField<String>(
                  value: _searchQuery.isEmpty ? 'All Actions' : _searchQuery,
                  decoration: InputDecoration(
                    labelText: 'Filter by Action',
                    prefixIcon: const Icon(Icons.filter_list),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
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
                final filteredLogs = logs.where((log) => 
                  _searchQuery.isEmpty || log.action == _searchQuery
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
                        '${log.entityType}${log.entityName != null ? ' (${log.entityName})' : ''} • ${DateFormat('yyyy-MM-dd HH:mm:ss').format(log.timestamp)}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(spaceMd),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.person_outline, size: 14, color: Colors.blueGrey),
                                  const SizedBox(width: 6),
                                  Text(
                                    log.userName, 
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)
                                  ),
                                  if (log.userRole != null) ...[
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                      decoration: BoxDecoration(
                                        color: Colors.teal.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        log.userRole!,
                                        style: TextStyle(fontSize: 9, color: Colors.teal.shade800, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              Text(
                                'Entity: ${_resolveEntity(log.entityId, log.entityType, userMap, drugMap, sessionMap, alarmMap)}', 
                                style: const TextStyle(fontSize: 11, color: Colors.grey)
                              ),

                              const Divider(height: 24),
                              const Text('DATA CHANGES', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 0.5, color: Colors.grey)),
                              const SizedBox(height: 8),
                              _buildDataDiff(log.oldValue, log.newValue, userMap, drugMap, sessionMap, alarmMap),
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

  Widget _buildDataDiff(String? oldJson, String? newJson, Map<String, String> userMap, Map<String, String> drugMap, Map<String, String> sessionMap, Map<String, String> alarmMap) {
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
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_formatKey(key), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.blueGrey.shade700)),
                const SizedBox(height: 2),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (oldValue != null)
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(4)),
                          child: Text(
                            _formatValue(key, oldValue, userMap, drugMap, sessionMap, alarmMap),
                            style: TextStyle(color: Colors.red.shade800, fontSize: 12, decoration: TextDecoration.lineThrough),
                          ),
                        ),
                      ),
                    if (oldValue != null && newValue != null)
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6),
                        child: Icon(Icons.arrow_forward_rounded, size: 14, color: Colors.grey),
                      ),
                    if (newValue != null)
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(4)),
                          child: Text(
                            _formatValue(key, newValue, userMap, drugMap, sessionMap, alarmMap),
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

  String _formatValue(String key, dynamic value, Map<String, String> userMap, Map<String, String> drugMap, Map<String, String> sessionMap, Map<String, String> alarmMap) {
    if (value == null) return 'N/A';
    final valStr = value.toString();
    final normalizedKey = key.toLowerCase();
    
    // Formatting numeric clinical parameters with units
    if (value is num || double.tryParse(valStr) != null) {
      final numVal = double.tryParse(valStr) ?? 0.0;
      final formattedNum = numVal.toStringAsFixed(numVal.truncateToDouble() == numVal ? 0 : 2);
      
      if (normalizedKey.contains('rate')) return '$formattedNum mL/hr';
      if (normalizedKey.contains('volume')) return '$formattedNum mL';
      if (normalizedKey.contains('weight')) return '$formattedNum kg';
      if (normalizedKey.contains('dose') && !normalizedKey.contains('unit')) {
        return '$formattedNum (Clinical Dose)';
      }
      return formattedNum;
    }

    if (normalizedKey.contains('user') || normalizedKey.contains('patient') || normalizedKey.contains('by')) {
      if (userMap.containsKey(valStr)) return userMap[valStr]!;
    }
    if (normalizedKey.contains('drug')) {
      if (drugMap.containsKey(valStr)) return drugMap[valStr]!;
    }
    if (normalizedKey.contains('session')) {
      if (sessionMap.containsKey(valStr)) return sessionMap[valStr]!;
    }
    if (normalizedKey.contains('alarm')) {
      if (alarmMap.containsKey(valStr)) return alarmMap[valStr]!;
    }

    if (valStr.length >= 32) {
      if (userMap.containsKey(valStr)) return userMap[valStr]!;
      if (drugMap.containsKey(valStr)) return drugMap[valStr]!;
      if (sessionMap.containsKey(valStr)) return sessionMap[valStr]!;
      if (alarmMap.containsKey(valStr)) return alarmMap[valStr]!;
    }

    return valStr;
  }

  String _resolveEntity(String? id, String type, Map<String, String> userMap, Map<String, String> drugMap, Map<String, String> sessionMap, Map<String, String> alarmMap) {
    if (id == null) return 'N/A';
    if (userMap.containsKey(id)) return userMap[id]!;
    if (drugMap.containsKey(id)) return drugMap[id]!;
    if (sessionMap.containsKey(id)) return sessionMap[id]!;
    if (alarmMap.containsKey(id)) return alarmMap[id]!;
    return id;
  }

  String _formatKey(String key) {
    return key.split('_').map((word) {
      if (word.isEmpty) return '';
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }

  Widget _getIconForAction(String action) {
    if (action.contains('CREATE')) return const Icon(Icons.add_circle_outline, color: Colors.green);
    if (action.contains('UPDATE')) return const Icon(Icons.edit_note, color: Colors.blue);
    if (action.contains('DELETE')) return const Icon(Icons.delete_forever, color: Colors.red);
    if (action.contains('LOGIN')) return const Icon(Icons.login, color: Colors.orange);
    return const Icon(Icons.history);
  }
}
