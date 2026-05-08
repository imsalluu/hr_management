import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_management/features/auth/presentation/auth_state.dart';
import 'package:hr_management/shared/widgets/custom_widgets.dart';
import 'package:hr_management/shared/widgets/main_layout.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final theme = Theme.of(context);
    final isDesktop = MediaQuery.of(context).size.width > 900;
    final isOwner = user?.role == UserRole.businessOwner;
    final isManagement = isOwner || user?.role == UserRole.hr;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isOwner) ...[
            _SubscriptionBanner(theme: theme),
            const SizedBox(height: 32),
          ],

          // Announcements Section
          _AnnouncementSection(isOwner: isOwner),
          const SizedBox(height: 32),
          
          // Welcome Section
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Good Morning, ${user?.name.split(' ').first ?? 'User'}!',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      'Here is what\'s happening in your company today.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              if (isDesktop)
                CustomButton(
                  text: 'View Profile',
                  icon: Icons.person_outline,
                  onPressed: () {},
                ),
            ],
          ),
          const SizedBox(height: 32),

          // Stats Grid
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth > 1200 ? 4 : (constraints.maxWidth > 700 ? 2 : 1);

              return GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 2.5,
                children: isManagement
                    ? [
                        _StatCard(
                          title: 'Total Employees',
                          value: '124',
                          icon: Icons.people_outline,
                          color: Colors.blue.shade400,
                        ),
                        _StatCard(
                          title: 'Daily Attendance',
                          value: '94%',
                          icon: Icons.done_all_rounded,
                          color: Colors.green.shade400,
                        ),
                        _StatCard(
                          title: 'Pending Approvals',
                          value: '08',
                          icon: Icons.assignment_late_outlined,
                          color: Colors.orange.shade400,
                        ),
                        _StatCard(
                          title: 'Active Shifts',
                          value: '03',
                          icon: Icons.schedule_outlined,
                          color: Colors.purple.shade400,
                        ),
                      ]
                    : [
                        _StatCard(
                          title: 'My Attendance',
                          value: '98%',
                          icon: Icons.fingerprint_rounded,
                          color: Colors.green.shade400,
                        ),
                        _StatCard(
                          title: 'Leave Balance',
                          value: '14',
                          icon: Icons.beach_access_outlined,
                          color: Colors.blue.shade400,
                        ),
                        _StatCard(
                          title: 'Working Hours',
                          value: '168h',
                          icon: Icons.timer_outlined,
                          color: Colors.orange.shade400,
                        ),
                        _StatCard(
                          title: 'Pending Claims',
                          value: '02',
                          icon: Icons.payments_outlined,
                          color: Colors.purple.shade400,
                        ),
                      ],
              );
            },
          ),
          const SizedBox(height: 32),

          if (isManagement) ...[
            const Text(
              'Quick Management Actions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _QuickActionCard(
                  title: 'Onboard Employee',
                  icon: Icons.person_add_outlined,
                  color: Colors.blue,
                  onTap: () => context.go('/employee'),
                ),
                _QuickActionCard(
                  title: 'Create Shift',
                  icon: Icons.more_time_outlined,
                  color: Colors.purple,
                  onTap: () => context.go('/shift'),
                ),
                _QuickActionCard(
                  title: 'Review Leaves',
                  icon: Icons.fact_check_outlined,
                  color: Colors.orange,
                  onTap: () => context.go('/approvals'),
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],

          // Content Area (Two Columns on Desktop)
          Flex(
            direction: isDesktop ? Axis.horizontal : Axis.vertical,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Column: Recent Activities / Attendance Log
              Expanded(
                flex: isDesktop ? 2 : 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isManagement ? 'Company Attendance Feed' : 'My Attendance History',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    CustomCard(
                      padding: EdgeInsets.zero,
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: isManagement ? 5 : 2,
                        separatorBuilder: (context, index) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: CircleAvatar(
                              radius: 18,
                              backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=${isManagement ? index + 20 : 99}'),
                            ),
                            title: Text(isManagement ? (index == 0 ? 'Fahim Ahmed' : 'Sarah Smith') : user?.name ?? 'User', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            subtitle: Text('Checked in at 09:12 AM • ${isManagement ? 'Main Office' : 'Remote'}', style: const TextStyle(fontSize: 12)),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'On Time',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    if (isOwner) ...[
                      const SizedBox(height: 32),
                      const Text(
                        'Operational Insights',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: isDesktop ? 2 : 1,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 2.2,
                        children: [
                          _ReportCard(
                            title: 'Payroll Summary',
                            subtitle: 'Monthly disbursement stats',
                            icon: Icons.payments_outlined,
                            color: Colors.indigo,
                          ),
                          _ReportCard(
                            title: 'Attendance Trends',
                            subtitle: 'Weekly on-time performance',
                            icon: Icons.show_chart_rounded,
                            color: Colors.teal,
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              if (isDesktop) const SizedBox(width: 32) else const SizedBox(height: 32),
              
              // Right Column: Upcoming Leaves / Birthdays
              Expanded(
                flex: isDesktop ? 1 : 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isManagement ? 'Department Status' : 'Upcoming Holidays',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    CustomCard(
                      child: Column(
                        children: isManagement 
                          ? [
                              const _ManagementStatusItem(label: 'On Leave Today', value: '04 Employees', color: Colors.orange),
                              const SizedBox(height: 16),
                              const _ManagementStatusItem(label: 'Late Check-ins', value: '02 Employees', color: Colors.red),
                              const SizedBox(height: 16),
                              const _ManagementStatusItem(label: 'Upcoming Birthdays', value: 'Sarah (Tomorrow)', color: Colors.blue),
                              const SizedBox(height: 24),
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton(
                                  onPressed: () => context.go('/approvals'),
                                  child: const Text('View All Approvals'),
                                ),
                              ),
                            ]
                          : [
                              _LeaveItem(name: 'Labor Day', reason: 'Official Holiday', duration: '01 May', isPublic: true),
                              const SizedBox(height: 12),
                              _LeaveItem(name: 'Eid-ul-Fitr', reason: 'Religious Holiday', duration: '12 May', isPublic: true),
                              const SizedBox(height: 24),
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton(
                                  onPressed: () {},
                                  child: const Text('View Full Calendar'),
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
        ],
      ),
    );
  }
}

class _SubscriptionBanner extends StatelessWidget {
  final ThemeData theme;
  const _SubscriptionBanner({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.colorScheme.primary, theme.colorScheme.primary.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: theme.colorScheme.primary.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.stars_rounded, color: Colors.white, size: 32),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Professional Subscription Plan', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('Your plan will auto-renew on Sep 20, 2026', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13)),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: theme.colorScheme.primary,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Manage Plan', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _ReportCard({required this.title, required this.subtitle, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 11)),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                title,
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({required this.title, required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.1)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 12),
            Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _ManagementStatusItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _ManagementStatusItem({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 32,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }
}

class _LeaveItem extends StatelessWidget {
  final String name;
  final String reason;
  final String duration;
  final bool isPublic;

  const _LeaveItem({
    required this.name,
    required this.reason,
    required this.duration,
    this.isPublic = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: isPublic ? Colors.blue.shade50 : null,
          backgroundImage: isPublic ? null : const NetworkImage('https://i.pravatar.cc/150?u=100'),
          child: isPublic ? const Icon(Icons.event_note, size: 14, color: Colors.blue) : null,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              Text(reason, style: const TextStyle(color: Colors.grey, fontSize: 11)),
            ],
          ),
        ),
        Text(
          duration,
          style: TextStyle(
            color: isPublic ? Colors.blue : Colors.orange,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _AnnouncementSection extends StatefulWidget {
  final bool isOwner;
  const _AnnouncementSection({required this.isOwner});

  @override
  State<_AnnouncementSection> createState() => _AnnouncementSectionState();
}

class _AnnouncementSectionState extends State<_AnnouncementSection> {
  final List<Map<String, String>> _announcements = [
    {'title': 'Eid Holidays', 'content': 'Company will be closed from May 10 to May 13 for Eid celebrations.', 'date': 'Today'},
    {'title': 'New Policy', 'content': 'Remote work policy has been updated. Please check the Document Vault.', 'date': 'Yesterday'},
  ];

  void _showPostAnnouncementDialog() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          width: 450,
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Post Announcement', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const Text('Send a notification to all employees in your company', style: TextStyle(color: Colors.grey, fontSize: 12)),
              const SizedBox(height: 24),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  filled: true,
                  fillColor: Colors.grey.withOpacity(0.05),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: contentController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Message Body',
                  filled: true,
                  fillColor: Colors.grey.withOpacity(0.05),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Discard', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 16),
                  CustomButton(
                    text: 'Publish Now',
                    onPressed: () {
                      if (titleController.text.isNotEmpty) {
                        setState(() {
                          _announcements.insert(0, {
                            'title': titleController.text,
                            'content': contentController.text,
                            'date': 'Just Now',
                          });
                        });
                        Navigator.pop(context);
                        AppToast.showSuccess(context, 'Announcement Published Successfully');
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Company Announcements', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            if (widget.isOwner)
              TextButton.icon(
                onPressed: _showPostAnnouncementDialog,
                icon: const Icon(Icons.add_circle_outline, size: 18),
                label: const Text('Post New', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _announcements.length,
            itemBuilder: (context, index) {
              final item = _announcements[index];
              return Container(
                width: 320,
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: theme.colorScheme.primary.withOpacity(0.1)),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            item['date']!,
                            style: TextStyle(color: theme.colorScheme.primary, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Icon(Icons.campaign_outlined, color: Colors.orange, size: 20),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(item['title']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    const SizedBox(height: 4),
                    Text(
                      item['content']!,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
