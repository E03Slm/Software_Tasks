import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:project/features/admin/domain/models/managed_user.dart';
import 'package:project/features/auth/domain/enums/role_type.dart';
import 'package:project/features/admin/presentation/providers/admin_providers.dart';

class UserEditorScreen extends ConsumerStatefulWidget {
  final String? userId;

  const UserEditorScreen({super.key, this.userId});

  @override
  ConsumerState<UserEditorScreen> createState() => _UserEditorScreenState();
}

class _UserEditorScreenState extends ConsumerState<UserEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  RoleType _selectedRole = RoleType.nurse;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.userId != null;
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();

    if (_isEditing) {
      // Find user in the list and populate fields
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final users = ref.read(adminUserListProvider).value;
        final user = users?.firstWhere((u) => u.id == widget.userId);
        if (user != null) {
          setState(() {
            _usernameController.text = user.username;
            _selectedRole = user.role;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'EDIT USER' : 'CREATE NEW USER'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) => (value == null || value.isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 24),
              if (!_isEditing) ...[
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => (value == null || value.isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 24),
              ],
              DropdownButtonFormField<RoleType>(
                value: _selectedRole,
                decoration: const InputDecoration(
                  labelText: 'User Role',
                  prefixIcon: Icon(Icons.badge),
                  border: OutlineInputBorder(),
                ),
                items: RoleType.values.map((role) {
                  return DropdownMenuItem(
                    value: role,
                    child: Text(role.toString().split('.').last.toUpperCase()),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) setState(() => _selectedRole = value);
                },
              ),
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: _saveUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(_isEditing ? 'UPDATE USER' : 'CREATE USER'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveUser() async {
    if (!_formKey.currentState!.validate()) return;

    final user = ManagedUser(
      id: widget.userId ?? '',
      username: _usernameController.text,
      role: _selectedRole,
    );

    try {
      if (_isEditing) {
        await ref.read(adminUserListProvider.notifier).updateUser(user);
      } else {
        await ref.read(adminUserListProvider.notifier).addUser(user, _passwordController.text);
      }
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving user: $e')),
        );
      }
    }
  }
}
