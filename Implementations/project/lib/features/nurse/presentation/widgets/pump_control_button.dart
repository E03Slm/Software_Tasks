import 'package:flutter/material.dart';

class PumpControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onPressed;
  final bool isFilled;

  const PumpControlButton({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    this.onPressed,
    this.isFilled = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onPressed == null;
    final Color effectiveColor = isDisabled ? Theme.of(context).colorScheme.outline.withValues(alpha: 0.5) : color;

    return Opacity(
      opacity: isDisabled ? 0.5 : 1.0,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          decoration: BoxDecoration(
            color: isFilled ? effectiveColor : effectiveColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: effectiveColor.withValues(alpha: 0.3)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 32,
                color: isFilled ? Colors.white : effectiveColor,
              ),
              const SizedBox(height: 12),
              Text(
                label.toUpperCase(),
                style: TextStyle(
                  color: isFilled ? Colors.white : effectiveColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
