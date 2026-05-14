import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme.dart';
import '../../auth/models/role_type.dart';
import '../admin_repository.dart';

class UserListScreen extends ConsumerWidget {
  const UserListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(adminUsersProvider);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(spaceMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('User Management', style: titleStyle.copyWith(fontSize: 28, fontWeight: FontWeight.bold)),
            Text('Manage clinical and administrative access', style: bodyStyle.copyWith(color: Colors.grey)),
            const SizedBox(height: spaceMd),

            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Search by ID or Role...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(spaceXl)),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: spaceMd),

            // User List Card
            usersAsync.when(
              data: (users) => users.isEmpty 
                ? _buildEmptyState()
                : Card(
                    elevation: 0,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(spaceMd)),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: users.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final user = users[index];
                        final role = RoleType.values.firstWhere(
                          (e) => e.name == user['role'].toString().toLowerCase(),
                          orElse: () => RoleType.nurse,
                        );
                        return _UserListItem(
                          id: user['user_id'],
                          displayName: '${user['Fname']} ${user['Lname']}',
                          role: role,
                          lastLogin: user['last_login'] != null ? 'Active' : 'Never',
                        );
                      },
                    ),
                  ),
              loading: () => const Center(child: Padding(
                padding: EdgeInsets.all(spaceXl),
                child: CircularProgressIndicator(),
              )),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
            const SizedBox(height: spaceLg),

            // System Access Card
            const _SystemAccessCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(spaceXl),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(spaceMd),
      ),
      child: Column(
        children: [
          const Icon(Icons.person_off_outlined, size: 64, color: Colors.grey),
          const SizedBox(height: spaceMd),
          Text('No Users Registered', style: titleStyle),
          const SizedBox(height: spaceSm),
          const Text('The personnel database is currently empty.', style: captionStyle),
        ],
      ),
    );
  }
}

class _UserListItem extends StatelessWidget {
  final String id;
  final String displayName;
  final RoleType role;
  final String lastLogin;

  const _UserListItem({required this.id, required this.displayName, required this.role, required this.lastLogin});

  @override
  Widget build(BuildContext context) {
    Color roleColor;
    Color bgColor;
    switch (role) {
      case RoleType.doctor:
        roleColor = const Color(0xFF00685D);
        bgColor = const Color(0xFFE0F2F1);
        break;
      case RoleType.nurse:
        roleColor = const Color(0xFF005EA4);
        bgColor = const Color(0xFFE3F2FD);
        break;
      case RoleType.admin:
        roleColor = const Color(0xFF6200EA);
        bgColor = const Color(0xFFF3E5F5);
        break;
    }

    return ListTile(
      onTap: () => context.push('/admin/users/$id/edit'),
      leading: CircleAvatar(
        backgroundColor: bgColor,
        child: Text(role.name[0].toUpperCase(), style: TextStyle(color: roleColor, fontWeight: FontWeight.bold)),
      ),
      title: Text(displayName, style: bodyStyle.copyWith(fontWeight: FontWeight.bold)),
      subtitle: Text('Last login: $lastLogin', style: captionStyle),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(color: roleColor, borderRadius: BorderRadius.circular(999)),
        child: Text(
          role.name.toUpperCase(),
          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class _SystemAccessCard extends StatelessWidget {
  const _SystemAccessCard();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(spaceLg),
          decoration: BoxDecoration(color: const Color(0xFF6200EA), borderRadius: BorderRadius.circular(spaceMd)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('System Access', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              const SizedBox(height: spaceSm),
              const Text('Live Monitoring', style: TextStyle(color: Colors.white70, fontSize: 14)),
              const SizedBox(height: spaceMd),
              Text('ACTIVE', style: dataDisplay.copyWith(color: Colors.white)),
            ],
          ),
        ),
        Positioned(
          right: spaceMd,
          bottom: spaceMd,
          child: FloatingActionButton(
            onPressed: () => context.push('/admin/users/add'),
            backgroundColor: const Color(0xFF4A00B4),
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
