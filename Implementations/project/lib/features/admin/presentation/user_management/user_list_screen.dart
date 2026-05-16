import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:project/features/admin/presentation/providers/admin_providers.dart';
import 'package:project/features/auth/presentation/providers/auth_provider.dart';
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
            final nationalId = user.id.toLowerCase();
            final role = user.role.toString().split('.').last.toLowerCase();
            final fullName = user.fullName.toLowerCase();
            return nationalId.contains(searchQuery) || 
                   role.contains(searchQuery) || 
                   fullName.contains(searchQuery);
          }).toList();

          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(adminUserListProvider),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search users by ID or role...',
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
                      padding: const EdgeInsets.only(bottom: 80),
                      itemCount: filteredUsers.length,
                      separatorBuilder: (context, index) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final user = filteredUsers[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: _getRoleColor(user.role).withOpacity(0.1),
                            child: Icon(_getRoleIcon(user.role), color: _getRoleColor(user.role)),
                          ),
                          title: Text(user.fullName, 
                                     style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          subtitle: Text(
                            'Role: ${user.role.toString().split('.').last.toUpperCase()}\n'
                            'Created: ${user.createdAt != null ? DateFormat('MMM dd, yyyy HH:mm').format(user.createdAt!) : "N/A"} • '
                            'Last Login: ${user.lastLogin != null ? DateFormat('MMM dd, yyyy HH:mm').format(user.lastLogin!) : (user.createdAt != null ? DateFormat('MMM dd, yyyy HH:mm').format(user.createdAt!) : "N/A")}',
                            style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                          ),
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
          ),
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
      case 'NURSE': return Colors.blue;
      case 'PATIENT': return Colors.orange;
      default: return Colors.grey;
    }
  }

  IconData _getRoleIcon(RoleType role) {
    final roleName = role.toString().split('.').last.toUpperCase();
    switch (roleName) {
      case 'ADMIN': return Icons.admin_panel_settings;
      case 'DOCTOR': return Icons.medical_services;
      case 'NURSE': return Icons.medical_information;
      case 'PATIENT': return Icons.person;
      default: return Icons.help_outline;
    }
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, ManagedUser user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text('Are you sure you want to delete user "${user.id.substring(0, 8)}..."? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () async {
              final currentUser = ref.read(authProvider);
              final performerId = currentUser?.id ?? 'SYSTEM';
              await ref.read(adminRepositoryProvider).deleteUser(user.id, performerId);
              ref.invalidate(adminUserListProvider);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('DELETE', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
