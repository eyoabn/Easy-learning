import 'package:flutter/material.dart';
import '../../models/lms_data.dart';
import '../../models/user_model.dart';
import '../../theme/app_theme.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _selectedTab = 0;

  void _approveUser(UserModel user) {
    setState(() {
      user.accountStatus = AccountStatus.approved;
      LmsDataMock.pendingRegistrations.removeWhere((item) => item.id == user.id);
      LmsDataMock.sampleAuditLogs.insert(
        0,
        AuditLogItem(
          id: 'LOG-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
          timestamp: 'Just now',
          actor: 'Admin (System Admin)',
          action: 'USER_REGISTRATION_APPROVED',
          target: '${user.name} (${user.role.name})',
          ip: '192.168.1.100',
        ),
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Approved registration for ${user.name} (${user.role.name.toUpperCase()})'),
        backgroundColor: AppTheme.accentColor,
      ),
    );
  }

  void _rejectUser(UserModel user) {
    setState(() {
      user.accountStatus = AccountStatus.rejected;
      LmsDataMock.pendingRegistrations.removeWhere((item) => item.id == user.id);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Rejected registration for ${user.name}'),
        backgroundColor: AppTheme.alertRed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pendingCount = LmsDataMock.pendingRegistrations.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Banner
          const Text(
            'SYSTEM GOVERNANCE & CONTROL CENTER',
            style: TextStyle(
              color: AppTheme.accentColor,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Institutional Governance',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            'Manage teacher/student approvals, RBAC permissions, LiveKit SFU quotas & security audit logs.',
            style: TextStyle(color: AppTheme.textMuted, fontSize: 13),
          ),
          const SizedBox(height: 20),

          // Custom Tab Switcher
          Row(
            children: [
              _buildTabChip(0, 'Overview & Health'),
              const SizedBox(width: 8),
              _buildTabChip(1, 'Pending Approvals ($pendingCount)'),
              const SizedBox(width: 8),
              _buildTabChip(2, 'Audit Logs'),
            ],
          ),
          const SizedBox(height: 20),

          if (_selectedTab == 0) _buildOverviewTab(),
          if (_selectedTab == 1) _buildApprovalsTab(),
          if (_selectedTab == 2) _buildAuditLogsTab(),
        ],
      ),
    );
  }

  Widget _buildTabChip(int index, String label) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : AppTheme.darkSurfaceColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : AppTheme.darkBorderColor,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppTheme.textMuted,
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildOverviewTab() {
    return Column(
      children: [
        // Metrics Grid
        GridView.count(
          crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.4,
          children: [
            _buildStatCard('Schools', '14', '3 Pending setup'),
            _buildStatCard('Active Teachers', '428', '${LmsDataMock.pendingRegistrations.length} Approvals pending'),
            _buildStatCard('Enrolled Students', '18,520', '99.4% Active'),
            _buildStatCard('LiveKit Media SFU', '38 Active', '1,420 Viewers'),
          ],
        ),
        const SizedBox(height: 20),

        // Live Infrastructure Health Card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'LiveKit Media SFU & Database Health',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.accentColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.accentColor.withValues(alpha: 0.3)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.circle, color: AppTheme.accentColor, size: 8),
                          SizedBox(width: 6),
                          Text('All Systems Operational', style: TextStyle(color: AppTheme.accentColor, fontSize: 11, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Text(
                  '● PostgreSQL 16 Primary Cluster · 1.2ms Latency · 99.99% Uptime\n● LiveKit WebRTC SFU Media Nodes · 4 Active · 3.4 Gbps Bandwidth\n● MinIO S3 Object Storage · 18.4 TB / 50 TB Allocated',
                  style: TextStyle(color: AppTheme.textMuted, fontSize: 13, height: 1.6),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Triggering PostgreSQL Database Backup Snapshot...')),
                        );
                      },
                      icon: const Icon(Icons.backup, size: 16),
                      label: const Text('Trigger DB Backup'),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Flushed Redis Authorization Cache.')),
                        );
                      },
                      icon: const Icon(Icons.refresh, size: 16),
                      label: const Text('Flush RBAC Cache'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: AppTheme.darkBorderColor),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, String sub) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label.toUpperCase(), style: const TextStyle(color: AppTheme.textMuted, fontSize: 10, letterSpacing: 1, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(sub, style: const TextStyle(color: AppTheme.textMuted, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _buildApprovalsTab() {
    final pending = LmsDataMock.pendingRegistrations;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Pending User Registrations', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.warningColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${pending.length} Action Required',
                    style: const TextStyle(color: AppTheme.warningColor, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            const Text(
              'Teachers & Students who registered must be verified by the Admin before unlocking portal access.',
              style: TextStyle(color: AppTheme.textMuted, fontSize: 12),
            ),
            const SizedBox(height: 16),
            if (pending.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24.0),
                child: Center(
                  child: Text(
                    'No pending user registration requests. All clear!',
                    style: TextStyle(color: AppTheme.textMuted, fontSize: 13),
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: pending.length,
                separatorBuilder: (_, __) => const Divider(color: AppTheme.darkBorderColor),
                itemBuilder: (context, i) {
                  final user = pending[i];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.2),
                      child: Text(
                        user.name[0],
                        style: const TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Row(
                      children: [
                        Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            user.role.name.toUpperCase(),
                            style: const TextStyle(color: AppTheme.primaryColor, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    subtitle: Text('${user.email} · ${user.department} · Registered: ${user.registeredAt}', style: const TextStyle(color: AppTheme.textMuted, fontSize: 12)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => _approveUser(user),
                          icon: const Icon(Icons.check, size: 14),
                          label: const Text('Approve'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.accentColor,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            minimumSize: const Size(60, 32),
                          ),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton(
                          onPressed: () => _rejectUser(user),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppTheme.alertRed,
                            side: const BorderSide(color: AppTheme.alertRed),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            minimumSize: const Size(60, 32),
                          ),
                          child: const Text('Reject'),
                        ),
                      ],
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAuditLogsTab() {
    final logs = LmsDataMock.sampleAuditLogs;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Immutable Audit Trail (PostgreSQL Logs)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 14),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: logs.length,
              separatorBuilder: (_, __) => const Divider(color: AppTheme.darkBorderColor),
              itemBuilder: (context, i) {
                final log = logs[i];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Text(log.id, style: const TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold, fontSize: 11)),
                  title: Text(log.action, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  subtitle: Text('${log.actor} -> ${log.target}', style: const TextStyle(color: AppTheme.textMuted, fontSize: 12)),
                  trailing: Text(log.timestamp, style: const TextStyle(color: AppTheme.textMuted, fontSize: 11)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
