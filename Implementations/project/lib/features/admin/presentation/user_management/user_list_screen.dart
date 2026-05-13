import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:project/features/admin/presentation/providers/admin_providers.dart';
import 'package:project/features/admin/domain/models/managed_user.dart';
import 'package:project/features/auth/domain/enums/role_type.dart';

class UserListScreen extends ConsumerWidget {
  const UserListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(adminUserListProvider);
    final searchQuery = ref.watch(userSearchQueryProvider).toLowerCase();

    return Scaffold(
      body: usersAsync.when(
        data: (users) {
          final filteredUsers = users.where((user) {
            final username = user.username.toLowerCase();
            final role = user.role.toString().split('.').last.toLowerCase();
            return username.contains(searchQuery) || role.contains(searchQuery);
          }).toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search users by username or role...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (value) {
                    ref.read(userSearchQueryProvider.notifier).setQuery(value);
                  },
                ),
              ),
              Expanded(
                child: filteredUsers.isEmpty 
                  ? const Center(child: Text('No users found matching your search.'))
                  : ListView.separated(
                      itemCount: filteredUsers.length,
                      separatorBuilder: (context, index) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final user = filteredUsers[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: _getRoleColor(user.role).withOpacity(0.1),
                            child: Icon(_getRoleIcon(user.role), color: _getRoleColor(user.role)),
                          ),
                          title: Text(user.username, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('Role: ${user.role.toString().split('.').last.toUpperCase()}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {
                                  context.push('/admin/users/${user.id}/edit');
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _confirmDelete(context, ref, user),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/admin/users/add'),
        icon: const Icon(Icons.person_add),
        label: const Text('Add User'),
        backgroundColor: Colors.teal[700],
      ),
    );
  }

  Color _getRoleColor(RoleType role) {
    final roleName = role.toString().split('.').last.toUpperCase();
    switch (roleName) {
      case 'ADMIN': return Colors.purple;
      case 'DOCTOR': return Colors.teal;
      default: return Colors.blue;
    }
  }

  IconData _getRoleIcon(RoleType role) {
    final roleName = role.toString().split('.').last.toUpperCase();
    switch (roleName) {
      case 'ADMIN': return Icons.admin_panel_settings;
      case 'DOCTOR': return Icons.medical_services;
      default: return Icons.person;
    }
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, ManagedUser user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text('Are you sure you want to delete user "${user.username}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              ref.read(adminUserListProvider.notifier).deleteUser(user.id);
              Navigator.pop(context);
            },
            child: const Text('DELETE', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
