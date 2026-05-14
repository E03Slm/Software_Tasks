import 'package:flutter/material.dart';
import '../../../core/theme.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(spaceMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stat Cards Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: spaceMd,
              crossAxisSpacing: spaceMd,
              childAspectRatio: 1.2,
              children: [
                const _StatCard(
                  label: 'System Uptime',
                  value: '99.9%',
                  subtitle: 'Last restart: 14d',
                  icon: Icons.check_circle,
                  iconColor: Colors.green,
                ),
                const _StatCard(
                  label: 'Active Sessions',
                  value: '42',
                  subtitle: '3 Admins, 39 Nurses',
                  icon: Icons.people,
                  iconColor: Color(0xFF6200EA),
                ),
                _StatusProgressCard(
                  label: 'Engine Status',
                  value: 'Stable',
                  progress: 0.8,
                  icon: Icons.settings,
                  color: Colors.blue,
                ),
                _StatusProgressCard(
                  label: 'Memory Usage',
                  value: '82%',
                  progress: 0.82,
                  icon: Icons.memory,
                  color: Colors.amber,
                ),
              ],
            ),
            const SizedBox(height: spaceLg),

            // Active Alerts Card
            const _ActiveAlertsCard(),
            const SizedBox(height: spaceMd),

            // Safety Limits Banner
            const _SafetyLimitsBanner(),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color iconColor;

  const _StatCard({
    required this.label,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(spaceMd)),
      child: Padding(
        padding: const EdgeInsets.all(spaceMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 24),
            const SizedBox(height: spaceSm),
            Text(value, style: dataDisplay),
            Text(label, style: titleStyle.copyWith(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 4),
            Text(subtitle, style: captionStyle.copyWith(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

class _StatusProgressCard extends StatelessWidget {
  final String label;
  final String value;
  final double progress;
  final IconData icon;
  final Color color;

  const _StatusProgressCard({
    required this.label,
    required this.value,
    required this.progress,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(spaceMd)),
      child: Padding(
        padding: const EdgeInsets.all(spaceMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: spaceSm),
            Text(value, style: titleStyle),
            Text(label, style: captionStyle.copyWith(color: Colors.grey)),
            const SizedBox(height: spaceSm),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: color.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation(color),
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActiveAlertsCard extends StatelessWidget {
  const _ActiveAlertsCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(spaceMd)),
      child: Padding(
        padding: const EdgeInsets.all(spaceMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Active Alerts', style: titleStyle),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: const Color(0xFFE53935), borderRadius: BorderRadius.circular(12)),
                  child: const Text('2', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: spaceMd),
            _AlertRow(
              color: Colors.red,
              icon: Icons.error,
              title: 'Critical DB Connectivity',
              body: 'Slave node #4 is unresponsive',
            ),
            const Divider(),
            _AlertRow(
              color: Colors.amber,
              icon: Icons.warning,
              title: 'Latency Threshold',
              body: 'API response time > 400ms',
            ),
          ],
        ),
      ),
    );
  }
}

class _AlertRow extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String title;
  final String body;

  const _AlertRow({required this.color, required this.icon, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(border: Border(left: BorderSide(color: color, width: 3))),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title, style: bodyStyle.copyWith(fontWeight: FontWeight.bold)),
        subtitle: Text(body, style: captionStyle),
      ),
    );
  }
}

class _SafetyLimitsBanner extends StatelessWidget {
  const _SafetyLimitsBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(spaceMd),
      decoration: BoxDecoration(color: const Color(0xFF6200EA), borderRadius: BorderRadius.circular(spaceMd)),
      child: Row(
        children: [
          const Icon(Icons.security, color: Colors.white, size: 32),
          const SizedBox(width: spaceMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Safety Limits', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Text('View global guardrails', style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.white),
        ],
      ),
    );
  }
}
