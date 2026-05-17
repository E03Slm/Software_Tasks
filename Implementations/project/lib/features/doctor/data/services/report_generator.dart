import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import '../../../nurse/domain/models/infusion_session.dart';
import '../../../nurse/domain/models/alarm.dart';
import '../../domain/models/audit_log.dart';

class ReportGenerator {
  Future<List<int>> generateInfusionSummary({
    required List<InfusionSession> sessions,
    required List<Alarm> alarms,
    required List<AuditLog> technicalLogs,
    required List<AuditLog> drugManagementLogs,
    required Map<String, String> userNames,
    required DateTimeRange range,
    bool isDetailed = true,
  }) async {
    final pdf = pw.Document();
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm');

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        footer: (context) => pw.Container(
          alignment: pw.Alignment.centerRight,
          padding: const pw.EdgeInsets.only(top: 10),
          child: pw.Text('Page ${context.pageNumber}', style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey)),
        ),
        build: (context) => [
          _buildHeader(range),
          pw.SizedBox(height: 15),
          
          // 1. Executive Summary
          _sectionTitle('1. EXECUTIVE SUMMARY OF THERAPY'),
          _buildExecutiveSummary(sessions),
          pw.SizedBox(height: 20),

          // 2. Medication Compliance
          _sectionTitle('2. MEDICATION COMPLIANCE & TITRATION'),
          _buildMedicationCompliance(sessions, technicalLogs),
          pw.SizedBox(height: 20),

          // 3. Drug Library Management (NEW)
          _sectionTitle('3. DRUG LIBRARY INVENTORY CHANGES'),
          _buildDrugManagementSection(drugManagementLogs, dateFormat),
          pw.SizedBox(height: 20),

          // 4. Safety & Alarm Analytics
          _sectionTitle('4. SAFETY & ALARM ANALYTICS'),
          _buildSafetyAnalytics(alarms, sessions),
          pw.SizedBox(height: 20),


          if (isDetailed) ...[
            pw.SizedBox(height: 20),
            // 6. Detailed Session Logs
            _sectionTitle('6. DETAILED SESSION LOGS'),
            _buildSessionTable(sessions, dateFormat, userNames),
          ],
        ],
      ),
    );

    return pdf.save();
  }

  pw.Widget _sectionTitle(String title) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: const pw.BoxDecoration(color: PdfColors.teal50),
      child: pw.Text(title, style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: PdfColors.teal900)),
    );
  }

  pw.Widget _buildHeader(DateTimeRange range) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('CLINICAL INFUSION REPORT', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold, color: PdfColors.teal)),
            pw.Text('SMART INFUSION PUMP v1.0', style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700)),
          ],
        ),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Text('Period: ${DateFormat('MMMM dd, yyyy').format(range.start)} - ${DateFormat('MMMM dd, yyyy').format(range.end)}', style: const pw.TextStyle(fontSize: 10)),
            pw.Text('Generated: ${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now())}', style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey)),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildExecutiveSummary(List<InfusionSession> sessions) {
    final totalVol = sessions.fold(0.0, (sum, s) => sum + (s.volumeInfused ?? 0.0));
    final completed = sessions.where((s) => s.status.toLowerCase() == 'completed').length;
    final successRate = sessions.isNotEmpty ? (completed / sessions.length) * 100 : 0.0;
    final avgRate = sessions.isNotEmpty ? sessions.fold(0.0, (sum, s) => sum + (s.infusionRate ?? 0.0)) / sessions.length : 0.0;

    return pw.Row(
      children: [
        _summaryCard('Total Vol Infused', '${totalVol.toStringAsFixed(1)} mL', PdfColors.teal),
        pw.SizedBox(width: 10),
        _summaryCard('Therapy Success', '${successRate.toStringAsFixed(0)}%', PdfColors.blue),
        pw.SizedBox(width: 10),
        _summaryCard('Avg Flow Rate', '${avgRate.toStringAsFixed(1)} mL/hr', PdfColors.orange),
      ],
    );
  }

  pw.Widget _summaryCard(String label, String value, PdfColor color) {
    return pw.Expanded(
      child: pw.Container(
        padding: const pw.EdgeInsets.all(12),
        decoration: pw.BoxDecoration(
          border: pw.Border.all(color: color, width: 0.5),
          borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
        ),
        child: pw.Column(
          children: [
            pw.Text(label, style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700)),
            pw.SizedBox(height: 4),
            pw.Text(value, style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }

  pw.Widget _buildMedicationCompliance(List<InfusionSession> sessions, List<AuditLog> logs) {
    final titrationCount = logs.where((l) => l.action == 'RATE_CHANGED').length;
    final bolusSessions = sessions.where((s) => s.bolusEnabled == true).length;
    
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Compliance Metrics:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
        pw.Bullet(text: 'Total Titration Events (Rate Changes): $titrationCount', style: const pw.TextStyle(fontSize: 9)),
        pw.Bullet(text: 'Sessions with Bolus Capability: $bolusSessions', style: const pw.TextStyle(fontSize: 9)),
        pw.SizedBox(height: 10),
        pw.TableHelper.fromTextArray(
          headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9),
          cellStyle: const pw.TextStyle(fontSize: 8),
          headers: ['Drug Name', 'Usage Count', 'Total Vol'],
          data: _groupByDrug(sessions),
        ),
      ],
    );
  }

  pw.Widget _buildSafetyAnalytics(List<Alarm> alarms, List<InfusionSession> sessions) {
    final occlusions = alarms.where((a) => (a.definition?.name.toLowerCase() ?? '').contains('occlusion')).length;
    final airInLine = alarms.where((a) => (a.definition?.name.toLowerCase() ?? '').contains('air')).length;
    final criticalBattery = sessions.where((s) => (s.batteryLevel ?? 100) < 10).length;

    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Alarm Frequency:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
              pw.Text('Occlusions: $occlusions', style: const pw.TextStyle(fontSize: 9)),
              pw.Text('Air-in-Line: $airInLine', style: const pw.TextStyle(fontSize: 9)),
              pw.Text('Critical Battery Events: $criticalBattery', style: const pw.TextStyle(fontSize: 9)),
            ],
          ),
        ),
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Clinician Response:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
              pw.Text('Avg Response Time: ${_calculateAvgResponse(alarms)}', style: const pw.TextStyle(fontSize: 9)),
            ],
          ),
        ),
      ],
    );
  }

  pw.Widget _buildSessionTable(List<InfusionSession> sessions, DateFormat dateFormat, Map<String, String> userNames) {
    return pw.TableHelper.fromTextArray(
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9, color: PdfColors.white),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.teal700),
      cellStyle: const pw.TextStyle(fontSize: 8),
      headers: ['Start', 'End', 'Status', 'Rate', 'Vol', 'Clinician'],
      data: sessions.map((s) => [
        s.startTime != null ? dateFormat.format(s.startTime!) : 'N/A',
        s.endTime != null ? dateFormat.format(s.endTime!) : 'Active',
        (s.status).toUpperCase(),
        '${s.infusionRate.toStringAsFixed(1)}',
        '${s.volumeInfused.toStringAsFixed(1)}',
        s.userId != null ? (userNames[s.userId] ?? s.userId!.substring(0, 8)) : 'N/A',
      ]).toList(),
    );
  }

  pw.Widget _buildDrugManagementSection(List<AuditLog> logs, DateFormat dateFormat) {
    if (logs.isEmpty) {
      return pw.Text('No changes made to the drug library during this period.', style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey));
    }

    return pw.TableHelper.fromTextArray(
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9, color: PdfColors.white),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.blueGrey700),
      cellStyle: const pw.TextStyle(fontSize: 8),
      headers: ['Date/Time', 'Action', 'Drug Name', 'Performer'],
      data: logs.map((log) => [
        dateFormat.format(log.timestamp),
        log.action.replaceAll('_', ' '),
        log.entityName ?? 'N/A',
        log.fullName,
      ]).toList(),
    );
  }

  List<List<String>> _groupByDrug(List<InfusionSession> sessions) {
    final Map<String, List<InfusionSession>> groups = {};
    for (var s in sessions) {
      final key = s.drug?.name ?? s.drugId ?? 'Unknown';
      groups.putIfAbsent(key, () => []).add(s);
    }
    return groups.entries.map((e) {
      final totalVol = e.value.fold(0.0, (sum, s) => sum + (s.volumeInfused ?? 0.0));
      return [e.key, e.value.length.toString(), '${totalVol.toStringAsFixed(1)} mL'];
    }).toList();
  }

  String _calculateAvgResponse(List<Alarm> alarms) {
    final acked = alarms.where((a) => a.ackRes && a.ackResAt != null).toList();
    if (acked.isEmpty) return 'N/A';
    final totalSeconds = acked.fold(0.0, (sum, a) => sum + a.ackResAt!.difference(a.displayTime).inSeconds);
    final avg = totalSeconds / acked.length;
    return '${(avg / 60).toStringAsFixed(1)} min';
  }
}
