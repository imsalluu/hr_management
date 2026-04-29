import 'package:flutter/material.dart';
import 'package:hr_management/shared/widgets/custom_widgets.dart';
import 'package:hr_management/shared/widgets/main_layout.dart';

class ShiftScreen extends StatelessWidget {
  const ShiftScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = MediaQuery.of(context).size.width > 900;

    final shifts = [
      {'name': 'Morning Shift', 'time': '07:00 AM - 03:00 PM', 'employees': 45},
      {'name': 'General Shift', 'time': '09:00 AM - 06:00 PM', 'employees': 120},
      {'name': 'Evening Shift', 'time': '02:00 PM - 10:00 PM', 'employees': 32},
      {'name': 'Night Shift', 'time': '10:00 PM - 06:00 AM', 'employees': 18},
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
                  Text(
                    'Configured Shifts',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text('Setup daily timing for departments', style: TextStyle(color: Colors.grey, fontSize: 13)),
                ],
              ),
              if (isDesktop)
                CustomButton(
                  text: 'Create New Shift',
                  icon: Icons.add_rounded,
                  onPressed: () {},
                ),
            ],
          ),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth > 900 ? 2 : 1;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 2.8,
                ),
                itemCount: shifts.length,
                itemBuilder: (context, index) {
                  final shift = shifts[index];
                  return CustomCard(
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.schedule, color: theme.colorScheme.primary),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(shift['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              Text(shift['time'] as String, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                            ],
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('${shift['employees']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                            const Text('Staff', style: TextStyle(color: Colors.grey, fontSize: 10)),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
          const SizedBox(height: 40),
          const Text(
            'Assign Shifts',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          CustomCard(
            padding: EdgeInsets.zero,
            child: ListTile(
              leading: const CircleAvatar(backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=99')),
              title: const Text('Salman Hossain', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Current: General Shift'),
              trailing: TextButton(
                onPressed: () {},
                child: const Text('Change Shift'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
