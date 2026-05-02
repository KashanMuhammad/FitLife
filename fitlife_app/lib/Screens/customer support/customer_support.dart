// user_customer_support_screen.dart
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserCustomerSupportScreen extends StatefulWidget {
  final String userId;
  final String userName;

  const UserCustomerSupportScreen({
    super.key,
    required this.userId,
    required this.userName,
  });

  @override
  State<UserCustomerSupportScreen> createState() => _UserCustomerSupportScreenState();
}

class _UserCustomerSupportScreenState extends State<UserCustomerSupportScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final supabase = Supabase.instance.client;
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  String? chatDocumentId;
  bool isAdminTyping = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    initializeChat();
  }

  @override
  void dispose() {
    // Update user offline status when leaving
    if (chatDocumentId != null) {
      firestore.collection("support_chats").doc(chatDocumentId).update({
        "userOnline": false,
        "isTyping": false,
      });
    }
    messageController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  /// Initialize or get existing chat document
  Future<void> initializeChat() async {
    try {
      // Check if chat document already exists for this user
      QuerySnapshot existingChat = await firestore
          .collection("support_chats")
          .where("userId", isEqualTo: widget.userId)
          .limit(1)
          .get();

      if (existingChat.docs.isNotEmpty) {
        // Use existing chat
        chatDocumentId = existingChat.docs.first.id;

        // Update user online status
        await firestore.collection("support_chats").doc(chatDocumentId).update({
          "userOnline": true,
          "lastSeen": FieldValue.serverTimestamp(),
        });
      } else {
        // Create new chat document
        DocumentReference newChat = await firestore.collection("support_chats").add({
          "userId": widget.userId,
          "userName": widget.userName,
          "userOnline": true,
          "lastMessage": "",
          "lastTime": FieldValue.serverTimestamp(),
          "isTyping": false,
          "createdAt": FieldValue.serverTimestamp(),
          "lastSeen": FieldValue.serverTimestamp(),
        });
        chatDocumentId = newChat.id;
      }

      setState(() {
        _isLoading = false;
      });

      // Listen to admin typing status
      listenToAdminTyping();

    } catch (e) {
      debugPrint("Error initializing chat: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Listen to admin typing status
  void listenToAdminTyping() {
    if (chatDocumentId == null) return;

    firestore.collection("support_chats").doc(chatDocumentId).snapshots().listen((snapshot) {
      if (snapshot.exists && mounted) {
        bool typing = snapshot.data()?['isTyping'] ?? false;
        if (typing != isAdminTyping) {
          setState(() {
            isAdminTyping = typing;
          });
        }
      }
    });
  }

  /// Send text message
  Future<void> sendMessage() async {
    if (messageController.text.trim().isEmpty || chatDocumentId == null) return;

    final messageText = messageController.text.trim();

    try {
      await firestore
          .collection("support_chats")
          .doc(chatDocumentId)
          .collection("messages")
          .add({
        "senderId": widget.userId,
        "senderName": widget.userName,
        "text": messageText,
        "imageUrl": null,
        "fileUrl": null,
        "timestamp": FieldValue.serverTimestamp(),
        "isRead": false,
        "reactions": {},
      });

      await firestore.collection("support_chats").doc(chatDocumentId).update({
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

  /// Send image
  Future<void> sendImage() async {
    if (chatDocumentId == null) return;

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
          .doc(chatDocumentId)
          .collection("messages")
          .add({
        "senderId": widget.userId,
        "senderName": widget.userName,
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

  /// Send file
  Future<void> sendFile() async {
    if (chatDocumentId == null) return;

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(withData: true);
      if (result == null) return;

      final file = result.files.first;
      final fileName = "chat_files/${DateTime.now().millisecondsSinceEpoch}_${file.name}";
      await supabase.storage.from("chat").uploadBinary(fileName, file.bytes!);
      final url = supabase.storage.from("chat").getPublicUrl(fileName);

      await firestore
          .collection("support_chats")
          .doc(chatDocumentId)
          .collection("messages")
          .add({
        "senderId": widget.userId,
        "senderName": widget.userName,
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
    if (chatDocumentId == null) return;

    try {
      await firestore.collection("support_chats").doc(chatDocumentId).update({
        "isTyping": typing,
      });
    } catch (e) {
      debugPrint("Error updating typing status: $e");
    }
  }

  /// Scroll to bottom
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
    final bool isUser = doc["senderId"] == widget.userId;
    final Map<String, dynamic> reactions = Map<String, dynamic>.from(doc["reactions"] ?? {});
    final bool isRead = doc["isRead"] ?? false;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onLongPress: () => showReactions(doc),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          padding: const EdgeInsets.all(12),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          decoration: BoxDecoration(
            color: isUser ? Colors.green : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (doc["text"] != null)
                Text(
                  doc["text"],
                  style: TextStyle(
                    color: isUser ? Colors.white : Colors.black,
                    fontSize: 16,
                  ),
                ),
              if (doc["imageUrl"] != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    doc["imageUrl"],
                    height: 200,
                    width: 250,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        width: 250,
                        color: Colors.grey[300],
                        child: const Icon(Icons.broken_image, size: 50),
                      );
                    },
                  ),
                ),
              if (doc["fileUrl"] != null)
                InkWell(
                  onTap: () {
                    // You can implement file download/view here
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("File: ${doc['fileName'] ?? 'Attachment'}")),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.attach_file,
                          color: isUser ? Colors.white : Colors.black,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            doc['fileName'] ?? "Attachment",
                            style: TextStyle(
                              color: isUser ? Colors.white : Colors.black,
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
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          entry.value.toString(),
                          style: const TextStyle(fontSize: 14),
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
                      color: isUser ? Colors.white70 : Colors.black54,
                    ),
                  ),
                  if (isUser) ...[
                    const SizedBox(width: 4),
                    Icon(
                      isRead ? Icons.done_all : Icons.done,
                      size: 12,
                      color: isRead ? Colors.white70 : Colors.white38,
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
                          .doc(chatDocumentId)
                          .collection("messages")
                          .doc(doc.id)
                          .update({
                        "reactions.${widget.userId}": emoji,
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

  /// Typing indicator widget - Updated to show "Typing..." instead of "Admin is typing..."
  Widget buildTypingIndicator() {
    if (!isAdminTyping) return const SizedBox();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            "Typing...",  // Changed from "Admin is typing..." to "Typing..."
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Customer Support",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Support Info"),
                  content: const Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Our support team is available 24/7 to assist you."),
                      SizedBox(height: 12),
                      Text("You can send:"),
                      SizedBox(height: 4),
                      Text("• Text messages"),
                      Text("• Images"),
                      Text("• Files"),
                      SizedBox(height: 12),
                      Text("💡 Tip: Long press on messages to add reactions!"),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Got it"),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: chatDocumentId != null
                  ? firestore
                  .collection("support_chats")
                  .doc(chatDocumentId)
                  .collection("messages")
                  .orderBy("timestamp")
                  .snapshots()
                  : null,
              builder: (context, snapshot) {
                if (snapshot == null || !snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
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
                    return messageBubble(doc);
                  },
                );
              },
            ),
          ),
          buildTypingIndicator(), // Shows "Typing..." when admin is typing
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 4,
                  offset: const Offset(0, -1),
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
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: "Type your message...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
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
                const SizedBox(width: 8),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.green,
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
    );
  }
}