import 'package:flutter/material.dart';
import 'package:hr_management/shared/widgets/custom_widgets.dart';

class PayrollScreen extends StatelessWidget {
  const PayrollScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = MediaQuery.of(context).size.width > 900;

    final payrolls = [
      {'name': 'Salman Hossain', 'salary': '85,000', 'bonus': '12,000', 'tax': '4,250', 'status': 'Paid'},
      {'name': 'Sarah Smith', 'salary': '62,000', 'bonus': '5,000', 'tax': '3,100', 'status': 'Pending'},
      {'name': 'Alex Johnson', 'salary': '45,000', 'bonus': '0', 'tax': '2,250', 'status': 'Paid'},
      {'name': 'Emma Wilson', 'salary': '55,000', 'bonus': '8,000', 'tax': '2,750', 'status': 'Paid'},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Payroll Management', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  Text('Manage salaries, bonuses, and tax deductions', style: TextStyle(color: Colors.grey, fontSize: 13)),
                ],
              ),
              if (isDesktop)
                CustomButton(
                  text: 'Process Monthly Payroll',
                  icon: Icons.payments_outlined,
                  onPressed: () {},
                ),
            ],
          ),
          const SizedBox(height: 32),

          // Overview Stats
          Row(
            children: [
              _OverviewStat(label: 'Total Disbursement', value: '৳ 2,49,000', icon: Icons.account_balance_wallet_outlined, color: Colors.blue),
              const SizedBox(width: 20),
              _OverviewStat(label: 'Total Tax', value: '৳ 12,350', icon: Icons.receipt_long_outlined, color: Colors.orange),
              const SizedBox(width: 20),
              _OverviewStat(label: 'Pending Payments', value: '01', icon: Icons.pending_actions_outlined, color: Colors.red),
            ],
          ),
          const SizedBox(height: 32),

          // Payroll List
          const Text('Employee Salary Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          CustomCard(
            padding: EdgeInsets.zero,
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: payrolls.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final p = payrolls[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  leading: CircleAvatar(
                    backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                    child: Text(p['name']![0], style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
                  ),
                  title: Text(p['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Base: ৳${p['salary']} • Bonus: ৳${p['bonus']}', style: const TextStyle(fontSize: 12)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('৳${(int.parse(p['salary']!.replaceAll(',', '')) + int.parse(p['bonus']!.replaceAll(',', '')) - int.parse(p['tax']!.replaceAll(',', '')))}', 
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          const Text('Net Payable', style: TextStyle(color: Colors.grey, fontSize: 10)),
                        ],
                      ),
                      const SizedBox(width: 24),
                      IconButton(
                        onPressed: () {
                          AppToast.showInfo(context, 'Downloading PDF Payslip...');
                        },
                        icon: const Icon(Icons.picture_as_pdf_outlined, color: Colors.redAccent),
                        tooltip: 'Download Payslip',
                      ),
                      const SizedBox(width: 8),
                      if (p['status'] == 'Pending')
                        ElevatedButton(
                          onPressed: () => AppToast.showSuccess(context, 'Payment Processed for ${p['name']}'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          child: const Text('Pay Now'),
                        )
                      else
                        const Icon(Icons.check_circle_rounded, color: Colors.green, size: 28),
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

class _OverviewStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _OverviewStat({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CustomCard(
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
