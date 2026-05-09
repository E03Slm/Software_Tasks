import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../providers/drug_provider.dart';
import '../../domain/models/drug.dart';
import '../../../../core/theme/doctor_theme.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class AddEditDrugScreen extends ConsumerStatefulWidget {
  final String? drugId;

  const AddEditDrugScreen({
    super.key,
    this.drugId,
  });

  @override
  ConsumerState<AddEditDrugScreen> createState() => _AddEditDrugScreenState();
}

class _AddEditDrugScreenState extends ConsumerState<AddEditDrugScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _concentrationController;
  late TextEditingController _unitController;
  late TextEditingController _defaultRateController;
  late TextEditingController _softLimitHighController;
  late TextEditingController _hardLimitHighController;
  
  bool _isLoading = false;
  Drug? _existingDrug;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _concentrationController = TextEditingController();
    _unitController = TextEditingController(text: 'mg/mL');
    _defaultRateController = TextEditingController();
    _softLimitHighController = TextEditingController();
    _hardLimitHighController = TextEditingController();

    if (widget.drugId != null) {
      _loadExistingDrug();
    }
  }

  void _loadExistingDrug() {
    final drugListAsync = ref.read(drugListProvider);
    drugListAsync.whenData((drugs) {
      final drug = drugs.firstWhere((d) => d.id == widget.drugId);
      _existingDrug = drug;
      _nameController.text = drug.name;
      _concentrationController.text = drug.concentration.toString();
      _unitController.text = drug.concentrationUnit;
      _defaultRateController.text = drug.defaultRate.toString();
      _softLimitHighController.text = drug.softLimitHigh?.toString() ?? '';
      _hardLimitHighController.text = drug.hardLimitHigh.toString();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _concentrationController.dispose();
    _unitController.dispose();
    _defaultRateController.dispose();
    _softLimitHighController.dispose();
    _hardLimitHighController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final activeUser = ref.read(authProvider);
    final userId = activeUser?.id ?? 'SYSTEM';

    setState(() => _isLoading = true);
    try {
      final drug = Drug(
        id: widget.drugId ?? const Uuid().v4(),
        name: _nameController.text,
        concentration: double.parse(_concentrationController.text),
        concentrationUnit: _unitController.text,
        defaultRate: double.parse(_defaultRateController.text),
        softLimitHigh: _softLimitHighController.text.isNotEmpty 
            ? double.parse(_softLimitHighController.text) 
            : null,
        hardLimitHigh: double.parse(_hardLimitHighController.text),
        createdAt: _existingDrug?.createdAt ?? DateTime.now(),
      );

      if (widget.drugId != null) {
        await ref.read(drugRepositoryProvider).updateDrug(drug, userId);
      } else {
        await ref.read(drugRepositoryProvider).addDrug(drug, userId);
      }

      ref.read(drugListProvider.notifier).refresh();
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving drug: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final doctorColors = Theme.of(context).extension<DoctorColors>()!;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.drugId == null ? 'ADD NEW DRUG' : 'EDIT DRUG'),
        backgroundColor: doctorColors.primary,
        foregroundColor: Colors.white,
      ),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildSectionTitle('General Information'),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Drug Name'),
                      validator: (v) => v!.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: _concentrationController,
                            decoration: const InputDecoration(labelText: 'Concentration'),
                            keyboardType: TextInputType.number,
                            validator: (v) => v!.isEmpty ? 'Required' : null,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _unitController,
                            decoration: const InputDecoration(labelText: 'Unit'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    _buildSectionTitle('Clinical Limits'),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _defaultRateController,
                      decoration: const InputDecoration(labelText: 'Default Rate (mL/hr)'),
                      keyboardType: TextInputType.number,
                      validator: (v) => v!.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _softLimitHighController,
                            decoration: const InputDecoration(
                              labelText: 'Soft Limit High',
                              helperText: 'Warning threshold',
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _hardLimitHighController,
                            decoration: const InputDecoration(
                              labelText: 'Hard Limit High',
                              helperText: 'Strict maximum',
                            ),
                            keyboardType: TextInputType.number,
                            validator: (v) => v!.isEmpty ? 'Required' : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 48),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: _save,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: doctorColors.primary,
                          foregroundColor: Colors.white,
                        ),
                        child: Text(widget.drugId == null ? 'CREATE DRUG' : 'UPDATE DRUG'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
