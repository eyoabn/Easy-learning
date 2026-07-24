import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class LiveMeetingScreen extends StatefulWidget {
  final bool isTeacher;
  const LiveMeetingScreen({Key? key, required this.isTeacher}) : super(key: key);

  @override
  State<LiveMeetingScreen> createState() => _LiveMeetingScreenState();
}

class _LiveMeetingScreenState extends State<LiveMeetingScreen> {
  bool _isMuted = false;
  bool _isVideoOff = false;
  bool _isHandRaised = false;
  bool _showChat = false;

  final List<Map<String, String>> _messages = [
    {'sender': 'Dr. Vasquez', 'text': 'Welcome everyone! Today we discuss differential equations.'},
    {'sender': 'Amara Diallo', 'text': 'Ready! Will integration by parts be on the midterm?'},
  ];
  final TextEditingController _msgController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080B10),
      appBar: AppBar(
        backgroundColor: AppTheme.darkCardColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'MATH 401 — Advanced Math',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              'LiveKit WebRTC Classroom · 6 Active',
              style: TextStyle(color: AppTheme.accentColor, fontSize: 10),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(_showChat ? Icons.chat_bubble : Icons.chat_bubble_outline, color: AppTheme.primaryColor),
            onPressed: () => setState(() => _showChat = !_showChat),
          ),
        ],
      ),
      body: Row(
        children: [
          // Main Video Grid
          Expanded(
            child: Column(
              children: [
                // Instructor Main Tile
                Expanded(
                  flex: 3,
                  child: Container(
                    margin: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.darkCardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.5), width: 2),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: CircleAvatar(
                            radius: 36,
                            backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.3),
                            child: const Text('EV', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
                          ),
                        ),
                        Positioned(
                          bottom: 12,
                          left: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.7),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.star, color: AppTheme.accentColor, size: 12),
                                SizedBox(width: 4),
                                Text(
                                  'Dr. Elena Vasquez (Instructor)',
                                  style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Student Grid Row
                Expanded(
                  flex: 2,
                  child: GridView.count(
                    crossAxisCount: 3,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    children: [
                      _buildParticipantTile('Amara Diallo', 'AD', true),
                      _buildParticipantTile('Luca Ferretti', 'LF', false),
                      _buildParticipantTile('Yuna Park', 'YP', true),
                    ],
                  ),
                ),

                // Scrollable Bottom Controls Bar (Prevents Overflow)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  color: AppTheme.darkCardColor,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: Icon(_isMuted ? Icons.mic_off : Icons.mic),
                          color: _isMuted ? AppTheme.alertRed : Colors.white,
                          onPressed: () => setState(() => _isMuted = !_isMuted),
                        ),
                        IconButton(
                          icon: Icon(_isVideoOff ? Icons.videocam_off : Icons.videocam),
                          color: _isVideoOff ? AppTheme.alertRed : Colors.white,
                          onPressed: () => setState(() => _isVideoOff = !_isVideoOff),
                        ),
                        IconButton(
                          icon: Icon(Icons.back_hand, color: _isHandRaised ? AppTheme.accentColor : Colors.white),
                          onPressed: () => setState(() => _isHandRaised = !_isHandRaised),
                        ),
                        if (widget.isTeacher)
                          IconButton(
                            icon: const Icon(Icons.screen_share, color: AppTheme.primaryColor),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Sharing Screen via LiveKit SDK...')),
                              );
                            },
                          ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(backgroundColor: AppTheme.alertRed),
                          child: const Text('Leave', style: TextStyle(color: Colors.white, fontSize: 12)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Chat Drawer
          if (_showChat)
            Container(
              width: 220,
              color: AppTheme.darkCardColor,
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text('Live Chat', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
                  ),
                  const Divider(height: 1, color: AppTheme.darkBorderColor),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: _messages.length,
                      itemBuilder: (context, i) {
                        final m = _messages[i];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(m['sender']!, style: const TextStyle(color: AppTheme.textMuted, fontSize: 10, fontWeight: FontWeight.bold)),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppTheme.darkSurfaceColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(m['text']!, style: const TextStyle(fontSize: 11, color: Colors.white)),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _msgController,
                            style: const TextStyle(fontSize: 11, color: Colors.white),
                            decoration: const InputDecoration(hintText: 'Send message...', contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 6)),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.send, color: AppTheme.primaryColor, size: 16),
                          onPressed: () {
                            if (_msgController.text.trim().isNotEmpty) {
                              setState(() {
                                _messages.add({'sender': widget.isTeacher ? 'Dr. Vasquez' : 'Amara Diallo', 'text': _msgController.text.trim()});
                                _msgController.clear();
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildParticipantTile(String name, String initials, bool isVideoOn) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.darkSurfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.darkBorderColor),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.2),
              child: Text(initials, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
            ),
            const SizedBox(height: 4),
            Text(name.split(' ')[0], style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: Colors.white), overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}
