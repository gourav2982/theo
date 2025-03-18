import 'package:flutter/material.dart';
import 'package:theo/config/app_theme.dart';

class ChatScreen extends StatefulWidget {
  final Map<String, dynamic>? challengeData;

  const ChatScreen({
    Key? key,
    this.challengeData,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  bool _showInfo = false;

  // Sample challenge data
  late final Map<String, dynamic> _challenge;

  // Sample messages data
  final List<Map<String, dynamic>> _messages = [
    {
      'id': 1,
      'user': 'trader_joe',
      'avatar': '👨‍💼',
      'text': 'Just bought some AAPL, looking bullish to me!',
      'time': '10:32 AM',
      'isCurrentUser': false
    },
    {
      'id': 2,
      'user': 'stockwhiz',
      'avatar': '👩‍💻',
      'text': 'I think tech is going to outperform this week. Anyone else seeing this trend?',
      'time': '10:45 AM',
      'isCurrentUser': false
    },
    {
      'id': 3,
      'user': 'investor123',
      'avatar': '🧔',
      'text': 'The market seems overvalued right now. I\'m keeping some cash on the sidelines.',
      'time': '11:02 AM',
      'isCurrentUser': false
    },
    {
      'id': 4,
      'user': 'You',
      'avatar': '😎',
      'text': 'NVDA has been on a tear lately. Just added some to my portfolio.',
      'time': '11:15 AM',
      'isCurrentUser': true
    },
    {
      'id': 5,
      'user': 'stockwhiz',
      'avatar': '👩‍💻',
      'text': 'Good call on NVDA! Did you see their latest earnings report?',
      'time': '11:18 AM',
      'isCurrentUser': false
    },
    {
      'id': 6,
      'user': 'market_guru',
      'avatar': '🧙‍♂️',
      'text': 'I\'m watching the Fed closely this week. Any rate hints could move the market significantly.',
      'time': '11:32 AM',
      'isCurrentUser': false
    },
    {
      'id': 7,
      'user': 'You',
      'avatar': '😎',
      'text': 'Yes, the earnings were impressive. Their AI segment is growing faster than expected.',
      'time': '11:45 AM',
      'isCurrentUser': true
    },
    {
      'id': 8,
      'user': 'trader_joe',
      'avatar': '👨‍💼',
      'text': 'Anyone have thoughts on the energy sector this week?',
      'time': '12:01 PM',
      'isCurrentUser': false
    },
  ];

  // Sample participants data
  final List<Map<String, dynamic>> _participants = [
    {'id': 1, 'name': 'trader_joe', 'avatar': '👨‍💼', 'status': 'online', 'ranking': 12},
    {'id': 2, 'name': 'stockwhiz', 'avatar': '👩‍💻', 'status': 'online', 'ranking': 5},
    {'id': 3, 'name': 'investor123', 'avatar': '🧔', 'status': 'online', 'ranking': 28},
    {'id': 4, 'name': 'You', 'avatar': '😎', 'status': 'online', 'ranking': 24},
    {'id': 5, 'name': 'market_guru', 'avatar': '🧙‍♂️', 'status': 'away', 'ranking': 1},
    {'id': 6, 'name': 'value_hunter', 'avatar': '🕵️', 'status': 'offline', 'ranking': 37},
    {'id': 7, 'name': 'bull_trader', 'avatar': '🐂', 'status': 'online', 'ranking': 15},
    {'id': 8, 'name': 'bear_investor', 'avatar': '🐻', 'status': 'offline', 'ranking': 42},
  ];

  @override
  void initState() {
    super.initState();
    
    // Use provided challenge data or default
    _challenge = widget.challengeData ?? {
      'name': "S&P 500 Weekly Challenge",
      'participants': 142,
      'endDate': "Mar 20, 2025"
    };
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _handleSendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      // In a real app, you would add the message to the state or send it to a backend
      setState(() {
        _messages.add({
          'id': _messages.length + 1,
          'user': 'You',
          'avatar': '😎',
          'text': _messageController.text,
          'time': '${DateTime.now().hour}:${DateTime.now().minute} ${DateTime.now().hour >= 12 ? 'PM' : 'AM'}',
          'isCurrentUser': true
        });
        _messageController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: _buildMessagesArea(),
              ),
              _buildMessageInput(),
            ],
          ),
          _buildFloatingShareButton(),
          if (_showInfo) _buildInfoPanel(),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _challenge['name'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '${_challenge['participants']} participants',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.info_outline, color: Colors.white),
              onPressed: () {
                setState(() {
                  _showInfo = true;
                });
              },
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            const SizedBox(width: 16),
            IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () {},
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessagesArea() {
    return Container(
      color: Colors.grey.shade100,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _messages.length + 1, // +1 for date separator
        itemBuilder: (context, index) {
          if (index == 0) {
            // Date separator
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'Today',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          
          final message = _messages[index - 1];
          return _buildMessageItem(message);
        },
      ),
    );
  }

  Widget _buildMessageItem(Map<String, dynamic> message) {
    final isCurrentUser = message['isCurrentUser'];
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isCurrentUser) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  message['avatar'],
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (!isCurrentUser)
                  Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 2),
                    child: Text(
                      message['user'],
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isCurrentUser ? AppTheme.primaryColor : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: isCurrentUser ? const Radius.circular(16) : Radius.zero,
                      bottomRight: isCurrentUser ? Radius.zero : const Radius.circular(16),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message['text'],
                        style: TextStyle(
                          color: isCurrentUser ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        message['time'],
                        style: TextStyle(
                          fontSize: 11,
                          color: isCurrentUser ? Colors.white70 : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (isCurrentUser) const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.emoji_emotions_outlined, color: Colors.grey.shade600),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.attach_file, color: Colors.grey.shade600),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.image_outlined, color: Colors.grey.shade600),
              onPressed: () {},
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: TextField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    hintText: 'Type a message...',
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                  onSubmitted: (_) => _handleSendMessage(),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _messageController.text.trim().isNotEmpty
                    ? AppTheme.primaryColor
                    : Colors.grey.shade200,
              ),
              child: IconButton(
                icon: Icon(
                  Icons.send,
                  color: _messageController.text.trim().isNotEmpty
                      ? Colors.white
                      : Colors.grey.shade400,
                  size: 20,
                ),
                onPressed: _handleSendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingShareButton() {
    return Positioned(
      bottom: 80,
      right: 16,
      child: FloatingActionButton(
        backgroundColor: AppTheme.primaryColor,
        onPressed: () {},
        child: const Icon(Icons.share, size: 20),
      ),
    );
  }

  Widget _buildInfoPanel() {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        _showInfo = false;
                      });
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      'Group Info',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_vert, color: Colors.white),
                    onPressed: () {},
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
            
            // Challenge Info
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.blue.shade50,
              child: Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.emoji_events,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _challenge['name'],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Text(
                    'Group Chat',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                'Participants',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _challenge['participants'].toString(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 40,
                          color: Colors.grey.shade200,
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                'End Date',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _challenge['endDate'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
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
            
            // Participants List
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.people,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Participants (${_participants.length})',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: ListView.separated(
                          itemCount: _participants.length,
                          separatorBuilder: (context, index) => Divider(
                            height: 1,
                            color: Colors.grey.shade200,
                          ),
                          itemBuilder: (context, index) {
                            final participant = _participants[index];
                            return Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        participant['avatar'],
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              participant['name'],
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            if (participant['name'] == 'You')
                                              Container(
                                                margin: const EdgeInsets.only(left: 8),
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                  vertical: 2,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.blue.shade100,
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                child: Text(
                                                  'You',
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.blue.shade700,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              width: 8,
                                              height: 8,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: participant['status'] == 'online'
                                                    ? Colors.green
                                                    : participant['status'] == 'away'
                                                        ? Colors.amber
                                                        : Colors.grey,
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              participant['status'].toString().capitalize(),
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        'Rank',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                      Text(
                                        participant['ranking'].toString(),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}