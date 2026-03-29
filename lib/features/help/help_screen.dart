import 'package:flutter/material.dart';
import '../../core/gemini_service.dart';
import '../../core/dependency_injection.dart';
import '../../core/app_state.dart';
import '../../main.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final _messageController = TextEditingController();
  final _geminiService = getIt<GeminiService>();
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkInitialGreeting();
      _scrollToBottom(immediate: true);
    });
  }

  void _checkInitialGreeting() {
    final appState = AppStateProvider.of(context);
    if (appState.chatHistory.isEmpty) {
      appState.addChatMessage(
        'Hello! I am your New You assistant. How can I help you today?',
        'bot'
      );
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom({bool immediate = false}) {
    if (_scrollController.hasClients) {
      if (immediate) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      } else {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    }
  }

  Future<void> _sendMessage(AppState appState) async {
    final userText = _messageController.text.trim();
    if (userText.isNotEmpty) {
      setState(() {
        appState.addChatMessage(userText, 'user');
        _isLoading = true;
        _messageController.clear();
      });
      _scrollToBottom();

      final botResponse = await _geminiService.generateCoachingResponse(userText);

      if (mounted) {
        setState(() {
          appState.addChatMessage(
            botResponse ?? 'I am having trouble connecting right now. Please try again later.',
            'bot'
          );
          _isLoading = false;
        });
        _scrollToBottom();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Column(
          children: [
            Text('NY AI Assistant', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Always here to support you', style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal)),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep_outlined),
            tooltip: 'Clear History',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Clear Chat History?'),
                  content: const Text('This will permanently delete all messages.'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                    TextButton(
                      onPressed: () {
                        appState.clearChatHistory();
                        Navigator.pop(context);
                      },
                      child: const Text('Clear', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: appState,
        builder: (context, child) {
          final messages = appState.chatHistory;

          return Column(
            children: [
              Expanded(
                child: messages.isEmpty 
                  ? _buildEmptyChat()
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(20),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final msg = messages[index];
                        final isUser = msg.sender == 'user';
                        return _ChatBubble(msg: msg.text, isUser: isUser);
                      },
                    ),
              ),
              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: LinearProgressIndicator(minHeight: 2),
                ),
              _buildMessageInput(appState),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyChat() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline_rounded, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text('No messages yet. Say hello!', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildMessageInput(AppState appState) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                enabled: !_isLoading,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                onSubmitted: (_) => _sendMessage(appState),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              onPressed: _isLoading ? null : () => _sendMessage(appState),
              icon: const Icon(Icons.send_rounded),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final String msg;
  final bool isUser;

  const _ChatBubble({required this.msg, required this.isUser});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isUser
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.5),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(isUser ? 20 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 20),
          ),
        ),
        child: Text(
          msg,
          style: TextStyle(
            color: isUser
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.onSecondaryContainer,
            height: 1.4,
          ),
        ),
      ),
    );
  }
}
