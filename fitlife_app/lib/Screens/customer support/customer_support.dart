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

  Future<void> initializeChat() async {
    try {
      QuerySnapshot existingChat = await firestore
          .collection("support_chats")
          .where("userId", isEqualTo: widget.userId)
          .limit(1)
          .get();

      if (existingChat.docs.isNotEmpty) {
        chatDocumentId = existingChat.docs.first.id;
        await firestore.collection("support_chats").doc(chatDocumentId).update({
          "userOnline": true,
          "lastSeen": FieldValue.serverTimestamp(),
        });
      } else {
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

      listenToAdminTyping();

    } catch (e) {
      debugPrint("Error initializing chat: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

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

  Future<void> sendFile() async {
    if (chatDocumentId == null) return;

    try {
      FilePickerResult? result = await FilePicker.pickFiles(withData: true);
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

  Widget messageBubble(QueryDocumentSnapshot doc) {
    final bool isUser = doc["senderId"] == widget.userId;
    final Map<String, dynamic> reactions = Map<String, dynamic>.from(doc["reactions"] ?? {});
    final bool isRead = doc["isRead"] ?? false;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onLongPress: () => showReactions(doc),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          padding: const EdgeInsets.all(12),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          decoration: BoxDecoration(
            gradient: isUser
                ? const LinearGradient(
              colors: [Color(0xFF5AFF15), Color(0xFF00B712)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )
                : null,
            color: isUser ? null : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (doc["text"] != null)
                Text(
                  doc["text"],
                  style: TextStyle(
                    color: isUser ? Colors.white : Colors.black87,
                    fontSize: 15,
                    height: 1.3,
                  ),
                ),
              if (doc["imageUrl"] != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
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
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("File: ${doc['fileName'] ?? 'Attachment'}")),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.white.withOpacity(0.2) : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.attach_file,
                          color: isUser ? Colors.white : Colors.black87,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            doc['fileName'] ?? "Attachment",
                            style: TextStyle(
                              color: isUser ? Colors.white : Colors.black87,
                              fontSize: 13,
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
                  padding: const EdgeInsets.only(top: 6),
                  child: Wrap(
                    spacing: 4,
                    children: reactions.entries.map((entry) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: isUser ? Colors.white.withOpacity(0.3) : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          entry.value.toString(),
                          style: const TextStyle(fontSize: 14),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    formatTimestamp(doc["timestamp"]),
                    style: TextStyle(
                      fontSize: 10,
                      color: isUser ? Colors.white70 : Colors.grey.shade500,
                    ),
                  ),
                  if (isUser && isRead) ...[
                    const SizedBox(width: 6),
                    Icon(
                      Icons.done_all,
                      size: 12,
                      color: Colors.white70,
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

  void showReactions(QueryDocumentSnapshot doc) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Add Reaction",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
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
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Text(emoji, style: const TextStyle(fontSize: 32)),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget buildTypingIndicator() {
    if (!isAdminTyping) return const SizedBox();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(
              child: SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00B712)),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              "Typing",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.support_agent, size: 20),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Admin",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  "Online • Usually replies in minutes",
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: const Color(0xFF00B712),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(30),
            ),
            child: IconButton(
              icon: const Icon(Icons.info_outline, size: 22),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    title: const Row(
                      children: [
                        Icon(Icons.support_agent, color: Color(0xFF00B712)),
                        SizedBox(width: 10),
                        Text("Support Info"),
                      ],
                    ),
                    content: const Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Our support team is available 24/7 to assist you."),
                        SizedBox(height: 16),
                        Text("💬 You can send:"),
                        SizedBox(height: 6),
                        Text("  • Text messages"),
                        Text("  • Images (JPEG, PNG)"),
                        Text("  • Files (PDF, DOC)"),
                        SizedBox(height: 16),
                        Text(
                          "💡 Tip: Long press on messages to add reactions!",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          "Got it",
                          style: TextStyle(color: Color(0xFF00B712)),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
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
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.chat_bubble_outline,
                            size: 60,
                            color: Colors.grey.shade400,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "No messages yet",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Send a message to start chatting",
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 14,
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
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final doc = snapshot.data!.docs[index];
                    return messageBubble(doc);
                  },
                );
              },
            ),
          ),
          buildTypingIndicator(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.image, color: Color(0xFF00B712), size: 24),
                        onPressed: sendImage,
                      ),
                      IconButton(
                        icon: const Icon(Icons.attach_file, color: Color(0xFF00B712), size: 24),
                        onPressed: sendFile,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextField(
                      controller: messageController,
                      decoration: InputDecoration(
                        hintText: "Type your message...",
                        hintStyle: TextStyle(color: Colors.grey.shade400),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
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
                Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF5AFF15), Color(0xFF00B712)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF00B712).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white, size: 20),
                    onPressed: sendMessage,
                    padding: const EdgeInsets.all(12),
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