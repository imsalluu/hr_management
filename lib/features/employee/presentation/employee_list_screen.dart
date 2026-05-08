import 'package:flutter/material.dart';
import 'package:hr_management/shared/widgets/custom_widgets.dart';
import 'package:hr_management/shared/widgets/main_layout.dart';

class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({super.key});

  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  final List<Map<String, String>> employees = [
    {'name': 'Salman Hossain', 'role': 'Lead Developer', 'dept': 'IT', 'status': 'Active'},
    {'name': 'Sarah Smith', 'role': 'HR Executive', 'dept': 'HR', 'status': 'Active'},
    {'name': 'John Doe', 'role': 'Manager', 'dept': 'Operations', 'status': 'Away'},
    {'name': 'Alex Johnson', 'role': 'UI Designer', 'dept': 'IT', 'status': 'Active'},
    {'name': 'Emma Wilson', 'role': 'Supervisor', 'dept': 'Marketing', 'status': 'Active'},
  ];

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      if (!mounted) return;
      controller.text = "${picked.day} ${_getMonthName(picked.month)} ${picked.year}";
    }
  }

  String _getMonthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }

  void _showAddEmployeeDialog() {
    final nameController = TextEditingController();
    final roleController = TextEditingController();
    final deptController = TextEditingController();
    final joinDateController = TextEditingController();
    final passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          width: 500,
          padding: const EdgeInsets.all(32),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Onboard New Employee', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const Text('Create a new account for your staff member', style: TextStyle(color: Colors.grey, fontSize: 13)),
                const SizedBox(height: 24),
                _EmployeeInputField(controller: nameController, label: 'Full Name', icon: Icons.person_outline),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _EmployeeInputField(controller: roleController, label: 'Role/Designation', icon: Icons.work_outline)),
                    const SizedBox(width: 16),
                    Expanded(child: _EmployeeInputField(controller: deptController, label: 'Department', icon: Icons.corporate_fare_outlined)),
                  ],
                ),
                const SizedBox(height: 16),
                _EmployeeInputField(
                  controller: joinDateController, 
                  label: 'Join Date', 
                  icon: Icons.calendar_today_outlined,
                  readOnly: true,
                  onTap: () => _selectDate(context, joinDateController),
                ),
                const SizedBox(height: 16),
                _EmployeeInputField(controller: passwordController, label: 'Initial Password', icon: Icons.lock_outline, obscure: true),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 16),
                    CustomButton(
                      text: 'Create Account',
                      onPressed: () {
                        if (nameController.text.isNotEmpty && roleController.text.isNotEmpty) {
                          setState(() {
                            employees.insert(0, {
                              'name': nameController.text,
                              'role': roleController.text,
                              'dept': deptController.text,
                              'status': 'Active',
                            });
                          });
                          Navigator.pop(context);
                          AppToast.showSuccess(context, '${nameController.text} added to team successfully');
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = MediaQuery.of(context).size.width > 900;

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
                  onPressed: _showAddEmployeeDialog,
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
                     onPressed: _showAddEmployeeDialog,
                     icon: const Icon(Icons.add_circle, color: Color(0xFFFFC107), size: 30),
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
                    backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                    child: Text(employee['name']![0], style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
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

class _EmployeeInputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool readOnly;
  final VoidCallback? onTap;
  final bool obscure;

  const _EmployeeInputField({
    required this.controller,
    required this.label,
    required this.icon,
    this.readOnly = false,
    this.onTap,
    this.obscure = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20, color: Colors.grey),
        filled: true,
        fillColor: Colors.grey.withOpacity(0.05),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
