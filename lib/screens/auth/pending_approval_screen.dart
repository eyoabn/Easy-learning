import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';

class PendingApprovalScreen extends StatelessWidget {
  final String role;
  final VoidCallback? onLogout;

  const PendingApprovalScreen({
    Key? key,
    required this.role,
    this.onLogout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isTeacher = role == 'teacher';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: AppGradients.orange,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [BoxShadow(color: AppColors.cyan.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 8))],
                ),
                child: const Icon(Icons.hourglass_top_rounded, color: Colors.white, size: 48),
              ),
              const SizedBox(height: 32),

              // Title
              const Text(
                'Awaiting Approval',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              // Subtitle
              Text(
                isTeacher
                    ? 'Your teacher account has been registered successfully. An admin will review and approve your account shortly.'
                    : 'Your student account is pending approval. Please wait for an administrator to verify your enrollment.',
                style: const TextStyle(fontSize: 15, color: AppColors.textSecondary, height: 1.6),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Status card
              GlassCard(
                padding: const EdgeInsets.all(20),
                child: Column(children: [
                  _StatusStep(
                    icon: Icons.person_add_rounded,
                    label: 'Account Created',
                    done: true,
                  ),
                  _StatusLine(),
                  _StatusStep(
                    icon: Icons.admin_panel_settings_rounded,
                    label: 'Admin Review',
                    done: false,
                    active: true,
                  ),
                  _StatusLine(),
                  _StatusStep(
                    icon: Icons.check_circle_rounded,
                    label: isTeacher ? 'Access Granted' : 'Enrollment Confirmed',
                    done: false,
                  ),
                ]),
              ),
              const SizedBox(height: 32),

              // Info chip
              InfoChip(
                label: '⏱  Approval usually takes less than 24 hours',
                color: AppColors.blue,
              ),
              const SizedBox(height: 40),

              // Logout
              if (onLogout != null)
                TextButton.icon(
                  onPressed: onLogout,
                  icon: const Icon(Icons.logout_rounded, size: 16, color: AppColors.textSecondary),
                  label: const Text('Sign out', style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusStep extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool done;
  final bool active;

  const _StatusStep({required this.icon, required this.label, required this.done, this.active = false});

  @override
  Widget build(BuildContext context) {
    final color = done ? AppColors.emerald : active ? AppColors.blue : AppColors.textSecondary;

    return Row(children: [
      Container(
        width: 36, height: 36,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          shape: BoxShape.circle,
          border: Border.all(color: color.withValues(alpha: 0.4), width: 1.5),
        ),
        child: Icon(done ? Icons.check_rounded : icon, color: color, size: 18),
      ),
      const SizedBox(width: 12),
      Text(
        label,
        style: TextStyle(
          fontWeight: active || done ? FontWeight.bold : FontWeight.normal,
          color: done ? AppColors.emerald : active ? AppColors.textPrimary : AppColors.textSecondary,
          fontSize: 14,
        ),
      ),
      if (active) ...[
        const SizedBox(width: 8),
        SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.blue)),
      ],
    ]);
  }
}

class _StatusLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(left: 17),
    child: Container(width: 2, height: 20, color: AppColors.border),
  );
}
