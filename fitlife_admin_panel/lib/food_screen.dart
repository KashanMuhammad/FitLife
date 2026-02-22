import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitlife_admin_panel/upload_food_screen.dart';
import 'package:flutter/material.dart';

class FoodScreen extends StatefulWidget {
  final VoidCallback? onUploadPressed;

  const FoodScreen({super.key, this.onUploadPressed});

  @override
  State<FoodScreen> createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {
  int selectedToggleIndex = 0;

  final TextEditingController _searchController = TextEditingController();
  String searchQuery = "";

  bool _isCreatedToday(String? createdAt) {
    if (createdAt == null || createdAt.isEmpty) return false;
    try {
      final createdDate = DateTime.parse(createdAt);
      final now = DateTime.now();
      return createdDate.year == now.year &&
          createdDate.month == now.month &&
          createdDate.day == now.day;
    } catch (_) {
      return false;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const Divider(height: 20),
            _buildTopBar(),
            const SizedBox(height: 20),

            const Text(
              "All Foods",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildFoodsTable(isAvoid: false),

            const SizedBox(height: 30),
            const Text(
              "Foods To Avoid",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildFoodsTable(isAvoid: true),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: const [
        Text(
          "Foods",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [Text("Cody Fisher"), Text("Dashboard Manager")],
        ),
        SizedBox(width: 10),
        CircleAvatar(
          radius: 24,
          backgroundImage: AssetImage("assets/male avatar.png"),
        ),
      ],
    );
  }

  Widget _buildTopBar() {
    return Row(
      children: [
        Row(
          children: [
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => setState(() => selectedToggleIndex = 0),
                child: _toggleBtn("All Foods", selectedToggleIndex == 0),
              ),
            ),
            // const SizedBox(width: 10),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => setState(() => selectedToggleIndex = 1),
                child: _toggleBtn("New Uploads", selectedToggleIndex == 1),
              ),
            ),
          ],
        ),

        const Spacer(),
        SizedBox(
          width: 250,
          child: TextField(
            controller: _searchController,
            onChanged: (v) {
              setState(() => searchQuery = v.toLowerCase().trim());
            },
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: "Search foods by name",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        const SizedBox(width: 15),

        Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF5AFF15), Color(0xFF00B712)],
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ElevatedButton.icon(
            onPressed: widget.onUploadPressed,
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text(
              "Upload Food",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(0, 56), // 🔥 height increased
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _toggleBtn(String text, bool selected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        gradient:
            selected
                ? const LinearGradient(
                  colors: [Color(0xFF5AFF15), Color(0xFF00B712)],
                )
                : null,
        color: selected ? null : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: selected ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  Widget _buildFoodsTable({required bool isAvoid}) {
    return Card(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("Foods").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Padding(
              padding: EdgeInsets.all(20),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          List<Map<String, dynamic>> foods = [];
          final key = isAvoid ? "foods_to_avoid" : "foods_to_eat";

          for (var doc in snapshot.data!.docs) {
            final data = doc.data() as Map<String, dynamic>;

            if (data[key] is List) {
              for (var f in data[key]) {
                final food = Map<String, dynamic>.from(f);

                food["selectedTag"] = doc.id;
                food["foodType"] = isAvoid ? "avoid" : "eat"; // ✅ FIX

                if (selectedToggleIndex == 1 &&
                    !_isCreatedToday(food["createdAt"]))
                  continue;

                if (searchQuery.isNotEmpty) {
                  final name =
                      (food["foodName"] ?? "").toString().toLowerCase();
                  if (!name.contains(searchQuery)) continue;
                }

                foods.add(food);
              }
            }
          }

          return _buildTable(foods);
        },
      ),
    );
  }

  Widget _buildTable(List<Map<String, dynamic>> foods) {
    return DataTable(
      headingRowColor: WidgetStateProperty.all(Colors.grey[200]),
      headingTextStyle: const TextStyle(fontWeight: FontWeight.bold),
      border: TableBorder.all(color: Colors.grey.shade300),
      columns: const [
        DataColumn(label: Text("Image")),
        DataColumn(label: Text("Food Name")),
        DataColumn(label: Text("Qty")),
        DataColumn(label: Text("Unit")),
        DataColumn(label: Text("Calories")),
        DataColumn(label: Text("Tag")),
        DataColumn(label: Text("Actions")),
      ],
      rows:
          foods.map((food) {
            return DataRow(
              cells: [
                DataCell(
                  food["foodImageUrl"] != null
                      ? Image.network(food["foodImageUrl"], width: 50)
                      : const Icon(Icons.image),
                ),
                DataCell(Text(food["foodName"] ?? "")),
                DataCell(Text(food["quantity"] ?? "")),
                DataCell(Text(food["selectedUnits"] ?? "")),
                DataCell(Text(food["caloriesPerServing"] ?? "")),
                DataCell(Text(food["selectedTag"] ?? "")),
                DataCell(
                  PopupMenuButton(
                    onSelected: (_) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => UploadFoodScreen(foodData: food),
                        ),
                      );
                    },
                    itemBuilder:
                        (_) => const [
                          PopupMenuItem(value: "edit", child: Text("Form")),
                        ],
                  ),
                ),
              ],
            );
          }).toList(),
    );
  }
}
