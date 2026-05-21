// // import 'package:flutter/material.dart';
// //
// // class CustomerSupportScreen extends StatefulWidget {
// //   const CustomerSupportScreen({super.key});
// //
// //   @override
// //   State<CustomerSupportScreen> createState() => _CustomerSupportScreenState();
// // }
// //
// // class _CustomerSupportScreenState extends State<CustomerSupportScreen> {
// //   List<String> contacts = []; // Dummy contact list for now
// //   String? selectedContact;
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: Padding(
// //         padding: const EdgeInsets.all(16),
// //         child: Column(
// //           children: [
// //             // Top Header
// //             Row(
// //               children: [
// //                 const Text(
// //                   "Customer Support",
// //                   style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
// //                 ),
// //                 const Spacer(),
// //                 Column(
// //                   crossAxisAlignment: CrossAxisAlignment.end,
// //                   children: const [
// //                     Text(
// //                       "Cody Fisher",
// //                       style: TextStyle(fontWeight: FontWeight.w500),
// //                     ),
// //                     Text(
// //                       "Dashboard Manager",
// //                       style: TextStyle(fontSize: 12, color: Colors.grey),
// //                     ),
// //                   ],
// //                 ),
// //                 const SizedBox(width: 10),
// //                 const CircleAvatar(
// //                   radius: 22,
// //                   backgroundImage: AssetImage("assets/male avatar.png"),
// //                 ),
// //               ],
// //             ),
// //             const SizedBox(height: 20),
// //
// //             // Main Layout
// //             Expanded(
// //               child: Row(
// //                 children: [
// //                   // Left Panel (Contacts)
// //                   Container(
// //                     width: 350,
// //                     decoration: BoxDecoration(
// //                       color: Colors.grey.shade100,
// //                       borderRadius: BorderRadius.circular(12),
// //                     ),
// //                     padding: const EdgeInsets.all(12),
// //                     child: Column(
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       children: [
// //                         // Contacts header
// //                         Row(
// //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                           children: [
// //                             const Text(
// //                               "Contacts",
// //                               style: TextStyle(
// //                                 fontSize: 16,
// //                                 fontWeight: FontWeight.w600,
// //                               ),
// //                             ),
// //                             Container(
// //                               padding: const EdgeInsets.symmetric(
// //                                 horizontal: 16,
// //                                 vertical: 8,
// //                               ),
// //                               decoration: BoxDecoration(
// //                                 gradient: LinearGradient(
// //                                   colors: [
// //                                     Color(0xFF5AFF15),
// //                                     Color(0xFF00B712),
// //                                   ],
// //                                 ), // button background
// //                                 borderRadius: BorderRadius.circular(8),
// //                                 boxShadow: [
// //                                   BoxShadow(
// //                                     color: Colors.black26,
// //                                     blurRadius: 4,
// //                                     offset: Offset(2, 2), // shadow position
// //                                   ),
// //                                 ],
// //                               ),
// //                               child: Text(
// //                                 contacts.length.toString(),
// //                                 style: const TextStyle(
// //                                   color: Colors.white, // text color like button
// //                                   fontWeight: FontWeight.bold,
// //                                   fontSize: 16,
// //                                 ),
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                         const SizedBox(height: 8),
// //
// //                         // Search bar
// //                         TextField(
// //                           decoration: InputDecoration(
// //                             prefixIcon: const Icon(
// //                               Icons.search,
// //                               size: 18,
// //                               color: Colors.green,
// //                             ),
// //                             hintText: "Search",
// //                             hintStyle: const TextStyle(fontSize: 14),
// //                             contentPadding: const EdgeInsets.symmetric(
// //                               vertical: 0,
// //                               horizontal: 12,
// //                             ),
// //                             border: OutlineInputBorder(
// //                               borderRadius: BorderRadius.circular(8),
// //                             ),
// //                           ),
// //                         ),
// //                         const SizedBox(height: 12),
// //
// //                         // Contact List
// //                         Expanded(
// //                           child:
// //                               contacts.isEmpty
// //                                   ? const Center(
// //                                     child: Text(
// //                                       "No Contacts",
// //                                       style: TextStyle(color: Colors.grey),
// //                                     ),
// //                                   )
// //                                   : ListView.builder(
// //                                     itemCount: contacts.length,
// //                                     itemBuilder: (context, index) {
// //                                       final contact = contacts[index];
// //                                       final isSelected =
// //                                           selectedContact == contact;
// //                                       return GestureDetector(
// //                                         onTap: () {
// //                                           setState(() {
// //                                             selectedContact = contact;
// //                                           });
// //                                         },
// //                                         child: Container(
// //                                           margin: const EdgeInsets.only(
// //                                             bottom: 8,
// //                                           ),
// //                                           padding: const EdgeInsets.all(10),
// //                                           decoration: BoxDecoration(
// //                                             color:
// //                                                 isSelected
// //                                                     ? Colors.green.shade50
// //                                                     : Colors.white,
// //                                             borderRadius: BorderRadius.circular(
// //                                               8,
// //                                             ),
// //                                             border: Border.all(
// //                                               color:
// //                                                   isSelected
// //                                                       ? Colors.green
// //                                                       : Colors.grey.shade300,
// //                                             ),
// //                                           ),
// //                                           child: Text(contact),
// //                                         ),
// //                                       );
// //                                     },
// //                                   ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                   const SizedBox(width: 16),
// //
// //                   // Right Panel (Chat or Empty State)
// //                   Expanded(
// //                     child: Container(
// //                       decoration: BoxDecoration(
// //                         color: Colors.white,
// //                         borderRadius: BorderRadius.circular(12),
// //                         border: Border.all(color: Colors.grey.shade300),
// //                       ),
// //                       child:
// //                           selectedContact == null
// //                               ? Center(
// //                                 child: Column(
// //                                   mainAxisAlignment: MainAxisAlignment.center,
// //                                   children: [
// //                                     Image.asset(
// //                                       'assets/man.png',
// //                                       width: 300,
// //                                       height: 350,
// //                                       fit: BoxFit.contain,
// //                                     ),
// //
// //                                     // const SizedBox(height: 10),
// //                                     const Text(
// //                                       "No Messages Yet !",
// //                                       style: TextStyle(
// //                                         fontSize: 18,
// //                                         fontWeight: FontWeight.w600,
// //                                       ),
// //                                     ),
// //                                     const SizedBox(height: 6),
// //                                     const Text(
// //                                       "You're all caught up! Check back later for new updates",
// //                                       style: TextStyle(color: Colors.grey),
// //                                     ),
// //                                   ],
// //                                 ),
// //                               )
// //                               : Column(
// //                                 children: [
// //                                   Container(
// //                                     padding: const EdgeInsets.all(12),
// //                                     decoration: BoxDecoration(
// //                                       color: Colors.green.shade50,
// //                                       borderRadius: const BorderRadius.vertical(
// //                                         top: Radius.circular(12),
// //                                       ),
// //                                     ),
// //                                     child: Row(
// //                                       children: [
// //                                         CircleAvatar(
// //                                           radius: 18,
// //                                           backgroundColor:
// //                                               Colors.green.shade200,
// //                                           child: Text(
// //                                             selectedContact![0],
// //                                             style: const TextStyle(
// //                                               color: Colors.white,
// //                                             ),
// //                                           ),
// //                                         ),
// //                                         const SizedBox(width: 10),
// //                                         Text(
// //                                           selectedContact!,
// //                                           style: const TextStyle(
// //                                             fontWeight: FontWeight.w600,
// //                                           ),
// //                                         ),
// //                                       ],
// //                                     ),
// //                                   ),
// //                                   const Expanded(
// //                                     child: Center(
// //                                       child: Text(
// //                                         "Chat messages will appear here...",
// //                                         style: TextStyle(color: Colors.grey),
// //                                       ),
// //                                     ),
// //                                   ),
// //                                 ],
// //                               ),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
//
//
//
//
//
//
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
//
// class CustomerSupportScreen extends StatefulWidget {
//   const CustomerSupportScreen({super.key});
//
//   @override
//   State<CustomerSupportScreen> createState() => _CustomerSupportScreenState();
// }
//
// class _CustomerSupportScreenState extends State<CustomerSupportScreen> {
//   final FirebaseFirestore firestore = FirebaseFirestore.instance;
//   final supabase = Supabase.instance.client;
//   final TextEditingController messageController = TextEditingController();
//   List<DocumentSnapshot> contacts = [];
//   DocumentSnapshot? selectedContact;
//   bool isTyping = false;
//   final ScrollController scrollController = ScrollController();
//
//   @override
//   void initState() {
//     super.initState();
//     loadContacts();
//     initFCM();
//   }
//
//   /// Initialize FCM for admin
//   void initFCM() async {
//     FirebaseMessaging messaging = FirebaseMessaging.instance;
//
//     // Request permissions
//     await messaging.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//
//     // Get and save admin FCM token
//     String? token = await messaging.getToken();
//     if (token != null) {
//       firestore.collection("admin_tokens").doc("admin_1").set({
//         "token": token,
//         "updatedAt": FieldValue.serverTimestamp(),
//       });
//     }
//
//     // Listen for foreground messages
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       debugPrint("New FCM message: ${message.notification?.title}");
//       // Optionally show local in-app notification
//     });
//   }
//
//   /// Load contact list from Firestore
//   void loadContacts() async {
//     QuerySnapshot snapshot =
//     await firestore.collection("support_chats").get();
//     setState(() {
//       contacts = snapshot.docs;
//     });
//   }
//
//   /// Send text message
//   void sendMessage() async {
//     if (messageController.text.trim().isEmpty) return;
//
//     await firestore
//         .collection("support_chats")
//         .doc(selectedContact!.id)
//         .collection("messages")
//         .add({
//       "senderId": "admin",
//       "text": messageController.text.trim(),
//       "imageUrl": null,
//       "fileUrl": null,
//       "timestamp": FieldValue.serverTimestamp(),
//       "isRead": false,
//       "reactions": {},
//       "isTyping": false,
//     });
//
//     firestore.collection("support_chats")
//         .doc(selectedContact!.id)
//         .update({
//       "lastMessage": messageController.text.trim(),
//       "lastTime": FieldValue.serverTimestamp()
//     });
//
//     messageController.clear();
//     scrollToBottom();
//   }
//
//   /// Send image using Supabase storage
//   void sendImage() async {
//     final picker = ImagePicker();
//     final image = await picker.pickImage(source: ImageSource.gallery);
//     if (image == null) return;
//     final bytes = await image.readAsBytes();
//     final fileName = "chat_images/${DateTime.now().millisecondsSinceEpoch}.jpg";
//     await supabase.storage.from("chat").uploadBinary(fileName, bytes);
//     final url = supabase.storage.from("chat").getPublicUrl(fileName);
//
//     firestore.collection("support_chats")
//         .doc(selectedContact!.id)
//         .collection("messages")
//         .add({
//       "senderId": "admin",
//       "text": null,
//       "imageUrl": url,
//       "fileUrl": null,
//       "timestamp": FieldValue.serverTimestamp(),
//       "isRead": false,
//       "reactions": {},
//       "isTyping": false,
//     });
//
//     scrollToBottom();
//   }
//
//   /// Send file using Supabase storage
//   void sendFile() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(withData: true);
//     if (result == null) return;
//     final file = result.files.first;
//     final fileName = "chat_files/${DateTime.now().millisecondsSinceEpoch}_${file.name}";
//     await supabase.storage.from("chat").uploadBinary(fileName, file.bytes!);
//     final url = supabase.storage.from("chat").getPublicUrl(fileName);
//
//     firestore.collection("support_chats")
//         .doc(selectedContact!.id)
//         .collection("messages")
//         .add({
//       "senderId": "admin",
//       "text": null,
//       "imageUrl": null,
//       "fileUrl": url,
//       "timestamp": FieldValue.serverTimestamp(),
//       "isRead": false,
//       "reactions": {},
//       "isTyping": false,
//     });
//
//     scrollToBottom();
//   }
//
//   /// Scroll chat to bottom
//   void scrollToBottom() {
//     if (scrollController.hasClients) {
//       scrollController.animateTo(
//         scrollController.position.maxScrollExtent,
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeOut,
//       );
//     }
//   }
//
//   /// Update typing status
//   void updateTyping(bool typing) {
//     if (selectedContact == null) return;
//     setState(() {
//       isTyping = typing;
//     });
//     firestore
//         .collection("support_chats")
//         .doc(selectedContact!.id)
//         .update({"isTyping": typing});
//   }
//
//   /// Message bubble widget
//   Widget messageBubble(DocumentSnapshot doc) {
//     bool isAdmin = doc["senderId"] == "admin";
//     Map reactions = doc["reactions"] ?? {};
//
//     return Align(
//       alignment: isAdmin ? Alignment.centerRight : Alignment.centerLeft,
//       child: GestureDetector(
//         onLongPress: () => showReactions(doc),
//         child: Container(
//           margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//           padding: const EdgeInsets.all(12),
//           decoration: BoxDecoration(
//             color: isAdmin ? Colors.green : Colors.grey.shade300,
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               if (doc["text"] != null)
//                 Text(
//                   doc["text"],
//                   style: TextStyle(color: isAdmin ? Colors.white : Colors.black),
//                 ),
//               if (doc["imageUrl"] != null)
//                 Image.network(
//                   doc["imageUrl"],
//                   height: 150,
//                 ),
//               if (doc["fileUrl"] != null)
//                 const Text("📎 File attachment"),
//               if (reactions.isNotEmpty)
//                 Row(
//                   children: reactions.values
//                       .map<Widget>((e) => Padding(
//                     padding: const EdgeInsets.only(right: 4),
//                     child: Text(e.toString()),
//                   ))
//                       .toList(),
//                 ),
//               const SizedBox(height: 5),
//               Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(
//                     doc["timestamp"] == null
//                         ? ""
//                         : TimeOfDay.fromDateTime(doc["timestamp"].toDate())
//                         .format(context),
//                     style: const TextStyle(fontSize: 10),
//                   ),
//                   const SizedBox(width: 4),
//                   if (isAdmin)
//                     Icon(
//                       doc["isRead"] ? Icons.done_all : Icons.done,
//                       size: 14,
//                       color: Colors.white,
//                     )
//                 ],
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   /// Show reactions popup
//   void showReactions(DocumentSnapshot doc) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         content: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: ["👍", "❤️", "😂"].map((emoji) {
//             return GestureDetector(
//               onTap: () {
//                 firestore
//                     .collection("support_chats")
//                     .doc(selectedContact!.id)
//                     .collection("messages")
//                     .doc(doc.id)
//                     .update({
//                   "reactions.admin": emoji,
//                 });
//                 Navigator.pop(context);
//               },
//               child: Text(emoji, style: const TextStyle(fontSize: 24)),
//             );
//           }).toList(),
//         ),
//       ),
//     );
//   }
//
//   int unreadCount(DocumentSnapshot contact) {
//     // For simplicity, can implement real-time query to count unread messages
//     return 0;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // --- UI kept exactly as your original code ---
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             // Top Header
//             Row(
//               children: [
//                 const Text(
//                   "Customer Support",
//                   style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//                 ),
//                 const Spacer(),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: const [
//                     Text(
//                       "Cody Fisher",
//                       style: TextStyle(fontWeight: FontWeight.w500),
//                     ),
//                     Text(
//                       "Dashboard Manager",
//                       style: TextStyle(fontSize: 12, color: Colors.grey),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(width: 10),
//                 const CircleAvatar(
//                   radius: 22,
//                   backgroundImage: AssetImage("assets/male avatar.png"),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),
//
//             // Main Layout (left contact list + right chat panel)
//             Expanded(
//               child: Row(
//                 children: [
//                   // Left panel
//                   Container(
//                     width: 350,
//                     decoration: BoxDecoration(
//                       color: Colors.grey.shade100,
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     padding: const EdgeInsets.all(12),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Contacts header
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             const Text(
//                               "Contacts",
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                             Container(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 16, vertical: 8),
//                               decoration: BoxDecoration(
//                                 gradient: const LinearGradient(
//                                   colors: [Color(0xFF5AFF15), Color(0xFF00B712)],
//                                 ),
//                                 borderRadius: BorderRadius.circular(8),
//                                 boxShadow: const [
//                                   BoxShadow(
//                                     color: Colors.black26,
//                                     blurRadius: 4,
//                                     offset: Offset(2, 2),
//                                   ),
//                                 ],
//                               ),
//                               child: Text(
//                                 contacts.length.toString(),
//                                 style: const TextStyle(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 16),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 8),
//
//                         // Search bar
//                         TextField(
//                           decoration: InputDecoration(
//                             prefixIcon: const Icon(
//                               Icons.search,
//                               size: 18,
//                               color: Colors.green,
//                             ),
//                             hintText: "Search",
//                             hintStyle: const TextStyle(fontSize: 14),
//                             contentPadding: const EdgeInsets.symmetric(
//                               vertical: 0,
//                               horizontal: 12,
//                             ),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 12),
//
//                         // Contact List
//                         Expanded(
//                           child: contacts.isEmpty
//                               ? const Center(
//                             child: Text(
//                               "No Contacts",
//                               style: TextStyle(color: Colors.grey),
//                             ),
//                           )
//                               : ListView.builder(
//                             itemCount: contacts.length,
//                             itemBuilder: (context, index) {
//                               final doc = contacts[index];
//                               final contact = doc["userName"];
//                               final isSelected =
//                                   selectedContact?.id == doc.id;
//                               bool online = doc["userOnline"] ?? false;
//                               return GestureDetector(
//                                 onTap: () {
//                                   setState(() {
//                                     selectedContact = doc;
//                                   });
//                                 },
//                                 child: Container(
//                                   margin:
//                                   const EdgeInsets.only(bottom: 8),
//                                   padding: const EdgeInsets.all(10),
//                                   decoration: BoxDecoration(
//                                     color: isSelected
//                                         ? Colors.green.shade50
//                                         : Colors.white,
//                                     borderRadius: BorderRadius.circular(8),
//                                     border: Border.all(
//                                       color: isSelected
//                                           ? Colors.green
//                                           : Colors.grey.shade300,
//                                     ),
//                                   ),
//                                   child: Row(
//                                     children: [
//                                       Stack(
//                                         children: [
//                                           const CircleAvatar(
//                                             child: Icon(Icons.person),
//                                           ),
//                                           Positioned(
//                                             bottom: 0,
//                                             right: 0,
//                                             child: Container(
//                                               height: 10,
//                                               width: 10,
//                                               decoration: BoxDecoration(
//                                                 color: online
//                                                     ? Colors.green
//                                                     : Colors.grey,
//                                                 shape: BoxShape.circle,
//                                               ),
//                                             ),
//                                           )
//                                         ],
//                                       ),
//                                       const SizedBox(width: 8),
//                                       Expanded(child: Text(contact)),
//                                       if (unreadCount(doc) > 0)
//                                         Container(
//                                           padding: const EdgeInsets.all(6),
//                                           decoration: const BoxDecoration(
//                                             color: Colors.red,
//                                             shape: BoxShape.circle,
//                                           ),
//                                           child: Text(
//                                             unreadCount(doc).toString(),
//                                             style: const TextStyle(
//                                                 color: Colors.white,
//                                                 fontSize: 12),
//                                           ),
//                                         )
//                                     ],
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   const SizedBox(width: 16),
//
//                   // Right panel (chat area)
//                   Expanded(
//                     child: selectedContact == null
//                         ? Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Image.asset(
//                             'assets/man.png',
//                             width: 300,
//                             height: 350,
//                             fit: BoxFit.contain,
//                           ),
//                           const SizedBox(height: 10),
//                           const Text(
//                             "No Messages Yet !",
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                           const SizedBox(height: 6),
//                           const Text(
//                             "You're all caught up! Check back later for new updates",
//                             style: TextStyle(color: Colors.grey),
//                           ),
//                         ],
//                       ),
//                     )
//                         : Column(
//                       children: [
//                         // Chat header
//                         Container(
//                           padding: const EdgeInsets.all(12),
//                           decoration: BoxDecoration(
//                             color: Colors.green.shade50,
//                             borderRadius: const BorderRadius.vertical(
//                               top: Radius.circular(12),
//                             ),
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Row(
//                                 children: [
//                                   CircleAvatar(
//                                     radius: 18,
//                                     backgroundColor: Colors.green.shade200,
//                                     child: Text(
//                                       selectedContact!["userName"][0],
//                                       style: const TextStyle(
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(width: 10),
//                                   Text(
//                                     selectedContact!["userName"],
//                                     style: const TextStyle(
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               if (isTyping)
//                                 const Padding(
//                                   padding: EdgeInsets.only(top: 2),
//                                   child: Text(
//                                     "Typing...",
//                                     style: TextStyle(
//                                         fontSize: 12, color: Colors.grey),
//                                   ),
//                                 ),
//                             ],
//                           ),
//                         ),
//
//                         // Messages
//                         Expanded(
//                           child: StreamBuilder<QuerySnapshot>(
//                             stream: firestore
//                                 .collection("support_chats")
//                                 .doc(selectedContact!.id)
//                                 .collection("messages")
//                                 .orderBy("timestamp")
//                                 .snapshots(),
//                             builder: (context, snapshot) {
//                               if (!snapshot.hasData) {
//                                 return const Center(
//                                     child: CircularProgressIndicator());
//                               }
//                               return ListView(
//                                 controller: scrollController,
//                                 children: snapshot.data!.docs
//                                     .map((doc) => messageBubble(doc))
//                                     .toList(),
//                               );
//                             },
//                           ),
//                         ),
//
//                         // Message input
//                         Container(
//                           padding: const EdgeInsets.all(10),
//                           child: Row(
//                             children: [
//                               IconButton(
//                                 icon: const Icon(Icons.image),
//                                 onPressed: sendImage,
//                               ),
//                               IconButton(
//                                 icon: const Icon(Icons.attach_file),
//                                 onPressed: sendFile,
//                               ),
//                               Expanded(
//                                 child: TextField(
//                                   controller: messageController,
//                                   decoration: const InputDecoration(
//                                     hintText: "Type message...",
//                                   ),
//                                   onChanged: (text) {
//                                     updateTyping(text.isNotEmpty);
//                                   },
//                                   onSubmitted: (_) {
//                                     updateTyping(false);
//                                   },
//                                 ),
//                               ),
//                               IconButton(
//                                 icon: const Icon(Icons.send),
//                                 onPressed: sendMessage,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }





// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
//
// class CustomerSupportScreen extends StatefulWidget {
//   const CustomerSupportScreen({super.key});
//
//   @override
//   State<CustomerSupportScreen> createState() => _CustomerSupportScreenState();
// }
//
// class _CustomerSupportScreenState extends State<CustomerSupportScreen> {
//   final FirebaseFirestore firestore = FirebaseFirestore.instance;
//   final supabase = Supabase.instance.client;
//   final TextEditingController messageController = TextEditingController();
//   List<DocumentSnapshot> contacts = [];
//   DocumentSnapshot? selectedContact;
//   bool isTyping = false;
//   final ScrollController scrollController = ScrollController();
//   String? chatDocumentId;
//   bool isUserTyping = false;
//
//   @override
//   void initState() {
//     super.initState();
//     loadContacts();
//     initFCM();
//   }
//
//   @override
//   void dispose() {
//     // Update admin typing status to false when leaving
//     if (chatDocumentId != null && selectedContact != null) {
//       firestore.collection("support_chats").doc(selectedContact!.id).update({
//         "isTyping": false,
//       });
//     }
//     messageController.dispose();
//     scrollController.dispose();
//     super.dispose();
//   }
//
//   /// Initialize FCM for admin
//   void initFCM() async {
//     FirebaseMessaging messaging = FirebaseMessaging.instance;
//
//     // Request permissions
//     await messaging.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//
//     // Get and save admin FCM token
//     String? token = await messaging.getToken();
//     if (token != null) {
//       firestore.collection("admin_tokens").doc("admin_1").set({
//         "token": token,
//         "updatedAt": FieldValue.serverTimestamp(),
//       });
//     }
//
//     // Listen for foreground messages
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       debugPrint("New FCM message: ${message.notification?.title}");
//       // Optionally show local in-app notification
//     });
//   }
//
//   /// Load contact list from Firestore
//   void loadContacts() {
//     // Listen to real-time updates for contacts
//     firestore.collection("support_chats").snapshots().listen((snapshot) {
//       setState(() {
//         contacts = snapshot.docs;
//       });
//     });
//   }
//
//   /// Listen to user typing status
//   void listenToUserTyping(String chatId) {
//     firestore.collection("support_chats").doc(chatId).snapshots().listen((snapshot) {
//       if (snapshot.exists && mounted) {
//         bool typing = snapshot.data()?['isTyping'] ?? false;
//         if (typing != isUserTyping) {
//           setState(() {
//             isUserTyping = typing;
//           });
//         }
//       }
//     });
//   }
//
//   /// Send text message
//   Future<void> sendMessage() async {
//     if (messageController.text.trim().isEmpty || selectedContact == null) return;
//
//     final messageText = messageController.text.trim();
//
//     try {
//       await firestore
//           .collection("support_chats")
//           .doc(selectedContact!.id)
//           .collection("messages")
//           .add({
//         "senderId": "admin",
//         "senderName": "Admin",
//         "text": messageText,
//         "imageUrl": null,
//         "fileUrl": null,
//         "timestamp": FieldValue.serverTimestamp(),
//         "isRead": false,
//         "reactions": {},
//       });
//
//       await firestore.collection("support_chats").doc(selectedContact!.id).update({
//         "lastMessage": messageText,
//         "lastTime": FieldValue.serverTimestamp(),
//       });
//
//       messageController.clear();
//
//       // Update typing status to false after sending
//       await updateTyping(false);
//       scrollToBottom();
//
//     } catch (e) {
//       debugPrint("Error sending message: $e");
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Failed to send message")),
//         );
//       }
//     }
//   }
//
//   /// Send image using Supabase storage
//   Future<void> sendImage() async {
//     if (selectedContact == null) return;
//
//     try {
//       final picker = ImagePicker();
//       final image = await picker.pickImage(source: ImageSource.gallery);
//       if (image == null) return;
//
//       final bytes = await image.readAsBytes();
//       final fileName = "chat_images/${DateTime.now().millisecondsSinceEpoch}.jpg";
//       await supabase.storage.from("chat").uploadBinary(fileName, bytes);
//       final url = supabase.storage.from("chat").getPublicUrl(fileName);
//
//       await firestore
//           .collection("support_chats")
//           .doc(selectedContact!.id)
//           .collection("messages")
//           .add({
//         "senderId": "admin",
//         "senderName": "Admin",
//         "text": null,
//         "imageUrl": url,
//         "fileUrl": null,
//         "timestamp": FieldValue.serverTimestamp(),
//         "isRead": false,
//         "reactions": {},
//       });
//
//       scrollToBottom();
//
//     } catch (e) {
//       debugPrint("Error sending image: $e");
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Failed to send image")),
//         );
//       }
//     }
//   }
//
//   /// Send file using Supabase storage
//   Future<void> sendFile() async {
//     if (selectedContact == null) return;
//
//     try {
//       FilePickerResult? result = await FilePicker.platform.pickFiles(withData: true);
//       if (result == null) return;
//
//       final file = result.files.first;
//       final fileName = "chat_files/${DateTime.now().millisecondsSinceEpoch}_${file.name}";
//       await supabase.storage.from("chat").uploadBinary(fileName, file.bytes!);
//       final url = supabase.storage.from("chat").getPublicUrl(fileName);
//
//       await firestore
//           .collection("support_chats")
//           .doc(selectedContact!.id)
//           .collection("messages")
//           .add({
//         "senderId": "admin",
//         "senderName": "Admin",
//         "text": null,
//         "imageUrl": null,
//         "fileUrl": url,
//         "fileName": file.name,
//         "timestamp": FieldValue.serverTimestamp(),
//         "isRead": false,
//         "reactions": {},
//       });
//
//       scrollToBottom();
//
//     } catch (e) {
//       debugPrint("Error sending file: $e");
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Failed to send file")),
//         );
//       }
//     }
//   }
//
//   /// Update typing status
//   Future<void> updateTyping(bool typing) async {
//     if (selectedContact == null) return;
//
//     try {
//       await firestore.collection("support_chats").doc(selectedContact!.id).update({
//         "isTyping": typing,
//       });
//     } catch (e) {
//       debugPrint("Error updating typing status: $e");
//     }
//   }
//
//   /// Scroll chat to bottom
//   void scrollToBottom() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (scrollController.hasClients) {
//         scrollController.animateTo(
//           scrollController.position.maxScrollExtent,
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeOut,
//         );
//       }
//     });
//   }
//
//   /// Format timestamp
//   String formatTimestamp(Timestamp? timestamp) {
//     if (timestamp == null) return "";
//     final DateTime dateTime = timestamp.toDate();
//     final now = DateTime.now();
//     final difference = now.difference(dateTime);
//
//     if (difference.inDays > 0) {
//       return "${dateTime.day}/${dateTime.month}";
//     } else {
//       return "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
//     }
//   }
//
//   /// Message bubble widget
//   Widget messageBubble(QueryDocumentSnapshot doc) {
//     bool isAdmin = doc["senderId"] == "admin";
//     final Map<String, dynamic> reactions = Map<String, dynamic>.from(doc["reactions"] ?? {});
//     final bool isRead = doc["isRead"] ?? false;
//
//     return Align(
//       alignment: isAdmin ? Alignment.centerRight : Alignment.centerLeft,
//       child: GestureDetector(
//         onLongPress: () => showReactions(doc),
//         child: Container(
//           margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//           padding: const EdgeInsets.all(12),
//           constraints: BoxConstraints(
//             maxWidth: MediaQuery.of(context).size.width * 0.75,
//           ),
//           decoration: BoxDecoration(
//             color: isAdmin ? Colors.green : Colors.grey.shade300,
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               if (doc["text"] != null)
//                 Text(
//                   doc["text"],
//                   style: TextStyle(
//                     color: isAdmin ? Colors.white : Colors.black,
//                     fontSize: 16,
//                   ),
//                 ),
//               if (doc["imageUrl"] != null)
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(8),
//                   child: Image.network(
//                     doc["imageUrl"],
//                     height: 150,
//                     fit: BoxFit.cover,
//                     errorBuilder: (context, error, stackTrace) {
//                       return Container(
//                         height: 150,
//                         color: Colors.grey[300],
//                         child: const Icon(Icons.broken_image, size: 50),
//                       );
//                     },
//                   ),
//                 ),
//               if (doc["fileUrl"] != null)
//                 InkWell(
//                   onTap: () {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text("File: ${doc['fileName'] ?? 'Attachment'}")),
//                     );
//                   },
//                   child: Container(
//                     padding: const EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.2),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Icon(
//                           Icons.attach_file,
//                           color: isAdmin ? Colors.white : Colors.black,
//                           size: 20,
//                         ),
//                         const SizedBox(width: 8),
//                         Flexible(
//                           child: Text(
//                             doc['fileName'] ?? "Attachment",
//                             style: TextStyle(
//                               color: isAdmin ? Colors.white : Colors.black,
//                               fontSize: 14,
//                             ),
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               if (reactions.isNotEmpty)
//                 Padding(
//                   padding: const EdgeInsets.only(top: 4),
//                   child: Wrap(
//                     spacing: 4,
//                     children: reactions.entries.map((entry) {
//                       return Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                         decoration: BoxDecoration(
//                           color: Colors.white.withOpacity(0.3),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Text(
//                           entry.value.toString(),
//                           style: const TextStyle(fontSize: 14),
//                         ),
//                       );
//                     }).toList(),
//                   ),
//                 ),
//               const SizedBox(height: 5),
//               Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(
//                     formatTimestamp(doc["timestamp"]),
//                     style: TextStyle(
//                       fontSize: 10,
//                       color: isAdmin ? Colors.white70 : Colors.black54,
//                     ),
//                   ),
//                   if (isAdmin) ...[
//                     const SizedBox(width: 4),
//                     Icon(
//                       isRead ? Icons.done_all : Icons.done,
//                       size: 12,
//                       color: isRead ? Colors.white70 : Colors.white38,
//                     ),
//                   ],
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   /// Show reactions popup
//   void showReactions(QueryDocumentSnapshot doc) {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) => Container(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Text(
//               "Add Reaction",
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: ["👍", "❤️", "😂", "😮", "😢", "😡"].map((emoji) {
//                 return GestureDetector(
//                   onTap: () async {
//                     try {
//                       await firestore
//                           .collection("support_chats")
//                           .doc(selectedContact!.id)
//                           .collection("messages")
//                           .doc(doc.id)
//                           .update({
//                         "reactions.admin": emoji,
//                       });
//                       if (mounted) Navigator.pop(context);
//                     } catch (e) {
//                       debugPrint("Error adding reaction: $e");
//                     }
//                   },
//                   child: Container(
//                     padding: const EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                       color: Colors.grey[100],
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                     child: Text(emoji, style: const TextStyle(fontSize: 32)),
//                   ),
//                 );
//               }).toList(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   int unreadCount(DocumentSnapshot contact) {
//     // For simplicity, can implement real-time query to count unread messages
//     return 0;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             // Top Header
//             Row(
//               children: [
//                 const Text(
//                   "Customer Support",
//                   style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//                 ),
//                 const Spacer(),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: const [
//                     Text(
//                       "Cody Fisher",
//                       style: TextStyle(fontWeight: FontWeight.w500),
//                     ),
//                     Text(
//                       "Dashboard Manager",
//                       style: TextStyle(fontSize: 12, color: Colors.grey),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(width: 10),
//                 const CircleAvatar(
//                   radius: 22,
//                   backgroundImage: AssetImage("assets/male avatar.png"),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),
//
//             // Main Layout (left contact list + right chat panel)
//             Expanded(
//               child: Row(
//                 children: [
//                   // Left panel
//                   Container(
//                     width: 350,
//                     decoration: BoxDecoration(
//                       color: Colors.grey.shade100,
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     padding: const EdgeInsets.all(12),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Contacts header
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             const Text(
//                               "Contacts",
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                             Container(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 16, vertical: 8),
//                               decoration: BoxDecoration(
//                                 gradient: const LinearGradient(
//                                   colors: [Color(0xFF5AFF15), Color(0xFF00B712)],
//                                 ),
//                                 borderRadius: BorderRadius.circular(8),
//                                 boxShadow: const [
//                                   BoxShadow(
//                                     color: Colors.black26,
//                                     blurRadius: 4,
//                                     offset: Offset(2, 2),
//                                   ),
//                                 ],
//                               ),
//                               child: Text(
//                                 contacts.length.toString(),
//                                 style: const TextStyle(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 16),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 8),
//
//                         // Search bar
//                         TextField(
//                           decoration: InputDecoration(
//                             prefixIcon: const Icon(
//                               Icons.search,
//                               size: 18,
//                               color: Colors.green,
//                             ),
//                             hintText: "Search",
//                             hintStyle: const TextStyle(fontSize: 14),
//                             contentPadding: const EdgeInsets.symmetric(
//                               vertical: 0,
//                               horizontal: 12,
//                             ),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 12),
//
//                         // Contact List
//                         Expanded(
//                           child: contacts.isEmpty
//                               ? const Center(
//                             child: Text(
//                               "No Contacts",
//                               style: TextStyle(color: Colors.grey),
//                             ),
//                           )
//                               : ListView.builder(
//                             itemCount: contacts.length,
//                             itemBuilder: (context, index) {
//                               final doc = contacts[index];
//                               final contact = doc["userName"];
//                               final isSelected =
//                                   selectedContact?.id == doc.id;
//                               bool online = doc["userOnline"] ?? false;
//                               final lastMessage = doc["lastMessage"] ?? "";
//                               return GestureDetector(
//                                 onTap: () {
//                                   setState(() {
//                                     selectedContact = doc;
//                                     isUserTyping = false;
//                                   });
//                                   // Listen to user typing status
//                                   listenToUserTyping(doc.id);
//                                 },
//                                 child: Container(
//                                   margin:
//                                   const EdgeInsets.only(bottom: 8),
//                                   padding: const EdgeInsets.all(10),
//                                   decoration: BoxDecoration(
//                                     color: isSelected
//                                         ? Colors.green.shade50
//                                         : Colors.white,
//                                     borderRadius: BorderRadius.circular(8),
//                                     border: Border.all(
//                                       color: isSelected
//                                           ? Colors.green
//                                           : Colors.grey.shade300,
//                                     ),
//                                   ),
//                                   child: Row(
//                                     children: [
//                                       Stack(
//                                         children: [
//                                           const CircleAvatar(
//                                             child: Icon(Icons.person),
//                                           ),
//                                           Positioned(
//                                             bottom: 0,
//                                             right: 0,
//                                             child: Container(
//                                               height: 10,
//                                               width: 10,
//                                               decoration: BoxDecoration(
//                                                 color: online
//                                                     ? Colors.green
//                                                     : Colors.grey,
//                                                 shape: BoxShape.circle,
//                                               ),
//                                             ),
//                                           )
//                                         ],
//                                       ),
//                                       const SizedBox(width: 8),
//                                       Expanded(
//                                         child: Column(
//                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                               contact,
//                                               style: const TextStyle(
//                                                 fontWeight: FontWeight.w500,
//                                               ),
//                                             ),
//                                             if (lastMessage.isNotEmpty)
//                                               Text(
//                                                 lastMessage,
//                                                 style: TextStyle(
//                                                   fontSize: 12,
//                                                   color: Colors.grey.shade600,
//                                                 ),
//                                                 maxLines: 1,
//                                                 overflow: TextOverflow.ellipsis,
//                                               ),
//                                           ],
//                                         ),
//                                       ),
//                                       if (unreadCount(doc) > 0)
//                                         Container(
//                                           padding: const EdgeInsets.all(6),
//                                           decoration: const BoxDecoration(
//                                             color: Colors.red,
//                                             shape: BoxShape.circle,
//                                           ),
//                                           child: Text(
//                                             unreadCount(doc).toString(),
//                                             style: const TextStyle(
//                                                 color: Colors.white,
//                                                 fontSize: 12),
//                                           ),
//                                         )
//                                     ],
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   const SizedBox(width: 16),
//
//                   // Right panel (chat area)
//                   Expanded(
//                     child: selectedContact == null
//                         ? Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Image.asset(
//                             'assets/man.png',
//                             width: 300,
//                             height: 350,
//                             fit: BoxFit.contain,
//                           ),
//                           const SizedBox(height: 10),
//                           const Text(
//                             "No Messages Yet !",
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                           const SizedBox(height: 6),
//                           const Text(
//                             "You're all caught up! Check back later for new updates",
//                             style: TextStyle(color: Colors.grey),
//                           ),
//                         ],
//                       ),
//                     )
//                         : Column(
//                       children: [
//                         // Chat header
//                         Container(
//                           padding: const EdgeInsets.all(12),
//                           decoration: BoxDecoration(
//                             color: Colors.green.shade50,
//                             borderRadius: const BorderRadius.vertical(
//                               top: Radius.circular(12),
//                             ),
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Row(
//                                 children: [
//                                   CircleAvatar(
//                                     radius: 18,
//                                     backgroundColor: Colors.green.shade200,
//                                     child: Text(
//                                       selectedContact!["userName"][0],
//                                       style: const TextStyle(
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(width: 10),
//                                   Text(
//                                     selectedContact!["userName"],
//                                     style: const TextStyle(
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               if (isUserTyping)
//                                 const Padding(
//                                   padding: EdgeInsets.only(top: 2),
//                                   child: Text(
//                                     "Typing...",
//                                     style: TextStyle(
//                                         fontSize: 12, color: Colors.grey),
//                                   ),
//                                 ),
//                             ],
//                           ),
//                         ),
//
//                         // Messages
//                         Expanded(
//                           child: StreamBuilder<QuerySnapshot>(
//                             stream: firestore
//                                 .collection("support_chats")
//                                 .doc(selectedContact!.id)
//                                 .collection("messages")
//                                 .orderBy("timestamp")
//                                 .snapshots(),
//                             builder: (context, snapshot) {
//                               if (!snapshot.hasData) {
//                                 return const Center(
//                                     child: CircularProgressIndicator());
//                               }
//
//                               if (snapshot.data!.docs.isEmpty) {
//                                 return Center(
//                                   child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Icon(
//                                         Icons.chat_bubble_outline,
//                                         size: 80,
//                                         color: Colors.grey.shade400,
//                                       ),
//                                       const SizedBox(height: 16),
//                                       const Text(
//                                         "No messages yet",
//                                         style: TextStyle(
//                                           fontSize: 18,
//                                           fontWeight: FontWeight.w600,
//                                         ),
//                                       ),
//                                       const SizedBox(height: 8),
//                                       Text(
//                                         "Send a message to start chatting",
//                                         style: TextStyle(
//                                           color: Colors.grey.shade500,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 );
//                               }
//
//                               WidgetsBinding.instance.addPostFrameCallback((_) {
//                                 scrollToBottom();
//                               });
//
//                               return ListView.builder(
//                                 controller: scrollController,
//                                 padding: const EdgeInsets.symmetric(vertical: 16),
//                                 itemCount: snapshot.data!.docs.length,
//                                 itemBuilder: (context, index) {
//                                   final doc = snapshot.data!.docs[index];
//                                   return messageBubble(doc as QueryDocumentSnapshot);
//                                 },
//                               );
//                             },
//                           ),
//                         ),
//
//                         // Message input
//                         Container(
//                           padding: const EdgeInsets.all(10),
//                           child: Row(
//                             children: [
//                               IconButton(
//                                 icon: const Icon(Icons.image),
//                                 onPressed: sendImage,
//                               ),
//                               IconButton(
//                                 icon: const Icon(Icons.attach_file),
//                                 onPressed: sendFile,
//                               ),
//                               Expanded(
//                                 child: TextField(
//                                   controller: messageController,
//                                   decoration: const InputDecoration(
//                                     hintText: "Type message...",
//                                   ),
//                                   onChanged: (text) {
//                                     updateTyping(text.isNotEmpty);
//                                   },
//                                   onSubmitted: (_) {
//                                     updateTyping(false);
//                                     sendMessage();
//                                   },
//                                 ),
//                               ),
//                               IconButton(
//                                 icon: const Icon(Icons.send),
//                                 onPressed: sendMessage,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }






import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'admin_provider.dart';

class CustomerSupportScreen extends StatefulWidget {
  const CustomerSupportScreen({super.key});

  @override
  State<CustomerSupportScreen> createState() => _CustomerSupportScreenState();
}

class _CustomerSupportScreenState extends State<CustomerSupportScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final supabase = Supabase.instance.client;
  final TextEditingController messageController = TextEditingController();
  List<DocumentSnapshot> contacts = [];
  DocumentSnapshot? selectedContact;
  bool isTyping = false;
  final ScrollController scrollController = ScrollController();
  String? chatDocumentId;
  bool isUserTyping = false;

  @override
  void initState() {
    super.initState();
    loadContacts();
    initFCM();
  }

  @override
  void dispose() {
    // Update admin typing status to false when leaving
    if (chatDocumentId != null && selectedContact != null) {
      firestore.collection("support_chats").doc(selectedContact!.id).update({
        "isTyping": false,
      });
    }
    messageController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  /// Initialize FCM for admin
  void initFCM() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Request permissions
    await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Get and save admin FCM token
    String? token = await messaging.getToken();
    if (token != null) {
      firestore.collection("admin_tokens").doc("admin_1").set({
        "token": token,
        "updatedAt": FieldValue.serverTimestamp(),
      });
    }

    // Listen for foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint("New FCM message: ${message.notification?.title}");
      // Optionally show local in-app notification
    });
  }

  /// Load contact list from Firestore
  void loadContacts() {
    // Listen to real-time updates for contacts
    firestore.collection("support_chats").snapshots().listen((snapshot) {
      setState(() {
        contacts = snapshot.docs;
      });
    });
  }

  /// Listen to user typing status
  void listenToUserTyping(String chatId) {
    firestore.collection("support_chats").doc(chatId).snapshots().listen((snapshot) {
      if (snapshot.exists && mounted) {
        bool typing = snapshot.data()?['isTyping'] ?? false;
        if (typing != isUserTyping) {
          setState(() {
            isUserTyping = typing;
          });
        }
      }
    });
  }

  /// Send text message
  Future<void> sendMessage() async {
    if (messageController.text.trim().isEmpty || selectedContact == null) return;

    final messageText = messageController.text.trim();

    try {
      await firestore
          .collection("support_chats")
          .doc(selectedContact!.id)
          .collection("messages")
          .add({
        "senderId": "admin",
        "senderName": "Admin",
        "text": messageText,
        "imageUrl": null,
        "fileUrl": null,
        "timestamp": FieldValue.serverTimestamp(),
        "isRead": false,
        "reactions": {},
      });

      await firestore.collection("support_chats").doc(selectedContact!.id).update({
        "lastMessage": messageText,
        "lastTime": FieldValue.serverTimestamp(),
      });

      messageController.clear();

      // Update typing status to false after sending
      await updateTyping(false);
      scrollToBottom();

    } catch (e) {
      debugPrint("Error sending message: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to send message")),
        );
      }
    }
  }

  /// Send image using Supabase storage
  Future<void> sendImage() async {
    if (selectedContact == null) return;

    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final bytes = await image.readAsBytes();
      final fileName = "chat_images/${DateTime.now().millisecondsSinceEpoch}.jpg";
      await supabase.storage.from("chat").uploadBinary(fileName, bytes);
      final url = supabase.storage.from("chat").getPublicUrl(fileName);

      await firestore
          .collection("support_chats")
          .doc(selectedContact!.id)
          .collection("messages")
          .add({
        "senderId": "admin",
        "senderName": "Admin",
        "text": null,
        "imageUrl": url,
        "fileUrl": null,
        "timestamp": FieldValue.serverTimestamp(),
        "isRead": false,
        "reactions": {},
      });

      scrollToBottom();

    } catch (e) {
      debugPrint("Error sending image: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to send image")),
        );
      }
    }
  }

  /// Send file using Supabase storage
  Future<void> sendFile() async {
    if (selectedContact == null) return;

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(withData: true);
      if (result == null) return;

      final file = result.files.first;
      final fileName = "chat_files/${DateTime.now().millisecondsSinceEpoch}_${file.name}";
      await supabase.storage.from("chat").uploadBinary(fileName, file.bytes!);
      final url = supabase.storage.from("chat").getPublicUrl(fileName);

      await firestore
          .collection("support_chats")
          .doc(selectedContact!.id)
          .collection("messages")
          .add({
        "senderId": "admin",
        "senderName": "Admin",
        "text": null,
        "imageUrl": null,
        "fileUrl": url,
        "fileName": file.name,
        "timestamp": FieldValue.serverTimestamp(),
        "isRead": false,
        "reactions": {},
      });

      scrollToBottom();

    } catch (e) {
      debugPrint("Error sending file: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to send file")),
        );
      }
    }
  }

  /// Update typing status
  Future<void> updateTyping(bool typing) async {
    if (selectedContact == null) return;

    try {
      await firestore.collection("support_chats").doc(selectedContact!.id).update({
        "isTyping": typing,
      });
    } catch (e) {
      debugPrint("Error updating typing status: $e");
    }
  }

  /// Scroll chat to bottom
  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  /// Format timestamp
  String formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return "";
    final DateTime dateTime = timestamp.toDate();
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return "${dateTime.day}/${dateTime.month}";
    } else {
      return "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
    }
  }

  /// Message bubble widget
  Widget messageBubble(QueryDocumentSnapshot doc) {
    bool isAdmin = doc["senderId"] == "admin";
    final Map<String, dynamic> reactions = Map<String, dynamic>.from(doc["reactions"] ?? {});
    final bool isRead = doc["isRead"] ?? false;

    return Align(
      alignment: isAdmin ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onLongPress: () => showReactions(doc),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          padding: const EdgeInsets.all(12),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          decoration: BoxDecoration(
            gradient: isAdmin
                ? const LinearGradient(
              colors: [Color(0xFF5AFF15), Color(0xFF00B712)],
            )
                : null,
            color: isAdmin ? null : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (doc["text"] != null)
                Text(
                  doc["text"],
                  style: const TextStyle(
                    color: Colors.black, // Changed to black for admin messages too
                    fontSize: 16,
                  ),
                ),
              if (doc["imageUrl"] != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    doc["imageUrl"],
                    height: 150,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 150,
                        color: Colors.grey[300],
                        child: const Icon(Icons.broken_image, size: 50),
                      );
                    },
                  ),
                ),
              if (doc["fileUrl"] != null)
                InkWell(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("File: ${doc['fileName'] ?? 'Attachment'}")),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.attach_file,
                          color: Colors.black, // Changed to black
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            doc['fileName'] ?? "Attachment",
                            style: const TextStyle(
                              color: Colors.black, // Changed to black
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (reactions.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Wrap(
                    spacing: 4,
                    children: reactions.entries.map((entry) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          entry.value.toString(),
                          style: const TextStyle(fontSize: 14, color: Colors.black),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              const SizedBox(height: 5),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    formatTimestamp(doc["timestamp"]),
                    style: TextStyle(
                      fontSize: 10,
                      color: isAdmin ? Colors.black54 : Colors.black54, // Both now black with opacity
                    ),
                  ),
                  if (isAdmin) ...[
                    const SizedBox(width: 4),
                    Icon(
                      isRead ? Icons.done_all : Icons.done,
                      size: 12,
                      color: Colors.black54, // Changed to black with opacity
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Show reactions popup
  void showReactions(QueryDocumentSnapshot doc) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Add Reaction",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: ["👍", "❤️", "😂", "😮", "😢", "😡"].map((emoji) {
                return GestureDetector(
                  onTap: () async {
                    try {
                      await firestore
                          .collection("support_chats")
                          .doc(selectedContact!.id)
                          .collection("messages")
                          .doc(doc.id)
                          .update({
                        "reactions.admin": emoji,
                      });
                      if (mounted) Navigator.pop(context);
                    } catch (e) {
                      debugPrint("Error adding reaction: $e");
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(emoji, style: const TextStyle(fontSize: 32)),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  int unreadCount(DocumentSnapshot contact) {
    // For simplicity, can implement real-time query to count unread messages
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    String adminName = Provider.of<AdminProvider>(context).adminName;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Top Header
            Row(
              children: [
                const Text(
                  "Customer Support",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      adminName,
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      "Dashboard Manager",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                const CircleAvatar(
                  radius: 22,
                  backgroundImage: AssetImage("assets/male avatar.png"),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Main Layout (left contact list + right chat panel)
            Expanded(
              child: Row(
                children: [
                  // Left panel
                  Container(
                    width: 350,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Contacts header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Contacts",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF5AFF15), Color(0xFF00B712)],
                                ),
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 4,
                                    offset: Offset(2, 2),
                                  ),
                                ],
                              ),
                              child: Text(
                                contacts.length.toString(),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Search bar
                        TextField(
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.search,
                              size: 18,
                              color: Colors.green,
                            ),
                            hintText: "Search",
                            hintStyle: const TextStyle(fontSize: 14),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 0,
                              horizontal: 12,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Contact List
                        Expanded(
                          child: contacts.isEmpty
                              ? const Center(
                            child: Text(
                              "No Contacts",
                              style: TextStyle(color: Colors.grey),
                            ),
                          )
                              : ListView.builder(
                            itemCount: contacts.length,
                            itemBuilder: (context, index) {
                              final doc = contacts[index];
                              final contact = doc["userName"];
                              final isSelected =
                                  selectedContact?.id == doc.id;
                              bool online = doc["userOnline"] ?? false;
                              final lastMessage = doc["lastMessage"] ?? "";
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedContact = doc;
                                    isUserTyping = false;
                                  });
                                  // Listen to user typing status
                                  listenToUserTyping(doc.id);
                                },
                                child: Container(
                                  margin:
                                  const EdgeInsets.only(bottom: 8),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Colors.green.shade50
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: isSelected
                                          ? Colors.green
                                          : Colors.grey.shade300,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Stack(
                                        children: [
                                          const CircleAvatar(
                                            child: Icon(Icons.person),
                                          ),
                                          Positioned(
                                            bottom: 0,
                                            right: 0,
                                            child: Container(
                                              height: 10,
                                              width: 10,
                                              decoration: BoxDecoration(
                                                color: online
                                                    ? Colors.green
                                                    : Colors.grey,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              contact,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            if (lastMessage.isNotEmpty)
                                              Text(
                                                lastMessage,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey.shade600,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                          ],
                                        ),
                                      ),
                                      if (unreadCount(doc) > 0)
                                        Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: const BoxDecoration(
                                            color: Colors.red,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Text(
                                            unreadCount(doc).toString(),
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12),
                                          ),
                                        )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Right panel (chat area)
                  Expanded(
                    child: selectedContact == null
                        ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/man.png',
                            width: 300,
                            height: 350,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "No Messages Yet !",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            "You're all caught up! Check back later for new updates",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                        : Column(
                      children: [
                        // Chat header with gradient and close button
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF5AFF15), Color(0xFF00B712)],
                            ),
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 18,
                                backgroundColor: Colors.white.withOpacity(0.3),
                                child: Text(
                                  selectedContact!["userName"][0],
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      selectedContact!["userName"],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                    if (isUserTyping)
                                      const Text(
                                        "Typing...",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white70,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              // Close button
                              IconButton(
                                icon: const Icon(Icons.close, color: Colors.white),
                                onPressed: () {
                                  setState(() {
                                    selectedContact = null;
                                    isUserTyping = false;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),

                        // Messages
                        Expanded(
                          child: StreamBuilder<QuerySnapshot>(
                            stream: firestore
                                .collection("support_chats")
                                .doc(selectedContact!.id)
                                .collection("messages")
                                .orderBy("timestamp")
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }

                              if (snapshot.data!.docs.isEmpty) {
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.chat_bubble_outline,
                                        size: 80,
                                        color: Colors.grey.shade400,
                                      ),
                                      const SizedBox(height: 16),
                                      const Text(
                                        "No messages yet",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "Send a message to start chatting",
                                        style: TextStyle(
                                          color: Colors.grey.shade500,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }

                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                scrollToBottom();
                              });

                              return ListView.builder(
                                controller: scrollController,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  final doc = snapshot.data!.docs[index];
                                  return messageBubble(doc as QueryDocumentSnapshot);
                                },
                              );
                            },
                          ),
                        ),

                        // Message input with gradient border and black text
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade200,
                                blurRadius: 4,
                                offset: const Offset(0, -2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.image, color: Colors.green),
                                onPressed: sendImage,
                              ),
                              IconButton(
                                icon: const Icon(Icons.attach_file, color: Colors.green),
                                onPressed: sendFile,
                              ),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFF5AFF15), Color(0xFF00B712)],
                                    ),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: TextField(
                                    controller: messageController,
                                    style: const TextStyle(color: Colors.black),
                                    decoration: InputDecoration(
                                      hintText: "Type message...",
                                      hintStyle: const TextStyle(color: Colors.black54),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide.none,
                                      ),
                                      filled: true,
                                      fillColor: Colors.white.withOpacity(0.9),
                                      contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 10,
                                      ),
                                    ),
                                    onChanged: (text) {
                                      updateTyping(text.isNotEmpty);
                                    },
                                    onSubmitted: (_) {
                                      updateTyping(false);
                                      sendMessage();
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Gradient send button
                              Container(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFF5AFF15), Color(0xFF00B712)],
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.send, color: Colors.white),
                                  onPressed: sendMessage,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}