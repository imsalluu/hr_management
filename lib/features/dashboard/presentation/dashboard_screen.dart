import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    final isManagement = user?.role == UserRole.businessOwner || user?.role == UserRole.hr;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                          title: 'Attendance Rate',
                          value: '94%',
                          icon: Icons.fingerprint_rounded,
                          color: Colors.green.shade400,
                        ),
                        _StatCard(
                          title: 'Pending Leaves',
                          value: '12',
                          icon: Icons.beach_access_outlined,
                          color: Colors.orange.shade400,
                        ),
                        _StatCard(
                          title: 'On-boarding',
                          value: '05',
                          icon: Icons.person_add_outlined,
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

          // Content Area (Two Columns on Desktop)
          Flex(
            direction: isDesktop ? Axis.horizontal : Axis.vertical,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Column: Recent Activities / Attendance Log
              Expanded(
                flex: isDesktop ? 2 : 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isManagement ? 'Recent Attendance Log' : 'My Attendance History',
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
                              backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=${isManagement ? index : 99}'),
                            ),
                            title: Text(isManagement ? (index == 0 ? 'Salman Hossain' : 'Sarah Smith') : user?.name ?? 'User', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            subtitle: Text('Checked in at 09:00 AM • ${isManagement ? 'Feni, Bangladesh' : 'Remote'}', style: const TextStyle(fontSize: 12)),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'On Time',
                                style: TextStyle(
                                  color: theme.colorScheme.primary,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              if (isDesktop) const SizedBox(width: 32) else const SizedBox(height: 32),
              
              // Right Column: Upcoming Leaves / Birthdays
              Expanded(
                flex: isDesktop ? 1 : 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isManagement ? 'Employee On Leave' : 'Upcoming Holidays',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    CustomCard(
                      child: Column(
                        children: isManagement 
                          ? [
                              _LeaveItem(name: 'Sarah Smith', reason: 'Sick Leave', duration: '2 Days'),
                              const SizedBox(height: 12),
                              _LeaveItem(name: 'John Doe', reason: 'Casual Leave', duration: 'Today'),
                              const SizedBox(height: 24),
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton(
                                  onPressed: () {},
                                  child: const Text('View All Leaves'),
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
              color: color.withValues(alpha: 0.1),
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
