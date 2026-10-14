import 'package:flutter/material.dart';

/// Renders the section heading and description for APOD.
class ApodExplanationSection extends StatelessWidget {
  final String explanation;

  const ApodExplanationSection({super.key, required this.explanation});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Explanation",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          explanation.isEmpty ? "No explanation provided." : explanation,
          style: const TextStyle(
            fontSize: 15,
            height: 1.6,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}
