import 'package:flutter/material.dart';
import 'package:theo/config/app_theme.dart';
import 'package:theo/widgets/chat_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  List<ChatMessage> _messages = [];
  
  @override
  void initState() {
    super.initState();
    _messages = ChatService.chatHistory;
    
    // Add welcome message if chat is empty
    if (_messages.isEmpty) {
      _messages.add(
        ChatMessage(
          message: 'Hello! I\'m Theo, your AI financial assistant. How can I help you today?',
          isUser: false,
        ),
      );
    }
    
    // Scroll to bottom after initial render
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }
  
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }
  
  void _handleSubmitted(String text) {
    if (text.trim().isEmpty) return;
    
    _messageController.clear();
    
    // Add user message
    final userMessage = ChatMessage(
      message: text,
      isUser: true,
    );
    
    setState(() {
      _messages.add(userMessage);
    });
    
    // Add to chat history
    ChatService.addMessage(userMessage);
    
    // Scroll to bottom
    _scrollToBottom();
    
    // Simulate response (in a real app, this would come from an API)
    Future.delayed(const Duration(milliseconds: 1000), () {
      // Example response, replace with actual API call
      final botMessage = ChatMessage(
        message: 'I\'m processing your request about "${text.length > 30 ? text.substring(0, 27) + '...' : text}". This is a placeholder response that would come from the backend in a real implementation.',
        isUser: false,
      );
      
      setState(() {
        _messages.add(botMessage);
      });
      
      // Add to chat history
      ChatService.addMessage(botMessage);
      
      // Scroll to bottom
      _scrollToBottom();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chat with Theo',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(
          color: AppTheme.textPrimary,
        ),
      ),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildMessage(message);
              },
            ),
          ),
          
          // Input area
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, -1),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  // Message input
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: AppTheme.captionStyle,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                      ),
                      onSubmitted: _handleSubmitted,
                    ),
                  ),
                  
                  // Send button
                  IconButton(
                    icon: const Icon(
                      Icons.send,
                      color: AppTheme.primaryColor,
                    ),
                    onPressed: () => _handleSubmitted(_messageController.text),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildMessage(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: message.isUser 
            ? MainAxisAlignment.end 
            : MainAxisAlignment.start,
        children: [
          if (!message.isUser) 
            CircleAvatar(
              backgroundColor: AppTheme.primaryColor,
              radius: 16,
              child: const Text(
                'T',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: message.isUser 
                    ? AppTheme.primaryColor 
                    : Colors.grey[200],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                message.message,
                style: TextStyle(
                  color: message.isUser 
                      ? Colors.white 
                      : AppTheme.textPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          if (message.isUser) 
            const CircleAvatar(
              backgroundColor: Colors.grey,
              radius: 16,
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: 16,
              ),
            ),
        ],
      ),
    );
  }
  
  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}