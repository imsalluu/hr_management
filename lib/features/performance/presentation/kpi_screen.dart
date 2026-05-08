import 'package:flutter/material.dart';
import 'package:hr_management/shared/widgets/custom_widgets.dart';

class KPIScreen extends StatelessWidget {
  const KPIScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = MediaQuery.of(context).size.width > 900;

    final performanceData = [
      {'name': 'Salman Hossain', 'score': '4.8', 'status': 'Exceptional', 'kpis': 'Code Quality, Leadership'},
      {'name': 'Sarah Smith', 'score': '4.5', 'status': 'Exceeds Expectations', 'kpis': 'Comms, Management'},
      {'name': 'Alex Johnson', 'score': '3.9', 'status': 'Meets Expectations', 'kpis': 'Creativity, Speed'},
      {'name': 'Emma Wilson', 'score': '4.2', 'status': 'Exceeds Expectations', 'kpis': 'Reliability, Teamwork'},
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
                  Text('Performance Tracking (KPI)', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  Text('Monitor and evaluate employee performance metrics', style: TextStyle(color: Colors.grey, fontSize: 13)),
                ],
              ),
              if (isDesktop)
                CustomButton(
                  text: 'New Performance Review',
                  icon: Icons.rate_review_outlined,
                  onPressed: () {},
                ),
            ],
          ),
          const SizedBox(height: 32),

          // Rating Chart Mock
          CustomCard(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Quarterly Performance Index', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 24),
                SizedBox(
                  height: 100,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _Bar(height: 40, label: 'Q1', color: Colors.blue),
                      _Bar(height: 65, label: 'Q2', color: Colors.blue),
                      _Bar(height: 85, label: 'Q3', color: theme.colorScheme.primary),
                      _Bar(height: 60, label: 'Q4', color: Colors.blue.withOpacity(0.5)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // KPI List
          const Text('Team Assessment Ledger', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          CustomCard(
            padding: EdgeInsets.zero,
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: performanceData.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final d = performanceData[index];
                final score = double.parse(d['score']!);
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  leading: CircleAvatar(
                    backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                    child: Text(d['name']![0], style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
                  ),
                  title: Text(d['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Key Strengths: ${d['kpis']}', style: const TextStyle(fontSize: 12)),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(5, (i) => Icon(
                          i < score.floor() ? Icons.star_rounded : Icons.star_outline_rounded,
                          color: Colors.amber,
                          size: 18,
                        )),
                      ),
                      Text(d['status']!, style: TextStyle(color: score >= 4.5 ? Colors.green : Colors.orange, fontSize: 10, fontWeight: FontWeight.bold)),
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

class _Bar extends StatelessWidget {
  final double height;
  final String label;
  final Color color;
  const _Bar({required this.height, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 40,
          height: height,
          decoration: BoxDecoration(color: color, borderRadius: const BorderRadius.vertical(top: Radius.circular(8))),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }
}
