import 'package:flutter/material.dart';
import 'package:theo/screens/chat_screen.dart';

class ChatService {
  // Singleton instance
  static final ChatService _instance = ChatService._internal();
  
  // Factory constructor
  factory ChatService() => _instance;
  
  // Internal constructor
  ChatService._internal();
  
  // Chat history to persist between sessions
  static final List<ChatMessage> _chatHistory = [];
  
  // Get chat history
  static List<ChatMessage> get chatHistory => _chatHistory;
  
  // Add message to history
  static void addMessage(ChatMessage message) {
    _chatHistory.add(message);
  }
  
  // Open chat screen
  static void openChat(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ChatScreen(),
      ),
    );
  }
}

// Chat message model
class ChatMessage {
  final String message;
  final bool isUser;
  final DateTime timestamp;
  
  ChatMessage({
    required this.message,
    required this.isUser,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}