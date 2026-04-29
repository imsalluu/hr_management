import 'package:flutter/material.dart';
import 'package:hr_management/shared/widgets/custom_widgets.dart';
import 'package:hr_management/shared/widgets/main_layout.dart';

class EmployeeListScreen extends StatelessWidget {
  const EmployeeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = MediaQuery.of(context).size.width > 900;

    final employees = [
      {'name': 'Salman Hossain', 'role': 'Lead Developer', 'dept': 'IT', 'status': 'Active'},
      {'name': 'Sarah Smith', 'role': 'HR Executive', 'dept': 'HR', 'status': 'Active'},
      {'name': 'John Doe', 'role': 'Manager', 'dept': 'Operations', 'status': 'Away'},
      {'name': 'Alex Johnson', 'role': 'UI Designer', 'dept': 'IT', 'status': 'Active'},
      {'name': 'Emma Wilson', 'role': 'Supervisor', 'dept': 'Marketing', 'status': 'Active'},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Actions
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Employees', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    Text('Manage your team and their roles', style: TextStyle(color: Colors.grey, fontSize: 13)),
                  ],
                ),
              ),
              IconButton(onPressed: () {}, icon: const Icon(Icons.search_rounded)),
              if (isDesktop) ...[
                const SizedBox(width: 8),
                CustomButton(
                  text: 'Add Employee',
                  icon: Icons.add_rounded,
                  onPressed: () {},
                ),
              ],
            ],
          ),
          const SizedBox(height: 24),

          // Filter Bar
          CustomCard(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                const Icon(Icons.filter_list_rounded, color: Colors.grey),
                const SizedBox(width: 12),
                const Text('Filters:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(width: 16),
                const _FilterChip(label: 'All Roles'),
                const _FilterChip(label: 'IT Department'),
                const _FilterChip(label: 'Active Only'),
                const Spacer(),
                if (!isDesktop)
                   IconButton(
                     onPressed: () {},
                     icon: const Icon(Icons.add_circle, color: Color(0xFFFFC107)),
                   ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Employee List
          CustomCard(
            padding: EdgeInsets.zero,
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: employees.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final employee = employees[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  leading: CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=$index'),
                  ),
                  title: Text(employee['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  subtitle: Text('${employee['role']} • ${employee['dept']}', style: const TextStyle(fontSize: 12)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _StatusIndicator(status: employee['status']!),
                      if (isDesktop) ...[
                        const SizedBox(width: 24),
                        IconButton(onPressed: () {}, icon: const Icon(Icons.edit_outlined, size: 20)),
                        IconButton(onPressed: () {}, icon: const Icon(Icons.delete_outline, size: 20, color: Colors.red)),
                      ] else ...[
                        IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert_rounded)),
                      ],
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

class _FilterChip extends StatelessWidget {
  final String label;
  const _FilterChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label, style: const TextStyle(fontSize: 12)),
        selected: false,
        onSelected: (v) {},
      ),
    );
  }
}

class _StatusIndicator extends StatelessWidget {
  final String status;
  const _StatusIndicator({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = status == 'Active' ? Colors.green : Colors.orange;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(status, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
