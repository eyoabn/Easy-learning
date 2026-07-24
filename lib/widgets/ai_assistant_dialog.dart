import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AIAssistantDialog extends StatefulWidget {
  const AIAssistantDialog({Key? key}) : super(key: key);

  @override
  State<AIAssistantDialog> createState() => _AIAssistantDialogState();
}

class _AIAssistantDialogState extends State<AIAssistantDialog> {
  int _activeTab = 0;
  final TextEditingController _promptController = TextEditingController();
  final List<Map<String, String>> _chatHistory = [
    {'sender': 'ai', 'text': 'Hello! I am your AI Tutor. Ask me anything about your current courses or request step-by-step guidance!'},
  ];
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppTheme.darkCardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppTheme.darkBorderColor),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: 500,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Title Bar (Expanded to prevent overflow)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Row(
                    children: [
                      Text('✨', style: TextStyle(fontSize: 18)),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'LearnSpace AI Suite',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 20, color: AppTheme.textMuted),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(color: AppTheme.darkBorderColor),

            // Tabs
            Row(
              children: [
                Expanded(child: _buildDialogTab(0, 'AI Tutor Bot')),
                Expanded(child: _buildDialogTab(1, 'Auto Quiz Generator')),
              ],
            ),
            const SizedBox(height: 12),

            // Body
            Expanded(
              child: _activeTab == 0 ? _buildTutorTab() : _buildQuizTab(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDialogTab(int index, String label) {
    final isSelected = _activeTab == index;
    return GestureDetector(
      onTap: () => setState(() => _activeTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? AppTheme.primaryColor : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppTheme.primaryColor : AppTheme.textMuted,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildTutorTab() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: _chatHistory.length,
            itemBuilder: (context, i) {
              final isAi = _chatHistory[i]['sender'] == 'ai';
              return Align(
                alignment: isAi ? Alignment.centerLeft : Alignment.centerRight,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isAi ? AppTheme.darkSurfaceColor : AppTheme.primaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _chatHistory[i]['text']!,
                    style: const TextStyle(fontSize: 12, height: 1.4, color: Colors.white),
                  ),
                ),
              );
            },
          ),
        ),
        if (_isLoading)
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _promptController,
                style: const TextStyle(fontSize: 12, color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Ask AI Tutor a question...',
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.send, color: AppTheme.primaryColor),
              onPressed: () {
                if (_promptController.text.trim().isNotEmpty) {
                  final text = _promptController.text.trim();
                  setState(() {
                    _chatHistory.add({'sender': 'user', 'text': text});
                    _promptController.clear();
                    _isLoading = true;
                  });

                  Future.delayed(const Duration(seconds: 1), () {
                    if (mounted) {
                      setState(() {
                        _chatHistory.add({
                          'sender': 'ai',
                          'text': 'Regarding "$text": In MATH 401, integration by parts applies when integrating products of functions. Try practice problem #4!',
                        });
                        _isLoading = false;
                      });
                    }
                  });
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuizTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Automated Quiz Generation',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
        ),
        const SizedBox(height: 4),
        const Text(
          'Select course lesson text to generate practice quizzes automatically:',
          style: TextStyle(color: AppTheme.textMuted, fontSize: 12),
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Generated 5-Question Quiz for MATH 401!')),
            );
          },
          icon: const Icon(Icons.bolt, size: 16),
          label: const Text('Generate Sample Quiz', style: TextStyle(fontSize: 12)),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.accentColor,
            foregroundColor: Colors.black,
          ),
        ),
      ],
    );
  }
}
