import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme.dart';
import '../../auth/models/role_type.dart';

class UserEditorScreen extends StatefulWidget {
  final String? userId;
  const UserEditorScreen({super.key, this.userId});

  @override
  State<UserEditorScreen> createState() => _UserEditorScreenState();
}

class _UserEditorScreenState extends State<UserEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  RoleType _selectedRole = RoleType.nurse;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userId == null ? 'Create New User' : 'Edit User Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(spaceMd),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('CORE IDENTITY'),
              const SizedBox(height: spaceSm),
              _buildTextField('User ID / Employee Number *', 'e.g. N-8842'),
              const SizedBox(height: spaceMd),
              _buildTextField('National ID / SSN *', '14-digit identifier'),
              const SizedBox(height: spaceLg),

              _buildSectionTitle('FULL NAME'),
              const SizedBox(height: spaceSm),
              Row(
                children: [
                  Expanded(child: _buildTextField('First Name *', 'John')),
                  const SizedBox(width: spaceMd),
                  Expanded(child: _buildTextField('Last Name *', 'Doe')),
                ],
              ),
              const SizedBox(height: spaceLg),

              _buildSectionTitle('SYSTEM ACCESS'),
              const SizedBox(height: spaceSm),
              _buildRoleDropdown(),
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
                      onPressed: () => context.pop(),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: spaceMd),
                        backgroundColor: const Color(0xFF6200EA),
                      ),
                      child: const Text('SAVE USER ACCESS'),
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

  Widget _buildSectionTitle(String title) {
    return Text(title, style: labelCaps.copyWith(color: Colors.grey.shade600));
  }

  Widget _buildTextField(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: captionStyle.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        TextFormField(
          decoration: InputDecoration(
            hintText: hint,
            border: const OutlineInputBorder(),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
      ],
    );
  }

  Widget _buildRoleDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Assigned Role *', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        DropdownButtonFormField<RoleType>(
          value: _selectedRole,
          items: RoleType.values.map((role) {
            return DropdownMenuItem(
              value: role,
              child: Text(role.name.toUpperCase()),
            );
          }).toList(),
          onChanged: (val) => setState(() => _selectedRole = val!),
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
