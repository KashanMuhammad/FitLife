import 'package:flutter/material.dart';

class SummaryMealsTile extends StatelessWidget {
  final String itemName;
  final String kcal;
  final double width;
  final VoidCallback onDelete;

  const SummaryMealsTile({
    super.key,
    required this.itemName,
    required this.kcal,
    required this.width,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Grey image placeholder
          Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(width: 10),
          // Food info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  itemName,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Text(
                  "$kcal Kcal",
                  style: const TextStyle(
                      fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),
          // ❌ Delete button
          InkWell(
            onTap: onDelete,
            child: const Icon(
              Icons.close,
              color: Colors.red,
              size: 20,
            ),
          )
        ],
      ),
    );
  }
}
