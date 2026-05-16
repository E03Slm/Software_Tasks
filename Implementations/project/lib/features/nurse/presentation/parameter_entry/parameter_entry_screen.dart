import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:project/features/nurse/presentation/providers/infusion_provider.dart';
import 'package:project/features/nurse/presentation/providers/patients_provider.dart';
import 'package:project/features/nurse/domain/models/infusion_session.dart';
import 'package:project/features/doctor/domain/models/drug.dart';
import 'package:project/features/admin/domain/models/managed_user.dart';
import 'package:project/features/nurse/domain/enums/alarm_type.dart';
import 'package:project/features/nurse/domain/enums/severity_level.dart';
import '../../../../core/theme/nurse_theme.dart';

class ParameterEntryScreen extends ConsumerStatefulWidget {
  const ParameterEntryScreen({super.key});

  @override
  ConsumerState<ParameterEntryScreen> createState() => _ParameterEntryScreenState();
}

class _ParameterEntryScreenState extends ConsumerState<ParameterEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _weightController;
  late TextEditingController _doseController;
  late TextEditingController _rateController;
  late TextEditingController _volumeController;
  String? _selectedPatientId;

  @override
  void initState() {
    super.initState();
    final session = ref.read(infusionProvider);
    final drug = session.drug;
    
    // Prioritize drug default rate for new selections, otherwise use current session rate
    double initialRate = session.infusionRate;
    if (initialRate == 0 && drug != null) {
      initialRate = drug.defaultRate;
    } else if (drug != null && session.status == 'Programming') {
      // If we just selected a drug, ensure we use its default
      initialRate = drug.defaultRate;
    }
        
    _rateController = TextEditingController(text: initialRate.toStringAsFixed(1));
    _volumeController = TextEditingController(text: session.totalVolume > 0 ? session.totalVolume.toStringAsFixed(0) : "100");
    _selectedPatientId = session.patientId;
    
    // Unused controllers kept for minimal code churn but removed from UI
    _weightController = TextEditingController();
    _doseController = TextEditingController();
  }

  @override
  void dispose() {
    _weightController.dispose();
    _doseController.dispose();
    _rateController.dispose();
    _volumeController.dispose();
    super.dispose();
  }

  void _onConfirm() {
    if (_formKey.currentState!.validate()) {
      final rate = double.tryParse(_rateController.text) ?? 0;
      final session = ref.read(infusionProvider);
      final drug = session.drug;

      if (drug != null && drug.softLimitHigh != null && rate > drug.softLimitHigh!) {
        _showSoftLimitAcknowledgment(rate, drug.softLimitHigh!);
      } else {
        ref.read(infusionProvider.notifier).setParameters(
              infusionRate: rate,
              totalVolume: double.parse(_volumeController.text),
              patientId: _selectedPatientId,
            );
        context.go('/nurse');
      }
    }
  }

  void _showSoftLimitAcknowledgment(double rate, double limit) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange.shade800),
            const SizedBox(width: 12),
            const Text('Soft Limit Alert'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'CLINICAL OVERRIDE REQUIRED',
              style: TextStyle(fontWeight: FontWeight.w900, color: Colors.orange, fontSize: 12),
            ),
            const SizedBox(height: 12),
            Text('The entered rate ($rate mL/hr) exceeds the predefined soft limit ($limit mL/hr).'),
            const SizedBox(height: 12),
            const Text('The infusion cannot continue until this override is acknowledged and logged.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () async {
              final sessionId = ref.read(infusionProvider).id;
              
              // 1. Manually trigger and await the alarm to ensure it's in state
              await ref.read(alarmProvider.notifier).add(
                AlarmType.softLimitWarning,
                AlarmSeverity.medium,
                sessionId,
              );

              // 2. Set parameters (duplicate prevention will skip second trigger)
              ref.read(infusionProvider.notifier).setParameters(
                    infusionRate: rate,
                    totalVolume: double.parse(_volumeController.text),
                    patientId: _selectedPatientId,
                  );
              
              // 3. Find and acknowledge the alarm
              final activeAlarms = ref.read(alarmProvider.notifier).active;
              final softLimitAlarm = activeAlarms.lastWhere(
                (a) => !a.ackRes,
                orElse: () => activeAlarms.last,
              );
              
              await ref.read(alarmProvider.notifier).acknowledge(softLimitAlarm.id);
              
              if (mounted) {
                Navigator.pop(dialogContext);
                context.go('/nurse');
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange.shade800, foregroundColor: Colors.white),
            child: const Text('ACKNOWLEDGE'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(infusionProvider);
    final drug = session.drug;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Infusion Monitor'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(drug),
              const SizedBox(height: 24),
              _buildPatientSelection(),
              const SizedBox(height: 24),
              _buildParameterGrid(drug),
              const SizedBox(height: 32),
              _buildInfusionSummary(session),
              const SizedBox(height: 32),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Drug? drug) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Parameter Entry',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                        fontSize: 32,
                        letterSpacing: -0.5,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Channel A Infusion Configuration',
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            if (drug != null)
               _buildStatusBadge('DRUG SELECTED', Colors.green)
            else
               _buildStatusBadge('NO DRUG', Colors.orange),
          ],
        ),
        const SizedBox(height: 24),
        _buildDrugInfoSection(drug),
      ],
    );
  }

  Widget _buildStatusBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1),
      ),
    );
  }

  Widget _buildDrugInfoSection(Drug? drug) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              children: [
                Icon(Icons.library_books_outlined, size: 18, color: Colors.blue.shade700),
                const SizedBox(width: 10),
                const Text(
                  'DRUG LIBRARY INFORMATION',
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 0.8, color: Colors.blueGrey),
                ),
                const Spacer(),
                if (drug != null)
                  Text(drug.name, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 14)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoColumn('CONCENTRATION', drug != null ? '${drug.concentration} ${drug.concentrationUnit}' : '---'),
                  _buildVerticalDivider(),
                  _buildInfoColumn('DEFAULT RATE', drug != null ? '${drug.defaultRate} ${drug.rateUnit}' : '---'),
                  _buildVerticalDivider(),
                  _buildInfoColumn('HARD LIMIT', drug != null ? '${drug.hardLimitHigh} ${drug.rateUnit}' : '---', valueColor: Colors.red.shade700),
                  _buildVerticalDivider(),
                  _buildInfoColumn('SOFT LIMIT', drug != null ? (drug.softLimitHigh != null ? '${drug.softLimitHigh} ${drug.rateUnit}' : 'None') : '---', valueColor: Colors.orange.shade700),
                  _buildVerticalDivider(),
                  _buildInfoColumn('UNITS', drug?.rateUnit ?? '---'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.grey.shade500, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 0.5),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w900, 
              fontSize: 16, 
              color: valueColor ?? Colors.blueGrey.shade800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 30,
      width: 1,
      color: Colors.grey.shade200,
    );
  }

  Widget _buildParameterGrid(dynamic drug) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildParameterCard(
                label: 'Infusion Rate',
                controller: _rateController,
                unit: drug?.rateUnit ?? 'mL/hr',
                highlight: true,
                subtitle: drug != null ? 'Hard Limit: ${drug.hardLimitHigh} ${drug.rateUnit}' : null,
                drug: drug,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildParameterCard(
                label: 'Total Volume (VTBI)',
                controller: _volumeController,
                unit: 'mL',
                subtitle: 'Enter target volume',
                drug: drug,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildParameterCard({
    required String label,
    required TextEditingController controller,
    required String unit,
    bool highlight = false,
    String? subtitle,
    Drug? drug,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: highlight ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.outlineVariant,
          width: highlight ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: highlight ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 12,
              fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller,
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Required';
                    final rate = double.tryParse(value);
                    if (rate == null) return 'Invalid';
                    
                    // Specific validation for Infusion Rate if a drug is selected
                    if (label == 'Infusion Rate' && drug != null) {
                      if (rate > drug.hardLimitHigh) {
                        return 'Exceeds limit (${drug.hardLimitHigh})';
                      }
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 8),
              Text(unit, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 16)),
            ],
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(
                color: highlight ? Theme.of(context).colorScheme.primary : Colors.grey,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfusionSummary(InfusionSession session) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerLow,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Infusion Summary', style: TextStyle(fontWeight: FontWeight.bold)),
                Icon(Icons.monitor_heart, size: 20),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryItem('Volume Infused', '${session.volumeInfused.toStringAsFixed(1)} mL'),
                _buildSummaryItem('Volume Remaining', '${session.volumeRemaining.toStringAsFixed(1)} mL'),
                _buildSummaryItem('Time Remaining', _formatDuration(session.timeRemaining)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => context.pop(),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('CANCEL'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: _onConfirm,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF43A047), // Success Green
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.play_arrow),
                SizedBox(width: 8),
                Text('START INFUSION', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPatientSelection() {
    final patientsAsync = ref.watch(patientsProvider);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'PATIENT IDENTIFICATION',
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 0.8, color: Colors.blueGrey),
        ),
        const SizedBox(height: 12),
        patientsAsync.when(
          data: (patients) => DropdownButtonFormField<String>(
            value: _selectedPatientId,
            decoration: InputDecoration(
              hintText: 'Select Patient (National ID)',
              prefixIcon: const Icon(Icons.person_search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            items: patients.map((p) => DropdownMenuItem(
              value: p.id,
              child: Text(p.fullName),
            )).toList(),
            onChanged: (val) => setState(() => _selectedPatientId = val),
            validator: (val) => val == null ? 'Patient required' : null,
          ),
          loading: () => const LinearProgressIndicator(),
          error: (err, _) => Text('Error loading patients: $err', style: const TextStyle(color: Colors.red)),
        ),
      ],
    );
  }

  Widget _buildInfoBadge(String label, {Color? color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: (color ?? Colors.blue).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color ?? Colors.blue.shade700,
        ),
      ),
    );
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    return "${twoDigits(d.inHours)}h ${twoDigits(d.inMinutes.remainder(60))}m";
  }
}

