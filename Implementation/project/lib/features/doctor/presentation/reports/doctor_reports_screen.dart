import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';
import '../providers/report_provider.dart';
import '../../../../core/theme/app_theme.dart';

class DoctorReportsScreen extends ConsumerStatefulWidget {
  const DoctorReportsScreen({super.key});

  @override
  ConsumerState<DoctorReportsScreen> createState() => _DoctorReportsScreenState();
}

class _DoctorReportsScreenState extends ConsumerState<DoctorReportsScreen> {
  DateTimeRange _dateRange = DateTimeRange(
    start: DateTime.now().subtract(const Duration(days: 7)),
    end: DateTime.now(),
  );
  bool _isDetailed = true;

  @override
  Widget build(BuildContext context) {
    final pdfBytes = ref.watch(reportStateProvider);
    final isGenerating = ref.watch(isGeneratingReportProvider);
    final error = ref.watch(reportErrorProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('CLINICAL REPORTS'),
      ),
      body: Column(
        children: [
          _buildReportToolbar(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(spaceMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildReportConfiguration(isGenerating),
                  const SizedBox(height: spaceLg),
                  Expanded(
                    child: isGenerating 
                      ? _buildLoadingState()
                      : (error != null 
                          ? _buildErrorState(error) 
                          : (pdfBytes == null ? _buildEmptyState() : _buildPdfPreview(pdfBytes))),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportToolbar() {
    return Container(
      color: Colors.teal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Switch(
            value: _isDetailed,
            onChanged: (val) => setState(() => _isDetailed = val),
            activeColor: Colors.white,
            activeTrackColor: Colors.tealAccent.withOpacity(0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            error,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red),
          ),
        ],
      ),
    );
  }

  Widget _buildReportConfiguration(bool isGenerating) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(spaceMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'REPORT SETTINGS',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1.2),
            ),
            const SizedBox(height: spaceSm),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.date_range),
              title: const Text('Date Range'),
              subtitle: Text(
                '${_formatDate(_dateRange.start)} - ${_formatDate(_dateRange.end)}',
              ),
              trailing: TextButton(
                onPressed: isGenerating ? null : _selectDateRange,
                child: const Text('CHANGE'),
              ),
            ),
            const SizedBox(height: spaceSm),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: isGenerating 
                    ? null 
                    : () => ReportNotifier.generate(ref, _dateRange, _isDetailed),
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text('GENERATE INFUSION SUMMARY'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPdfPreview(dynamic pdfBytes) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 4,
      child: PdfPreview(
        build: (format) => pdfBytes,
        useActions: true,
        canChangePageFormat: false,
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Generating Clinical PDF...'),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.analytics_outlined, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text(
            'Select a date range and click generate\nto view the clinical summary.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      initialDateRange: _dateRange,
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() => _dateRange = picked);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
