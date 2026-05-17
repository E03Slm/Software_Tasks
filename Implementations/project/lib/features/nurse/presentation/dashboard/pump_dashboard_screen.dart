import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/infusion_provider.dart';
import '../../domain/models/alarm.dart';
import '../../../../core/theme/nurse_theme.dart';
import '../../../../core/theme/app_theme.dart';
import '../widgets/nurse_widgets.dart';
import 'widgets/alarm_activation_panel.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class PumpDashboardScreen extends ConsumerWidget {
  const PumpDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nurseColors = Theme.of(context).extension<NurseColors>()!;
    final session = ref.watch(infusionProvider);
    final powerState = ref.watch(batteryProvider);
    final alarms = ref.watch(alarmProvider);
    final notifier = ref.read(infusionProvider.notifier);
    final canContinue = ref.watch(alarmProvider.notifier).canContinue;
    final user = ref.watch(authProvider);

    final nurseName = user != null 
        ? '${user.fname ?? ''} ${user.lname ?? ''}'.trim() 
        : 'Unknown Nurse';

    final isRunning = session.status == 'Infusing' || session.status == 'KVO';
    final isAlarm = session.status == 'Alarm';
    final isPaused = session.status == 'Paused';
    final isStopped = session.status == 'Stopped' || session.status == 'Idle';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Infusion Simulator'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Text(
                    'NURSE',
                    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 12),
                const Icon(Icons.account_circle, size: 32),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status Header Row
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                PumpStatusCard(
                  status: isAlarm && alarms.isNotEmpty ? 'ALARM: ${alarms.first.type}' : session.status,
                  subtitle: isRunning ? 'Infusion Active - Channel A' : 'Ready to start',
                  isAlarm: isAlarm,
                ),
                PowerStatusCard(
                  batteryLevel: powerState.level,
                  isACConnected: powerState.isACConnected,
                ),
              ],
            ),
            const SizedBox(height: 12),
            // ... rest of the code reduced spacing ...

            // Main Bento Grid
            LayoutBuilder(
              builder: (context, constraints) {
                final bool isDesktop = constraints.maxWidth > 800;
                return isDesktop
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 2, child: _buildParametersSection(context, session, notifier, nurseName)),
                          const SizedBox(width: 12),
                          Expanded(flex: 1, child: _buildProgressSection(context, session, notifier)),
                        ],
                      )
                    : Column(
                        children: [
                          _buildParametersSection(context, session, notifier, nurseName),
                          const SizedBox(height: 12),
                          _buildProgressSection(context, session, notifier),
                        ],
                      );
              },
            ),
            const SizedBox(height: 12),

            // Smart Primary Control
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              child: ElevatedButton.icon(
                onPressed: isAlarm || !canContinue ? null : () {
                  if (isRunning) {
                    notifier.pause();
                  } else {
                    notifier.start();
                  }
                },
                icon: Icon(
                  isRunning ? Icons.pause_circle_filled_rounded : Icons.play_circle_filled_rounded,
                  size: 24,
                ),
                label: Text(
                  isRunning 
                    ? 'PAUSE' 
                    : isPaused ? 'RESUME' : 'START',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isRunning ? nurseColors.pauseAmber : nurseColors.successGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 12),
            const AlarmActivationPanel(),
          ],
        ),
      ),
    );
  }

  Widget _buildParametersSection(BuildContext context, dynamic session, dynamic notifier, String nurseName) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ACTIVE PARAMETERS',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2)),
                  ),
                  child: Text(
                    nurseName.toUpperCase(),
                    style: TextStyle(
                      fontSize: 11, 
                      fontFamily: 'monospace', 
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                SizedBox(
                  width: (MediaQuery.of(context).size.width - 64) / 2, // Approximate 2-column on phone
                  child: ParameterDisplayCard(
                    label: 'Infusion Rate',
                    value: session.infusionRate.toStringAsFixed(1),
                    unit: 'mL/hr',
                  ),
                ),
                SizedBox(
                  width: (MediaQuery.of(context).size.width - 64) / 2,
                  child: ParameterDisplayCard(
                    label: 'Volume Infused',
                    value: session.volumeInfused.toStringAsFixed(2),
                    unit: 'mL',
                  ),
                ),
                SizedBox(
                  width: (MediaQuery.of(context).size.width - 64) / 2,
                  child: ParameterDisplayCard(
                    label: 'Volume Remaining',
                    value: (session.totalVolume - session.volumeInfused).clamp(0.0, double.infinity).toStringAsFixed(2),
                    unit: 'mL',
                  ),
                ),
                SizedBox(
                  width: (MediaQuery.of(context).size.width - 64) / 2,
                  child: ParameterDisplayCard(
                    label: 'Time Remaining',
                    value: _formatDisplayTime(notifier.timeRemaining),
                    unit: 'hh:mm',
                    valueColor: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDisplayTime(Duration d) {
    if (d.inHours > 99) return "99:59";
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    return "${twoDigits(d.inHours)}:${twoDigits(d.inMinutes.remainder(60))}";
  }

  Widget _buildProgressSection(BuildContext context, dynamic session, dynamic notifier) {
    final isRunning = session.status == 'Infusing' || session.status == 'KVO';

    return Column(
      children: [
        InfusionProgressCard(
          progress: notifier.progressFraction,
          drugName: session.drug?.name ?? 'No Medication',
          containerInfo: '${session.totalVolume.toStringAsFixed(0)} mL Bag',
        ),
        if (!isRunning) ...[
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              if (session.status == 'Stopped') {
                notifier.reset();
                context.push('/nurse/drug-selection');
                return;
              }
              if (session.drug != null) {
                context.push('/nurse/parameters');
              } else {
                context.push('/nurse/drug-selection');
              }
            },
            icon: Icon(
              (session.status == 'Programming' || session.drug != null) && session.status != 'Stopped' 
                  ? Icons.edit_note 
                  : Icons.add
            ),
            label: Text(
              (session.status == 'Programming' || session.drug != null) && session.status != 'Stopped' 
                  ? 'CONTINUE' 
                  : 'NEW INFUSION'
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
              padding: const EdgeInsets.symmetric(vertical: 20),
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
        ],
      ],
    );
  }
}


