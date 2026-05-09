import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/infusion_provider.dart';
import '../../domain/models/alarm.dart';
import '../../../../core/theme/nurse_theme.dart';
import '../../../../core/theme/app_theme.dart';
import '../widgets/nurse_widgets.dart';
import 'widgets/alarm_activation_panel.dart';

class PumpDashboardScreen extends ConsumerWidget {
  const PumpDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nurseColors = Theme.of(context).extension<NurseColors>()!;
    final session = ref.watch(infusionProvider);
    final battery = ref.watch(batteryProvider);
    final alarms = ref.watch(alarmProvider);
    final notifier = ref.read(infusionProvider.notifier);
    final canContinue = ref.watch(alarmProvider.notifier).canContinue;

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
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status Header Row
            Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                PumpStatusCard(
                  status: isAlarm && alarms.isNotEmpty ? 'ALARM: ${alarms.first.type}' : session.status,
                  subtitle: isRunning ? 'Infusion Active - Channel A' : 'Ready to start',
                  isAlarm: isAlarm,
                ),
                PowerStatusCard(
                  batteryLevel: battery,
                  isACConnected: true, // Mocked for now
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Main Bento Grid
            LayoutBuilder(
              builder: (context, constraints) {
                final bool isDesktop = constraints.maxWidth > 800;
                return isDesktop
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 2, child: _buildParametersSection(context, session, notifier)),
                          const SizedBox(width: 24),
                          Expanded(flex: 1, child: _buildProgressSection(context, session, notifier)),
                        ],
                      )
                    : Column(
                        children: [
                          _buildParametersSection(context, session, notifier),
                          const SizedBox(height: 24),
                          _buildProgressSection(context, session, notifier),
                        ],
                      );
              },
            ),
            const SizedBox(height: 24),

            // Controls Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.5,
              children: [
                PumpControlButton(
                  icon: Icons.play_circle,
                  label: 'Start',
                  color: nurseColors.successGreen,
                  onPressed: isRunning || !canContinue ? null : () => notifier.start(),
                ),
                PumpControlButton(
                  icon: Icons.pause_circle,
                  label: 'Pause',
                  color: nurseColors.pauseAmber,
                  onPressed: !isRunning ? null : () => notifier.pause(),
                ),
                PumpControlButton(
                  icon: Icons.play_arrow_outlined,
                  label: 'Resume',
                  color: nurseColors.severityInfo,
                  onPressed: !isPaused || !canContinue ? null : () => notifier.start(),
                ),
                PumpControlButton(
                  icon: Icons.stop_circle,
                  label: 'Stop',
                  color: nurseColors.stopGrey,
                  onPressed: isStopped ? null : () => notifier.stop(),
                ),
              ],
            ),
            const SizedBox(height: 24),

            EmergencyStopButton(
              onStop: () => notifier.stop(),
            ),
            
            const SizedBox(height: 24),
            const AlarmActivationPanel(),
            const SizedBox(height: 24),
            
            if (!isRunning)
              ElevatedButton.icon(
                onPressed: () {
                  if (session.drug != null) {
                    context.push('/nurse/parameters');
                  } else {
                    context.push('/nurse/drug-selection');
                  }
                },
                icon: Icon(session.status == 'Programming' || session.drug != null ? Icons.edit_note : Icons.add),
                label: Text(session.status == 'Programming' || session.drug != null ? 'CONTINUE PROGRAMMING' : 'NEW INFUSION'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: (session.status == 'Programming' || session.drug != null) ? Theme.of(context).colorScheme.secondaryContainer : null,
                  foregroundColor: (session.status == 'Programming' || session.drug != null) ? Theme.of(context).colorScheme.onSecondaryContainer : null,
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  minimumSize: const Size(double.infinity, 64),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildParametersSection(BuildContext context, dynamic session, dynamic notifier) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
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
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
                  ),
                  child: const Text('ID: 884920-A', style: TextStyle(fontSize: 10, fontFamily: 'monospace')),
                ),
              ],
            ),
            const SizedBox(height: 32),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 32,
              crossAxisSpacing: 16,
              childAspectRatio: 2.5,
              children: [
                ParameterDisplayCard(
                  label: 'Infusion Rate',
                  value: session.infusionRate.toStringAsFixed(1),
                  unit: 'mL/hr',
                ),
                ParameterDisplayCard(
                  label: 'Volume Infused',
                  value: session.volumeInfused.toStringAsFixed(3), // Increased precision for visibility
                  unit: 'mL',
                ),
                ParameterDisplayCard(
                  label: 'Volume Remaining',
                  value: (session.totalVolume - session.volumeInfused).clamp(0.0, double.infinity).toStringAsFixed(3),
                  unit: 'mL',
                ),
                ParameterDisplayCard(
                  label: 'Time Remaining',
                  value: notifier.timeRemaining.toString().split('.').first.substring(0, 5),
                  unit: 'hh:mm',
                  valueColor: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressSection(BuildContext context, dynamic session, dynamic notifier) {
    return InfusionProgressCard(
      progress: notifier.progressFraction,
      drugName: session.drug?.name ?? 'No Medication',
      containerInfo: '${session.totalVolume.toStringAsFixed(0)} mL Bag',
    );
  }
}

