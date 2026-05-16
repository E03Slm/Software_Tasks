import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import '../providers/admin_providers.dart';
import '../../../doctor/presentation/providers/drug_provider.dart';
import '../../../nurse/presentation/providers/infusion_provider.dart';

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
    final userNamesAsync = ref.watch(userNamesMapProvider);
    final drugNamesAsync = ref.watch(drugNamesMapProvider);
    final sessionsAsync = ref.watch(sessionNamesMapProvider);
    final alarmsAsync = ref.watch(alarmNamesMapProvider);
    
    final userMap = userNamesAsync.value ?? {};
    final drugMap = drugNamesAsync.value ?? {};
    final sessionMap = sessionsAsync.value ?? {};
    final alarmMap = alarmsAsync.value ?? {};

    return Scaffold(
      body: Column(
        children: [
          logsAsync.when(
            data: (logs) {
              final actions = logs.map((l) {
                if (l.action == 'ACKNOWLEDGE_ALARM' || l.action == 'ALARM_ACKNOWLEDGED' || l.action == 'ALARM_ACK' || l.action == 'ALARM_RESOLVED') return 'ALARM_RESOLVED_ACK';
                if (l.action == 'TRIGGER_ALARM') return 'ALARM_TRIGGERED';
                return l.action;
              }).toSet().toList()..sort();
              
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: DropdownButtonFormField<String>(
                  value: _searchQuery.isEmpty ? 'All Actions' : _searchQuery,
                  decoration: InputDecoration(
                    labelText: 'Filter by Action',
                    prefixIcon: const Icon(Icons.filter_list),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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
                final deduplicatedLogs = _deduplicateLogs(logs);
                final filteredLogs = deduplicatedLogs.where((log) {
                  if (_searchQuery.isEmpty) return true;
                  
                  final normalizedAction = (log.action == 'ACKNOWLEDGE_ALARM' || log.action == 'ALARM_ACKNOWLEDGED' || log.action == 'ALARM_ACK' || log.action == 'ALARM_RESOLVED')
                      ? 'ALARM_RESOLVED_ACK' 
                      : (log.action == 'TRIGGER_ALARM' ? 'ALARM_TRIGGERED' : log.action);
                      
                  return normalizedAction == _searchQuery;
                }).toList();

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
                        _getDisplayTitle(log),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '${log.entityType}${log.entityName != null ? ' (${log.entityName})' : ''} • ${DateFormat('yyyy-MM-dd HH:mm:ss').format(log.timestamp)}',
                        style: const TextStyle(fontSize: 12),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.person_outline, size: 16, color: Colors.blueGrey),
                                  const SizedBox(width: 8),
                                  Text(
                                    log.userName, 
                                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)
                                  ),
                                  if (log.userRole != null) ...[
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        log.userRole!,
                                        style: TextStyle(fontSize: 10, color: Colors.blue.shade800, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Entity: ${_resolveEntity(log.entityId, log.entityType, userMap, drugMap, sessionMap, alarmMap)}', 
                                style: const TextStyle(fontSize: 12, color: Colors.grey)
                              ),

                              const Divider(height: 24),
                              const Text('DATA CHANGES', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 0.5, color: Colors.grey)),
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
              error: (err, stack) => Center(child: Text('Error: $err')),
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
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_formatKey(key), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.blueGrey.shade700)),
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
                            _formatValue(key, oldValue, userMap, drugMap, sessionMap, alarmMap),
                            style: TextStyle(color: Colors.red.shade800, fontSize: 13, decoration: TextDecoration.lineThrough),
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
                            _formatValue(key, newValue, userMap, drugMap, sessionMap, alarmMap),
                            style: TextStyle(color: Colors.green.shade800, fontSize: 13, fontWeight: FontWeight.bold),
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
        return const Text('No detailed field changes recorded.', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12, color: Colors.grey));
      }

      return Column(children: changes);
    } catch (e) {
      return Text('Error displaying changes: $e', style: const TextStyle(color: Colors.red, fontSize: 12));
    }
  }

  String _getDisplayTitle(dynamic log) {
    final action = log.action as String;
    if (action == 'ALARM_RESOLVED_ACK' || action == 'ALARM_RESOLVED') {
       try {
         final data = jsonDecode(log.newValue ?? '{}') as Map<String, dynamic>;
         final alarmId = data['alarm_id'] ?? 'N/A';
         final performer = data['ack_details']?['performed_by'] ?? 'Clinician';
         return 'Alarm $alarmId Resolved/Acknowledged by $performer';
       } catch (e) {
         return 'Alarm Resolved/Acknowledged';
       }
    }
    
    // Support legacy names in title display too
    if (action == 'ACKNOWLEDGE_ALARM' || action == 'ALARM_ACKNOWLEDGED' || action == 'ALARM_ACK') {
      return 'Alarm Resolved/Acknowledged';
    }

    return action.replaceAll('_', ' ');
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

    // User/Patient resolution
    if (normalizedKey.contains('user') || normalizedKey.contains('patient') || normalizedKey.contains('by')) {
      if (userMap.containsKey(valStr)) return userMap[valStr]!;
    }
    
    // Drug resolution
    if (normalizedKey.contains('drug')) {
      if (drugMap.containsKey(valStr)) return drugMap[valStr]!;
    }
    
    // Session resolution
    if (normalizedKey.contains('session')) {
      if (sessionMap.containsKey(valStr)) return sessionMap[valStr]!;
    }

    // Alarm resolution
    if (normalizedKey.contains('alarm')) {
      if (alarmMap.containsKey(valStr)) return alarmMap[valStr]!;
    }

    // Fallback: Check all maps if it's a UUID-like string
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
    if (action.contains('CREATE')) return const Icon(Icons.add_circle, color: Colors.green);
    if (action.contains('UPDATE')) return const Icon(Icons.edit, color: Colors.blue);
    if (action.contains('DELETE')) return const Icon(Icons.delete, color: Colors.red);
    if (action.contains('LOGIN')) return const Icon(Icons.login, color: Colors.orange);
    if (action.contains('ALARM')) return const Icon(Icons.warning, color: Colors.amber);
    return const Icon(Icons.history);
  }

  List<dynamic> _deduplicateLogs(List<dynamic> logs) {
    if (logs.isEmpty) return [];
    
    final List<dynamic> result = [];
    final Map<String, dynamic> mergedLogs = {};

    for (final log in logs) {
      final isAlarmAction = log.action.contains('ALARM') && 
          (log.action.contains('ACK') || log.action.contains('RESOLVE'));
      
      if (isAlarmAction) {
        // Group by Entity, Performer, and Timestamp (rounded to nearest second)
        final timeKey = (log.timestamp.millisecondsSinceEpoch / 1000).floor();
        final key = '${log.entityId}_${log.userId}_$timeKey';

        if (mergedLogs.containsKey(key)) {
          final existing = mergedLogs[key];
          try {
            final existingData = jsonDecode(existing.newValue ?? '{}') as Map<String, dynamic>;
            final newData = jsonDecode(log.newValue ?? '{}') as Map<String, dynamic>;
            
            // Simple merge of top-level keys
            final mergedData = {...existingData, ...newData};
            
            // Keep the one with ALARM_RESOLVED_ACK action if possible
            final bestAction = (log.action == 'ALARM_RESOLVED_ACK') ? log.action : existing.action;
            
            mergedLogs[key] = existing.copyWith(
              action: bestAction,
              newValue: jsonEncode(mergedData)
            );
          } catch (e) {
            result.add(log);
          }
        } else {
          mergedLogs[key] = log;
          result.add(mergedLogs[key]);
        }
      } else {
        result.add(log);
      }
    }
    return result;
  }
}
