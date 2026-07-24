import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../theme/app_theme.dart';

class PendingApprovalScreen extends StatelessWidget {
  final UserModel user;
  final VoidCallback onCheckStatus;
  final VoidCallback onSignOut;

  const PendingApprovalScreen({
    Key? key,
    required this.user,
    required this.onCheckStatus,
    required this.onSignOut,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppTheme.darkCardColor,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppTheme.darkBorderColor),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppTheme.warningColor.withOpacity(0.15),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppTheme.warningColor.withOpacity(0.4)),
                  ),
                  child: const Icon(Icons.hourglass_top_rounded, color: AppTheme.warningColor, size: 36),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Registration Pending Approval',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Hello ${user.name}, your account registration as a ${user.role.name.toUpperCase()} in ${user.department} has been submitted.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppTheme.textMuted, fontSize: 13, height: 1.5),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.darkSurfaceColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.shield_outlined, color: AppTheme.primaryColor, size: 20),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Governance Policy: System Administrator must verify credentials before granting access.',
                          style: TextStyle(color: Colors.white70, fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onSignOut,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.textMuted,
                          side: const BorderSide(color: AppTheme.darkBorderColor),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('Sign Out'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onCheckStatus,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('Refresh Status'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
