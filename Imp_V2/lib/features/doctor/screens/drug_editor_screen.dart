import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../nurse/nurse_providers.dart';
import '../../nurse/simulation/models/drug.dart';
import '../doctor_repository.dart';
import '../../auth/auth_repository.dart';
import '../../../core/theme.dart';

class DrugEditorScreen extends ConsumerStatefulWidget {
  final String? drugId;
  const DrugEditorScreen({super.key, this.drugId});

  @override
  ConsumerState<DrugEditorScreen> createState() => _DrugEditorScreenState();
}

class _DrugEditorScreenState extends ConsumerState<DrugEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _concentrationController = TextEditingController();
  final _defaultRateController = TextEditingController();
  final _softLimitController = TextEditingController();
  final _hardLimitController = TextEditingController();
  
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.drugId != null) {
      _loadDrugData();
    }
  }

  Future<void> _loadDrugData() async {
    // In a real app, fetch from provider or repository
    final drugs = await ref.read(drugListProvider.future);
    final drug = drugs.firstWhere((d) => d.id == widget.drugId);
    
    _nameController.text = drug.name;
    _concentrationController.text = drug.concentration.toString();
    _defaultRateController.text = drug.defaultRate.toString();
    _softLimitController.text = drug.softLimitThreshold.toString();
    _hardLimitController.text = drug.hardLimitCeiling.toString();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _concentrationController.dispose();
    _defaultRateController.dispose();
    _softLimitController.dispose();
    _hardLimitController.dispose();
    super.dispose();
  }

  Future<void> _saveProtocol() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final repository = ref.read(doctorRepositoryProvider.notifier);
      final user = ref.read(authRepositoryProvider);
      if (user == null) return;
      
      final drugs = await ref.read(drugListProvider.future);
      final oldDrug = widget.drugId != null ? drugs.firstWhere((d) => d.id == widget.drugId) : null;

      final newDrug = Drug(
        id: widget.drugId ?? '',
        name: _nameController.text,
        concentration: double.parse(_concentrationController.text),
        concentrationUnit: 'mg/mL',
        defaultRate: double.parse(_defaultRateController.text),
        rateUnit: 'mL/hr',
        softLimitThreshold: double.parse(_softLimitController.text),
        hardLimitCeiling: double.parse(_hardLimitController.text),
        createdBy: user.id,
        createdAt: oldDrug?.createdAt ?? DateTime.now(),
        isArchived: false,
      );

      await repository.saveDrugProtocol(drug: newDrug, oldDrug: oldDrug);

      ref.invalidate(drugListProvider);
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error saving protocol: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.drugId == null ? 'New Pharmaceutical Protocol' : 'Edit Protocol'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Chip(
              label: const Text('Clinician Verified Mode', style: TextStyle(fontSize: 10, color: Color(0xFF00685D))),
              backgroundColor: Colors.white,
              side: const BorderSide(color: Color(0xFF00685D)),
            ),
          ),
        ],
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(spaceMd),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _EditorSection(
                    title: 'IDENTIFICATION',
                    children: [
                      _buildTextField('Drug Name *', _nameController, 'Enter drug name'),
                    ],
                  ),
                  const SizedBox(height: spaceMd),
                  _EditorSection(
                    title: 'POTENCY',
                    children: [
                      _buildTextField('Concentration *', _concentrationController, '0.0', unit: 'mg/mL', isNumber: true),
                    ],
                  ),
                  const SizedBox(height: spaceMd),
                  _EditorSection(
                    title: 'FLOW CONTROL',
                    children: [
                      _buildTextField('Default Rate *', _defaultRateController, '0.0', unit: 'mL/hr', isNumber: true),
                      const SizedBox(height: spaceMd),
                      _buildTextField('Soft Limit *', _softLimitController, '0.0', unit: 'mL/hr', isNumber: true, subtitle: 'Overrideable alert threshold.'),
                      const SizedBox(height: spaceMd),
                      _buildTextField('Hard Limit *', _hardLimitController, '0.0', unit: 'mL/hr', isNumber: true, subtitle: 'Absolute maximum. Cannot be overridden.', isCritical: true),
                    ],
                  ),
                  const SizedBox(height: spaceXl),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => context.pop(),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: spaceMd),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(spaceSm)),
                          ),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: spaceMd),
                      Expanded(
                        child: FilledButton(
                          onPressed: _saveProtocol,
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: spaceMd),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(spaceSm)),
                            backgroundColor: const Color(0xFF00685D),
                          ),
                          child: const Text('Save Drug Protocol'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, String hint, {String? unit, bool isNumber = false, String? subtitle, bool isCritical = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: labelCaps.copyWith(color: isCritical ? Colors.red : null)),
        const SizedBox(height: spaceXs),
        TextFormField(
          controller: controller,
          keyboardType: isNumber ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
          decoration: InputDecoration(
            hintText: hint,
            suffixText: unit,
            border: const OutlineInputBorder(),
          ),
          validator: (value) => (value == null || value.isEmpty) ? 'Required' : null,
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(subtitle, style: captionStyle.copyWith(color: isCritical ? Colors.red : Colors.grey, fontStyle: FontStyle.italic)),
        ],
      ],
    );
  }
}

class _EditorSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _EditorSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(spaceMd),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(spaceMd),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: labelCaps.copyWith(color: Colors.grey.shade600)),
          const SizedBox(height: spaceMd),
          ...children,
        ],
      ),
    );
  }
}
