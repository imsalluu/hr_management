import 'package:flutter/material.dart';
import 'package:hr_management/shared/widgets/custom_widgets.dart';

class SystemDashboardScreen extends StatelessWidget {
  const SystemDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Platform Overview',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const Text(
            'Global metrics for PeopleDesk SaaS platform',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 32),

          // Platform Stats
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
                children: [
                  _PlatformStatCard(
                    title: 'Total Revenue',
                    value: '\$45,280',
                    icon: Icons.payments_outlined,
                    color: Colors.green,
                    trend: '+12% this month',
                  ),
                  _PlatformStatCard(
                    title: 'Active Businesses',
                    value: '18',
                    icon: Icons.business_rounded,
                    color: Colors.blue,
                    trend: '+2 new this week',
                  ),
                  _PlatformStatCard(
                    title: 'Total Employees',
                    value: '2,450',
                    icon: Icons.people_outline,
                    color: Colors.orange,
                    trend: 'Across all tenants',
                  ),
                  _PlatformStatCard(
                    title: 'System Uptime',
                    value: '99.9%',
                    icon: Icons.dns_outlined,
                    color: Colors.purple,
                    trend: 'Stable performance',
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 32),

          // Business Growth & Billing Status
          Flex(
            direction: isDesktop ? Axis.horizontal : Axis.vertical,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: isDesktop ? 2 : 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Business Growth',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    CustomCard(

                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.auto_graph_rounded, size: 80, color: theme.colorScheme.primary.withValues(alpha: 0.1)),
                            const SizedBox(height: 16),
                            const Text('Growth Visualization Chart Placeholder', style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (isDesktop) const SizedBox(width: 32) else const SizedBox(height: 32),
              Expanded(
                flex: isDesktop ? 1 : 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Expiring Subscriptions',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    CustomCard(
                      child: Column(
                        children: [
                          _ExpiringItem(name: 'Tech Corp', days: '3 Days', amount: '\$499'),
                          const Divider(),
                          _ExpiringItem(name: 'Stark Industries', days: '5 Days', amount: '\$1,200'),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () {},
                              child: const Text('View All Billing'),
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

class _PlatformStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String trend;

  const _PlatformStatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.trend,
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
          Expanded(
            child: Column(
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
                Text(
                  trend,
                  style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpiringItem extends StatelessWidget {
  final String name;
  final String days;
  final String amount;

  const _ExpiringItem({required this.name, required this.days, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              Text('Expires in $days', style: const TextStyle(color: Colors.red, fontSize: 11)),
            ],
          ),
          Text(amount, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
