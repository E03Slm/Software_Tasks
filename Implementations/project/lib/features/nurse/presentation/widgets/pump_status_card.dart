import 'package:flutter/material.dart';
import '../../../../core/theme/nurse_theme.dart';

class PumpStatusCard extends StatelessWidget {
  final String status;
  final String? subtitle;
  final bool isAlarm;

  const PumpStatusCard({
    super.key,
    required this.status,
    this.subtitle,
    this.isAlarm = false,
  });

  @override
  Widget build(BuildContext context) {
    final nurseColors = Theme.of(context).extension<NurseColors>()!;
    
    Color backgroundColor;
    Color iconColor = Colors.white;
    IconData iconData;

    if (isAlarm) {
      backgroundColor = nurseColors.severityCritical.withValues(alpha: 0.1);
      iconColor = nurseColors.severityCritical;
      iconData = Icons.warning;
    } else {
      switch (status.toLowerCase()) {
        case 'infusing':
        case 'running':
          backgroundColor = nurseColors.successGreen.withValues(alpha: 0.1);
          iconColor = nurseColors.successGreen;
          iconData = Icons.play_arrow;
          break;
        case 'paused':
        case 'kvo':
          backgroundColor = nurseColors.pauseAmber.withValues(alpha: 0.1);
          iconColor = nurseColors.pauseAmber;
          iconData = Icons.pause;
          break;
        default:
          backgroundColor = nurseColors.stopGrey.withValues(alpha: 0.1);
          iconColor = nurseColors.stopGrey;
          iconData = Icons.stop;
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: iconColor.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor,
              shape: BoxShape.circle,
            ),
            child: Icon(iconData, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                status.toUpperCase(),
                style: TextStyle(
                  color: iconColor,
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                  letterSpacing: 2.0,
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
