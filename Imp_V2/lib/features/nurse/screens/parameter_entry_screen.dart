import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../nurse_providers.dart';
import '../simulation/infusion_state_machine.dart';
import '../../../core/theme.dart';

class ParameterEntryScreen extends ConsumerStatefulWidget {
  const ParameterEntryScreen({super.key});

  @override
  ConsumerState<ParameterEntryScreen> createState() => _ParameterEntryScreenState();
}

class _ParameterEntryScreenState extends ConsumerState<ParameterEntryScreen> {
  final _rateController = TextEditingController();
  final _vtbiController = TextEditingController();
  final _patientIdController = TextEditingController();
  String? _error;

  @override
  void initState() {
    super.initState();
    final drug = ref.read(selectedDrugProvider);
    if (drug != null) {
      _rateController.text = drug.defaultRate.toString();
    }
  }

  @override
  void dispose() {
    _rateController.dispose();
    _vtbiController.dispose();
    _patientIdController.dispose();
    super.dispose();
  }

  void _validateAndReview() {
    final drug = ref.read(selectedDrugProvider);
    if (drug == null) return;

    final rate = double.tryParse(_rateController.text) ?? 0;
    final vtbi = double.tryParse(_vtbiController.text) ?? 0;

    if (rate <= 0 || vtbi <= 0 || _patientIdController.text.isEmpty) {
      setState(() => _error = 'Please enter valid parameters and Patient ID');
      return;
    }

    if (rate > drug.hardLimitCeiling) {
      setState(() => _error = 'CRITICAL: Hard limit exceeded (${drug.hardLimitCeiling} mL/hr)');
      return;
    }

    if (rate > drug.softLimitThreshold) {
      // Soft limit warning - in a real app, this would show a confirmation dialog
      setState(() => _error = 'Warning: Soft limit threshold reached');
    } else {
      setState(() => _error = null);
    }

    // Update state machine and navigate back to dashboard
    ref.read(infusionProvider.notifier).updateParameters(
      drug: drug,
      patientId: _patientIdController.text.trim(),
      rate: rate,
      totalVolume: vtbi,
    );
    context.go('/nurse');
  }

  @override
  Widget build(BuildContext context) {
    final drug = ref.watch(selectedDrugProvider);

    if (drug == null) {
      return Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () => context.go('/nurse/drug-selection'),
            child: const Text('Select Drug First'),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Parameter Entry')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(spaceMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Channel A: ${drug.name}', style: titleStyle),
            const SizedBox(height: spaceMd),

            if (_error != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(spaceMd),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(spaceSm),
                  border: Border.all(color: Colors.red),
                ),
                child: Text(_error!, style: bodyStyle.copyWith(color: Colors.red)),
              ),
              const SizedBox(height: spaceMd),
            ],

            _InputCard(
              label: 'Patient Identification',
              unit: 'ID',
              controller: _patientIdController,
              hint: 'Scan or enter Patient MRN',
            ),
            const SizedBox(height: spaceMd),

            _InputCard(
              label: 'Infusion Rate',
              unit: 'mL/hr',
              controller: _rateController,
              hint: 'Range: 0.1–${drug.hardLimitCeiling}',
            ),
            const SizedBox(height: spaceMd),

            _InputCard(
              label: 'Volume To Be Infused (VTBI)',
              unit: 'mL',
              controller: _vtbiController,
              hint: 'Total volume in container',
            ),
            const SizedBox(height: spaceXl),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => context.pop(),
                    style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: spaceMd)),
                    child: const Text('CANCEL'),
                  ),
                ),
                const SizedBox(width: spaceMd),
                Expanded(
                  child: FilledButton(
                    onPressed: _validateAndReview,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: spaceMd),
                      backgroundColor: const Color(0xFF005EA4),
                    ),
                    child: const Text('REVIEW & START'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InputCard extends StatelessWidget {
  final String label;
  final String unit;
  final TextEditingController controller;
  final String hint;

  const _InputCard({
    required this.label,
    required this.unit,
    required this.controller,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(spaceSm)),
      child: Padding(
        padding: const EdgeInsets.all(spaceMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: labelCaps),
            const SizedBox(height: spaceSm),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      suffixText: unit,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: spaceXs),
            Text(hint, style: captionStyle.copyWith(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
