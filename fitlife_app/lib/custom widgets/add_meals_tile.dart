import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddMealsTile extends StatefulWidget {
  final String itemName;
  final String kcal;
  final String subtitle;
  final Function(int) onAdd;
  final String? foodImageUrl;
  const AddMealsTile({
    super.key,
    required this.itemName,
    required this.kcal,
    required this.subtitle,
    required this.onAdd,
    required this.foodImageUrl,
  });

  @override
  State<AddMealsTile> createState() => _AddMealsTileState();
}

class _AddMealsTileState extends State<AddMealsTile> {
  int number = 0;

  void increment() {
    setState(() {
      number++;
    });
  }

  void decrement() {
    setState(() {
      if (number > 0) number--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              widget.foodImageUrl ?? 'https://via.placeholder.com/45',
              width: 45,
              height: 45,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.fastfood,
                size: 40,
                color: Colors.grey[400],
              ),
            ),
          ),


          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.itemName,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Row(
                  children: [
                    Text(widget.subtitle),
                    Text(
                      "  ${widget.kcal} kcl",
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: 70,
            height: 30,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.greenAccent),
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: decrement,
                  child: const Icon(
                    Icons.remove,
                    size: 16,
                    color: Colors.green,
                  ),
                ),
                Text(
                  number.toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                InkWell(
                  onTap: increment,
                  child: const Icon(Icons.add, size: 16, color: Colors.green),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          InkWell(
            onTap: () {
              if(number>0){
                widget.onAdd(number);
              }
            },
            child: Container(
              height: 35,
              width: 50,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [Color(0xFF5AFF15), Color(0xFF00B712)],
                ),
              ),
              child: const Center(
                child: Text("Add", style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
