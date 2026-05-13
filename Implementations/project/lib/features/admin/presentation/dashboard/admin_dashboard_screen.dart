import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/admin_providers.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(systemStatsProvider);

    return Scaffold(
      body: statsAsync.when(
        data: (stats) => Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'System Overview',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.teal[800],
                ),
              ),
              const SizedBox(height: 24),
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 1,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 2.5,
                children: [
                  _buildStatCard(
                    context,
                    'Total Users',
                    stats['total_users'].toString(),
                    Icons.people,
                    Colors.blue,
                  ),
                  _buildStatCard(
                    context,
                    'Active Sessions',
                    stats['active_sessions'].toString(),
                    Icons.play_circle_fill,
                    Colors.green,
                  ),
                  _buildStatCard(
                    context,
                    'Total Alarms',
                    stats['total_alarms'].toString(),
                    Icons.warning,
                    Colors.orange,
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Text(
                'System Health',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Icon(Icons.check, color: Colors.white),
                  ),
                  title: const Text('Database Connectivity'),
                  subtitle: const Text('All systems operational'),
                  trailing: Text(
                    'Online',
                    style: TextStyle(color: Colors.green[700], fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Card(
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Icon(Icons.check, color: Colors.white),
                  ),
                  title: const Text('Supabase Auth Service'),
                  subtitle: const Text('Responsive'),
                  trailing: Text(
                    'Operational',
                    style: TextStyle(color: Colors.green[700], fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const Spacer(),
              Center(
                child: Text(
                  'v1.2.0-stable | Build 20260512',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String label, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
                Text(
                  value,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
