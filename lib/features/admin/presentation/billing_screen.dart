import 'package:flutter/material.dart';
import 'package:hr_management/shared/widgets/custom_widgets.dart';

class BillingScreen extends StatelessWidget {
  const BillingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final invoices = [
      {'id': 'INV-001', 'company': 'Tech Corp', 'date': 'Apr 25, 2024', 'amount': '\$499', 'status': 'Paid'},
      {'id': 'INV-002', 'company': 'Pied Piper', 'date': 'Apr 26, 2024', 'amount': '\$150', 'status': 'Due'},
      {'id': 'INV-003', 'company': 'GNB Bank', 'date': 'Apr 27, 2024', 'amount': '\$2,500', 'status': 'Overdue'},
      {'id': 'INV-004', 'company': 'Hooli', 'date': 'Apr 28, 2024', 'amount': '\$800', 'status': 'Paid'},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Billing & Subscriptions',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const Text(
            'Monitor platform revenue and tenant payments',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 32),

          // Billing Summary
          Row(
            children: [
              _SummaryBox(title: 'Collected this month', value: '\$14,250', color: Colors.green),
              const SizedBox(width: 16),
              _SummaryBox(title: 'Outstanding Dues', value: '\$3,480', color: Colors.orange),
            ],
          ),
          const SizedBox(height: 32),

          const Text(
            'Recent Invoices',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          CustomCard(
            padding: EdgeInsets.zero,
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: invoices.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final inv = invoices[index];
                final status = inv['status'] as String;
                final statusColor = status == 'Paid' ? Colors.green : (status == 'Due' ? Colors.orange : Colors.red);

                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.description_outlined, color: theme.colorScheme.primary, size: 20),
                  ),
                  title: Text(inv['company'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${inv['id']} • ${inv['date']}'),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(inv['amount'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(
                        status,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryBox extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _SummaryBox({required this.title, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CustomCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
      ),
    );
  }
}
