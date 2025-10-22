import 'package:flutter/material.dart';

class AnimatedStepProgressIndicator extends StatelessWidget {
  const AnimatedStepProgressIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.showLabel = true,
    this.progressColor = Colors.orange,
    this.backgroundColor = const Color(0xFFE0E0E0),
    this.height = 6.0,
    this.duration = const Duration(milliseconds: 400),
  });
  
  final int currentStep;
  final int totalSteps;
  final bool showLabel;
  final Color progressColor;
  final Color backgroundColor;
  final double height;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    double progress = (currentStep / totalSteps).clamp(0.0, 1.0);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Progress bar
        Expanded(
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              // Background bar
              Container(
                height: height,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(height / 2),
                ),
              ),
              // Animated progress bar
              AnimatedFractionallySizedBox(
                widthFactor: progress,
                duration: duration,
                curve: Curves.easeInOut,
                child: Container(
                  height: height,
                  decoration: BoxDecoration(
                    color: progressColor,
                    borderRadius: BorderRadius.circular(height / 2),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Optional label
        if (showLabel) ...[
          const SizedBox(width: 8),
          Text(
            '$currentStep/$totalSteps',
            style: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
}
