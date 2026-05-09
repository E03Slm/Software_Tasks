import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../data/repositories/report_repository.dart';
import '../../data/services/report_generator.dart';
import './audit_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

// Standard Providers to avoid riverpod_generator issues with PDF/Uint8List types
final reportRepositoryProvider = Provider((ref) => ReportRepository());
final reportGeneratorProvider = Provider((ref) => ReportGenerator());

class ReportStateNotifier extends Notifier<Uint8List?> {
  @override
  Uint8List? build() => null;
  void setBytes(Uint8List? bytes) => state = bytes;
}
final reportStateProvider = NotifierProvider<ReportStateNotifier, Uint8List?>(ReportStateNotifier.new);

class GenerationStatusNotifier extends Notifier<bool> {
  @override
  bool build() => false;
  void setStatus(bool status) => state = status;
}
final isGeneratingReportProvider = NotifierProvider<GenerationStatusNotifier, bool>(GenerationStatusNotifier.new);

class ReportErrorNotifier extends Notifier<String?> {
  @override
  String? build() => null;
  void setError(String? error) => state = error;
}
final reportErrorProvider = NotifierProvider<ReportErrorNotifier, String?>(ReportErrorNotifier.new);

class ReportNotifier {
  static Future<void> generate(WidgetRef ref, DateTimeRange range, bool isDetailed) async {
    ref.read(isGeneratingReportProvider.notifier).setStatus(true);
    ref.read(reportErrorProvider.notifier).setError(null);
    
    try {
      final repo = ref.read(reportRepositoryProvider);
      final generator = ref.read(reportGeneratorProvider);
      
      // Multi-table parallel fetch
      final results = await Future.wait([
        repo.fetchSessionsInRange(range.start, range.end),
        repo.fetchAlarmsInRange(range.start, range.end),
        repo.fetchTechnicalLogs(range.start, range.end),
      ]);

      final sessions = results[0] as List;
      final alarms = results[1] as List;
      final technicalLogs = results[2] as List;
      
      if (sessions.isEmpty) {
        throw Exception('No clinical sessions found for the selected period.');
      }
      
      final pdfBytes = await generator.generateInfusionSummary(
        sessions: sessions.cast(),
        alarms: alarms.cast(),
        technicalLogs: technicalLogs.cast(),
        range: range,
        isDetailed: isDetailed,
      );
      
      // Log report generation
      final activeUser = ref.read(authProvider);
      await ref.read(auditRepositoryProvider).logAction(
        actionType: 'GENERATE_REPORT',
        entityType: 'REPORT',
        performerId: activeUser?.id,
        oldValue: {}, // Provide empty object to prevent null
        newValue: {
          'date_range': '${range.start} to ${range.end}',
          'is_detailed': isDetailed,
        },
      );
      
      ref.read(reportStateProvider.notifier).setBytes(Uint8List.fromList(pdfBytes));
    } catch (e) {
      ref.read(reportErrorProvider.notifier).setError(e.toString());
    } finally {
      ref.read(isGeneratingReportProvider.notifier).setStatus(false);
    }
  }
}
