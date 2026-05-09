import 'package:flutter/material.dart';
import '../../../../core/theme/nurse_theme.dart';

class PowerStatusCard extends StatelessWidget {
  final double batteryLevel;
  final bool isACConnected;

  const PowerStatusCard({
    super.key,
    required this.batteryLevel,
    this.isACConnected = true,
  });

  @override
  Widget build(BuildContext context) {
    final nurseColors = Theme.of(context).extension<NurseColors>()!;
    final batteryColor = batteryLevel > 20 
        ? nurseColors.successGreen 
        : (batteryLevel > 10 ? nurseColors.pauseAmber : nurseColors.severityCritical);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                batteryLevel > 80 ? Icons.battery_full : Icons.battery_5_bar,
                color: batteryColor,
              ),
              const SizedBox(width: 8),
              Text(
                '${batteryLevel.toStringAsFixed(0)}%',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: batteryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Container(width: 1, height: 32, color: Theme.of(context).colorScheme.outlineVariant),
          const SizedBox(width: 16),
          Row(
            children: [
              Icon(
                isACConnected ? Icons.bolt : Icons.power_off,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                isACConnected ? 'AC POWER' : 'BATTERY',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
