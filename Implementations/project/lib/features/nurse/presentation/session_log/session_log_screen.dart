import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:project/features/nurse/presentation/providers/infusion_provider.dart';
import 'package:project/features/nurse/presentation/providers/audit_log_provider.dart';
import 'package:project/features/doctor/domain/models/audit_log.dart';
import 'package:project/core/theme/nurse_theme.dart';
import 'package:project/features/admin/presentation/providers/admin_providers.dart';
import 'package:project/features/doctor/presentation/providers/drug_provider.dart';

class SessionLogScreen extends ConsumerWidget {
  const SessionLogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logsAsync = ref.watch(sessionLogsProvider);
    final userNamesAsync = ref.watch(userNamesMapProvider);
    final drugNamesAsync = ref.watch(drugNamesMapProvider);
    final sessionsAsync = ref.watch(sessionNamesMapProvider);
    
    final userMap = userNamesAsync.value ?? {};
    final drugMap = drugNamesAsync.value ?? {};
    final sessionMap = sessionsAsync.value ?? {};
    
    // ignore: unused_local_variable
    final nurseColors = Theme.of(context).extension<NurseColors>()!;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('SESSION AUDIT TRAIL'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(sessionLogsProvider),
          ),
        ],
      ),
      body: logsAsync.when(
        data: (logs) => logs.isEmpty
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.history_toggle_off, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text('No activity recorded for this session', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: logs.length,
                itemBuilder: (context, index) {
                  final log = logs[index];
                  final isLast = index == logs.length - 1;

                  return IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Timeline line and dot
                        Column(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: _getActionColor(log.action),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                                boxShadow: [
                                  BoxShadow(
                                    color: _getActionColor(log.action).withValues(alpha: 0.3),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                            ),
                            if (!isLast)
                              Expanded(
                                child: Container(
                                  width: 2,
                                  color: Colors.grey.shade300,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        // Content card
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 24),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      log.action.replaceAll('_', ' '),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: _getActionColor(log.action),
                                      ),
                                    ),
                                    Text(
                                      DateFormat('HH:mm:ss').format(log.timestamp),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                if ((log.newValue != null && log.newValue != '{}') || (log.oldValue != null && log.oldValue != '{}'))
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: _buildFriendlyData(log, userMap, drugMap, sessionMap),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildFriendlyData(AuditLog log, Map<String, String> userMap, Map<String, String> drugMap, Map<String, String> sessionMap) {
    try {
      final oldData = (log.oldValue != null && log.oldValue != '{}') ? jsonDecode(log.oldValue!) as Map<String, dynamic> : <String, dynamic>{};
      final newData = (log.newValue != null && log.newValue != '{}') ? jsonDecode(log.newValue!) as Map<String, dynamic> : <String, dynamic>{};

      final allKeys = {...oldData.keys, ...newData.keys};
      final List<Widget> changes = [];

      for (final key in allKeys) {
        final oldValue = oldData[key];
        final newValue = newData[key];

        if (oldValue.toString() == newValue.toString()) continue;

        changes.add(
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blueGrey.withOpacity(0.03),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blueGrey.withOpacity(0.05)),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    _formatKey(key),
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Row(
                    children: [
                      if (oldValue != null) ...[
                        Flexible(
                          child: Text(
                            _formatValue(key, oldValue, userMap, drugMap, sessionMap),
                            style: const TextStyle(fontSize: 11, color: Colors.red, decoration: TextDecoration.lineThrough),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Icon(Icons.chevron_right, size: 14, color: Colors.grey),
                      ],
                      Flexible(
                        child: Text(
                          _formatValue(key, newValue, userMap, drugMap, sessionMap),
                          style: TextStyle(
                            fontSize: 11, 
                            fontWeight: FontWeight.bold, 
                            color: newValue != null ? Colors.green.shade700 : Colors.blueGrey
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }

      if (changes.isEmpty) return const SizedBox.shrink();
      return Column(children: changes);
    } catch (e) {
      return Text('Raw: ${log.newValue}', style: const TextStyle(fontSize: 10, color: Colors.grey));
    }
  }

  String _formatValue(String key, dynamic value, Map<String, String> userMap, Map<String, String> drugMap, Map<String, String> sessionMap) {
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
        return '$formattedNum (Dose)';
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

    if (valStr.length >= 32) {
      if (userMap.containsKey(valStr)) return userMap[valStr]!;
      if (drugMap.containsKey(valStr)) return drugMap[valStr]!;
      if (sessionMap.containsKey(valStr)) return sessionMap[valStr]!;
    }

    return valStr;
  }

  String _formatKey(String key) {
    return key.split('_').map((word) {
      if (word.isEmpty) return '';
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }

  Color _getActionColor(String action) {
    if (action.contains('START')) return Colors.green;
    if (action.contains('STOP') || action.contains('EMERGENCY')) return Colors.red;
    if (action.contains('ALARM')) return Colors.orange;
    return Colors.blue;
  }
}
