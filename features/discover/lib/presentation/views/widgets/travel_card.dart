import 'package:flutter/material.dart';

class TravelPackCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String buttonText;
  final bool hasSelection;
  final String? selectedDetails;
  final VoidCallback onTap;
  final VoidCallback? onChangeTap;

  const TravelPackCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.hasSelection,
    this.selectedDetails,
    required this.onTap,
    this.onChangeTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 24),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
          const SizedBox(height: 12),
          if (!hasSelection)
            GestureDetector(
              onTap: onTap,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      buttonText,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const Icon(Icons.add, color: Colors.orange, size: 20),
                  ],
                ),
              ),
            )
          else
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      selectedDetails ?? '',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  GestureDetector(
                    onTap: onChangeTap,
                    child: Row(
                      children: const [
                        Text(
                          'Change',
                          style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(Icons.edit, color: Colors.orange, size: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}