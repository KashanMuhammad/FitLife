import 'package:flutter/material.dart';

class SummaryMealsTile extends StatelessWidget {
  final String itemName;
  final String kcal;
  final int qty;
  final double width;
  final VoidCallback onDelete;
  final String? foodImageUrl;

  const SummaryMealsTile({
    super.key,
    required this.itemName,
    required this.kcal,
    required this.qty,
    required this.width,
    required this.onDelete,
    required this.foodImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          // Grey placeholder (or you can keep SvgPicture here if needed)
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              foodImageUrl ?? 'https://via.placeholder.com/40',
              width: 40,
              height: 40,
              fit: BoxFit.cover,
              errorBuilder:
                  (context, error, stackTrace) => Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.fastfood, color: Colors.grey),
                  ),
            ),
          ),
          SizedBox(width: 15),
          // Food info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  itemName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  "$kcal Kcal",
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),

          // 🔴 Quantity circle
          Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red,
            ),
            child: Text(
              qty.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 6),

          // ❌ Delete button
          InkWell(
            onTap: onDelete,
            child: const Icon(Icons.close, color: Colors.red, size: 18),
          ),
        ],
      ),
    );
  }
}
