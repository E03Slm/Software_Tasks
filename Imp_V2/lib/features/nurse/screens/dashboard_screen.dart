import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../simulation/infusion_state_machine.dart';
import '../simulation/battery_notifier.dart';
import '../simulation/models/infusion_state.dart';
import '../../../core/theme.dart';

class PumpDashboardScreen extends ConsumerWidget {
  const PumpDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(infusionProvider);
    final battery = ref.watch(batteryProvider);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(spaceMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // New Infusion Action Card
            _NewInfusionCard(onTap: () => context.push('/nurse/drug-selection')),
            const SizedBox(height: spaceLg),

            // Status Pill
            _StatusPill(state: session.currentState),
            const SizedBox(height: spaceMd),

            // Battery Row
            Row(
              children: [
                Icon(
                  Icons.battery_charging_full,
                  size: 16,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: spaceXs),
                Text(
                  '${battery.toStringAsFixed(0)}%  ⚡ AC POWER',
                  style: captionStyle.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
              ],
            ),
            const SizedBox(height: spaceSm),

            // Active Parameters Card
            _ParametersCard(session: session),
            const SizedBox(height: spaceMd),

            // VTBI Progress Card
            _ProgressCard(session: session),
            const SizedBox(height: spaceLg),

            // Pump Controls
            const _PumpControls(),
          ],
        ),
      ),
    );
  }
}

class _NewInfusionCard extends StatelessWidget {
  final VoidCallback onTap;
  const _NewInfusionCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(spaceLg),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF005EA4), Color(0xFF003D6D)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(spaceMd),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF005EA4).withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Colors.white24,
              child: Icon(Icons.add, color: Colors.white),
            ),
            const SizedBox(width: spaceMd),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('NEW INFUSION', style: titleStyle.copyWith(color: Colors.white, fontSize: 18)),
                Text('Select drug and program parameters', style: captionStyle.copyWith(color: Colors.white70)),
              ],
            ),
            const Spacer(),
            const Icon(Icons.chevron_right, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final InfusionState state;
  const _StatusPill({required this.state});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;
    switch (state) {
      case InfusionState.running:
        color = Colors.green;
        label = 'RUNNING';
        break;
      case InfusionState.paused:
        color = Colors.amber;
        label = 'PAUSED';
        break;
      case InfusionState.alarm:
        color = Colors.red;
        label = 'ALARM';
        break;
      case InfusionState.idle:
        color = Colors.grey;
        label = 'IDLE';
        break;
      default:
        color = Colors.blue;
        label = state.name.toUpperCase();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: labelCaps.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

class _ParametersCard extends StatelessWidget {
  final dynamic session;
  const _ParametersCard({required this.session});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(spaceMd)),
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(spaceMd),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _ParamItem(
                    label: 'INFUSION RATE',
                    value: '${session.infusionRate.toStringAsFixed(1)}',
                    unit: 'mL/hr',
                  ),
                ),
                Expanded(
                  child: _ParamItem(
                    label: 'VOLUME INFUSED',
                    value: '${session.volumeInfused.toStringAsFixed(1)}',
                    unit: 'mL',
                  ),
                ),
              ],
            ),
            const Divider(height: spaceLg),
            Row(
              children: [
                Expanded(
                  child: _ParamItem(
                    label: 'VOLUME REMAINING',
                    value: '${session.volumeRemaining.toStringAsFixed(1)}',
                    unit: 'mL',
                    valueColor: Colors.blue,
                  ),
                ),
                Expanded(
                  child: _ParamItem(
                    label: 'TIME REMAINING',
                    value: _formatTime(session.volumeRemaining, session.infusionRate),
                    unit: 'hh:mm',
                    valueColor: Colors.blue,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(double remaining, double rate) {
    if (rate <= 0) return '--:--';
    final hours = remaining / rate;
    final h = hours.floor();
    final m = ((hours - h) * 60).round();
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
  }
}

class _ParamItem extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final Color? valueColor;

  const _ParamItem({
    required this.label,
    required this.value,
    required this.unit,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: labelCaps.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
        const SizedBox(height: spaceXs),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(value, style: dataDisplay.copyWith(color: valueColor)),
            const SizedBox(width: 4),
            Text(unit, style: captionStyle),
          ],
        ),
      ],
    );
  }
}

class _ProgressCard extends StatelessWidget {
  final dynamic session;
  const _ProgressCard({required this.session});

  @override
  Widget build(BuildContext context) {
    final progress = session.totalVolume > 0 ? (session.volumeInfused / session.totalVolume) : 0.0;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(spaceMd)),
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(spaceMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('VTBI PROGRESS', style: labelCaps),
                Text('${(progress * 100).toStringAsFixed(0)}%', style: labelCaps.copyWith(color: Colors.blue)),
              ],
            ),
            const SizedBox(height: spaceSm),
            LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
              backgroundColor: Colors.blue.withOpacity(0.1),
              valueColor: const AlwaysStoppedAnimation(Colors.blue),
            ),
            const SizedBox(height: spaceSm),
            Text('Drug: ${session.drug.name}', style: bodyStyle.copyWith(fontWeight: FontWeight.bold)),
            Text('Container: ${session.totalVolume.toStringAsFixed(0)} mL Bag', style: captionStyle),
          ],
        ),
      ),
    );
  }
}

class _PumpControls extends ConsumerWidget {
  const _PumpControls();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(infusionProvider).currentState;
    final notifier = ref.read(infusionProvider.notifier);

    final isRunning = state == InfusionState.running;
    final isPaused = state == InfusionState.paused;
    final isIdle = state == InfusionState.idle || state == InfusionState.programming;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: spaceMd,
      crossAxisSpacing: spaceMd,
      childAspectRatio: 2.5,
      children: [
        _ControlBtn(
          icon: Icons.play_arrow,
          label: 'START',
          onTap: isIdle ? () => notifier.start() : null,
          color: isIdle ? Colors.green : Colors.grey,
        ),
        _ControlBtn(
          icon: Icons.pause,
          label: 'PAUSE',
          onTap: isRunning ? () => notifier.pause() : null,
          color: isRunning ? Colors.amber : Colors.grey,
          outlined: true,
        ),
        _ControlBtn(
          icon: Icons.play_circle_outline,
          label: 'RESUME',
          onTap: isPaused ? () => notifier.resume() : null,
          color: isPaused ? Colors.blue : Colors.grey,
        ),
        _ControlBtn(
          icon: Icons.stop,
          label: 'STOP',
          onTap: (isRunning || isPaused) ? () => notifier.stop() : null,
          color: (isRunning || isPaused) ? Colors.grey : Colors.grey,
          outlined: true,
        ),
      ],
    );
  }
}

class _ControlBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Color color;
  final bool outlined;

  const _ControlBtn({
    required this.icon,
    required this.label,
    this.onTap,
    required this.color,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: outlined ? Colors.white : (onTap == null ? color.withOpacity(0.1) : color),
          borderRadius: BorderRadius.circular(spaceSm),
          border: outlined ? Border.all(color: color) : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: outlined ? color : (onTap == null ? color : Colors.white)),
            Text(
              label,
              style: labelCaps.copyWith(color: outlined ? color : (onTap == null ? color : Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
