import 'package:flutter/material.dart';
import 'package:jammui/chatbot.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ChatbotWindow extends StatefulWidget {
  final VoidCallback onClose;

  const ChatbotWindow({super.key, required this.onClose});

  @override
  State<ChatbotWindow> createState() => _ChatbotWindowState();
}

class _ChatbotWindowState extends State<ChatbotWindow> {
  final TextEditingController _controller = TextEditingController();
  final TogetherAiService _aiService = TogetherAiService();
  final List<Map<String, dynamic>> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  static const Color customGreen = Color(0xFF33B864);
  static const Color accentColor = Color(0xFF1A3C34);

  @override
  void initState() {
    super.initState();
    _loadChatHistory();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadChatHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final String? chatHistory = prefs.getString('chat_history');
    if (chatHistory != null) {
      final List<dynamic> decoded = jsonDecode(chatHistory);
      setState(() {
        _messages.addAll(decoded.map((msg) => Map<String, dynamic>.from(msg)));
      });
    }
  }

  Future<void> _saveChatHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('chat_history', jsonEncode(_messages));
  }

  Future<void> _clearChatHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('chat_history');
    setState(() {
      _messages.clear();
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

  Future<void> _sendMessage() async {
    if (_controller.text.trim().isEmpty) return;

    final userMessage = _controller.text.trim();
    setState(() {
      _messages.add({
        'role': 'user',
        'content': userMessage,
        'timestamp': DateTime.now().toIso8601String(),
      });
      _isLoading = true;
    });
    _controller.clear();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });

    try {
      final response = await _aiService.getChatResponse(userMessage, _messages);
      setState(() {
        _messages.add({
          'role': 'bot',
          'content': response,
          'timestamp': DateTime.now().toIso8601String(),
        });
      });
      await _saveChatHistory();
    } catch (e) {
      setState(() {
        _messages.add({
          'role': 'bot',
          'content': 'Error: $e',
          'timestamp': DateTime.now().toIso8601String(),
        });
      });
      await _saveChatHistory();
    } finally {
      setState(() {
        _isLoading = false;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            customGreen.withOpacity(0.1),
            Colors.white,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [customGreen, accentColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Chatbot',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.white),
                          tooltip: 'Clear Chat',
                          onPressed: _clearChatHistory,
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: widget.onClose,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Chat Area
              Expanded(
                child: _messages.isEmpty
                    ? Center(
                  child: Text(
                    'Start a conversation!',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                )
                    : ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[index];
                    final isUser = message['role'] == 'user';
                    final timestamp = DateTime.parse(message['timestamp']);
                    return Align(
                      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.75,
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isUser
                                ? [customGreen, customGreen.withOpacity(0.8)]
                                : [Colors.grey[100]!, Colors.grey[200]!],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20).copyWith(
                            bottomRight: isUser ? const Radius.circular(4) : null,
                            bottomLeft: !isUser ? const Radius.circular(4) : null,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              message['content']!,
                              style: TextStyle(
                                color: isUser ? Colors.white : Colors.black87,
                                fontSize: 16,
                                height: 1.3,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}',
                              style: TextStyle(
                                color: isUser ? Colors.white70 : Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Loading Indicator
              if (_isLoading)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        margin: const EdgeInsets.only(left: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation(customGreen),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Thinking...',
                              style: TextStyle(
                                color: customGreen,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              // Input Area
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: 'Ask me anything...',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14,
                          ),
                        ),
                        onSubmitted: (_) => _sendMessage(),
                        onTap: () {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            _scrollToBottom();
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [customGreen, accentColor],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: _isLoading
                            ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        )
                            : const Icon(Icons.send_rounded, color: Colors.white),
                        onPressed: _isLoading ? null : _sendMessage,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}