import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitlife_app/custom%20widgets/add_meals_tile.dart';
import 'package:fitlife_app/meals_history_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared/user_0nboarding_data_model_class.dart';

class AddMealsScreen extends StatefulWidget {
  const AddMealsScreen({super.key});

  @override
  State<AddMealsScreen> createState() => _AddMealsScreenState();
}

class _AddMealsScreenState extends State<AddMealsScreen> {
  String selectedMealType= "Breakfast";
  List<String> mealTypes= ["Breakfast","Lunch","Dinner"];
FirebaseDataModelClass? userData;
bool _isloading=true;
@override
void initState(){
  super.initState();
  loadUserData();
}
Future<void> loadUserData()async{
  const userId="3UCi7hE0jHNl79r7dIzA3wl0D083";
  try{
    final doc= await FirebaseFirestore.instance.collection("Users").doc(userId).get();
    if(doc.exists){
      setState(() {
        userData= FirebaseDataModelClass.fromJson(doc.data()!);
        _isloading=false;
      });
    }
    else{
      setState(() {
        _isloading=false;
      });
    }
  }
  catch (e){
    print("Error fetching user data: $e");
    setState(()=> _isloading=true);
  }


}
  @override
  Widget build(BuildContext context) {
    if (_isloading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (userData == null) {
      return const Scaffold(
        body: Center(child: Text("No user data found")),
      );
    }

    final foods = userData!.assignedFoods ?? [];
    return Scaffold(
      backgroundColor: Colors.white,
      body: foods.isEmpty
          ? const Center(child: Text("No foods assigned"))
          : SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SizedBox(height: 15),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.arrow_back_ios),
                    ),
                    const SizedBox(width: 100),
                    const Text(
                      "Add Meals",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    // 🔍 Search field
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.greenAccent,
                          ),
                          hintText: "Search",
                          hintStyle: const TextStyle(color: Colors.greenAccent),
                          fillColor: const Color(0xFFE9FDE3),
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    // 🍽️ Dropdown container
                    Container(
                      width: 145,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF5AFF15), Color(0xFF00B712)],
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedMealType,
                          dropdownColor: const Color(0xFFE9FDE3),
                          borderRadius: BorderRadius.circular(12),
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white,
                          ),
                          style: const TextStyle(color: Colors.white),
                          items:
                              mealTypes.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                );
                              }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedMealType = newValue!;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: foods.length,
                    itemBuilder: (context,index){
                      final food= foods[index];
                      return AddMealsTile( itemName: food.foodName.isNotEmpty ? food.foodName : "Unknown",
                        subtitle: food.quantity ?? "No quantity",
                        kcal: food.calories,
                      onAdd: (qty)async{
                        final consumptionEntry = {
                          "date": DateTime.now().toIso8601String(),
                          "foodQuantity": qty.toString(),
                        };
                        final updatedFood={
                          "foodName": food.foodName,
                          "caloriesPerServing": food.calories,
                          "consumptions": [consumptionEntry],
                        };

    try {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc("3UCi7hE0jHNl79r7dIzA3wl0D083").update({
    "userSelectedFood": FieldValue.arrayUnion([updatedFood]),
    });
    } catch (e) {
      print("Error updated");
    }
                      },
                      );
                    }),
                InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> MealsHistoryScreen()));
                    },
                    child: Text("Meals History")),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
