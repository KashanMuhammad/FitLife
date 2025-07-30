import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SummaryMealsTile extends StatelessWidget {
  final String itemName;
  final String kcal;
  final int? number;
  final double width;

  const SummaryMealsTile({
    super.key,
    required this.itemName,
    required this.kcal,
    required this.width,
    this.number = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset('assets/images/Rectangleimage.svg', width: 45, height: 45),

          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        itemName,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFFDD00), Color(0xFFFBB034)],
                        ),
                      ),
                      child: Center(
                        child: Text(
                          number.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text("$kcal Kcal", style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          const SizedBox(width: 15),
          SvgPicture.asset(
            'assets/images/Cross.svg',
            width: 20,
            height: 20,
          ),
        ],
      ),
    );
  }
}
