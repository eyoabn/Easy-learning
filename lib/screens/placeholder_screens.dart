import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class PlaceholderScreen extends StatelessWidget {
  final String title;
  final IconData icon;

  const PlaceholderScreen({Key? key, required this.title, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: Center(
        child: EmptyState(
          icon: icon,
          title: '$title Coming Soon',
          subtitle: 'This feature is currently under development.',
        ),
      ),
    );
  }
}

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => const PlaceholderScreen(title: 'Chat', icon: Icons.chat_bubble_rounded);
}

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => const PlaceholderScreen(title: 'Search', icon: Icons.search_rounded);
}

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => const PlaceholderScreen(title: 'Notifications', icon: Icons.notifications_rounded);
}

class ProfileScreen extends StatelessWidget {
  final VoidCallback? onLogout;
  const ProfileScreen({Key? key, this.onLogout}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const EmptyState(
              icon: Icons.person_rounded,
              title: 'Your Profile',
              subtitle: 'Manage your account settings here.',
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onLogout,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade50,
                foregroundColor: Colors.red,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.logout),
              label: const Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}
