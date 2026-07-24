import 'package:flutter/material.dart';
import '../models/lms_data.dart';
import '../theme/app_theme.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Screen Header
          const Text(
            'SYSTEM ADMINISTRATOR',
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
            'Global tenant management, RBAC, LiveKit SFU metrics & audit logs.',
            style: TextStyle(color: AppTheme.textMuted, fontSize: 13),
          ),
          const SizedBox(height: 20),

          // Custom Tab Selector
          Row(
            children: [
              _buildTabChip(0, 'Overview'),
              const SizedBox(width: 8),
              _buildTabChip(1, 'Approvals (3)'),
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
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
            _buildStatCard('Teachers', '428', '12 Approvals pending'),
            _buildStatCard('Students', '18,520', '99.4% Active'),
            _buildStatCard('LiveKit SFU', '38 Active', '1,420 Viewers'),
          ],
        ),
        const SizedBox(height: 20),

        // System Health Card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'LiveKit Media Engine & DB Health',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.accentColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.accentColor.withOpacity(0.3)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.circle, color: AppTheme.accentColor, size: 8),
                          SizedBox(width: 4),
                          Text('Operational', style: TextStyle(color: AppTheme.accentColor, fontSize: 11)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'PostgreSQL 16 Primary Node · 1.2ms Latency\nLiveKit WebRTC Cluster · 3.4 Gbps Bandwidth\nMinIO S3 Bucket · 18.4 TB / 50 TB Used',
                  style: TextStyle(color: AppTheme.textMuted, fontSize: 12, height: 1.5),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Triggered PostgreSQL Backup Snapshot...')),
                    );
                  },
                  icon: const Icon(Icons.backup, size: 16),
                  label: const Text('Trigger System Backup'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.darkSurfaceColor,
                    foregroundColor: Colors.white,
                  ),
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
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label.toUpperCase(), style: const TextStyle(color: AppTheme.textMuted, fontSize: 10, letterSpacing: 1)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 2),
            Text(sub, style: const TextStyle(color: AppTheme.textMuted, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _buildApprovalsTab() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Pending Teacher Registrations', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 12),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              separatorBuilder: (_, __) => const Divider(color: AppTheme.darkBorderColor),
              itemBuilder: (context, i) {
                final names = ['Dr. Julian Thorne', 'Dr. Amrita Roy', 'Prof. Lucas Meyer'];
                final depts = ['Computer Science', 'Bio-Physics', 'Mechanical Eng'];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(names[i], style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  subtitle: Text(depts[i], style: const TextStyle(color: AppTheme.textMuted, fontSize: 12)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check_circle, color: AppTheme.accentColor),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Approved ${names[i]}')),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.cancel, color: AppTheme.alertRed),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Rejected ${names[i]}')),
                          );
                        },
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Immutable Audit Trail (PostgreSQL)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 12),
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
                  title: Text(log.action, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  subtitle: Text('${log.actor} · ${log.target}', style: const TextStyle(color: AppTheme.textMuted, fontSize: 11)),
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
