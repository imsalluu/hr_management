import 'package:flutter/material.dart';
import 'package:hr_management/shared/widgets/custom_widgets.dart';
import 'package:hr_management/shared/widgets/main_layout.dart';

class ShiftScreen extends StatefulWidget {
  const ShiftScreen({super.key});

  @override
  State<ShiftScreen> createState() => _ShiftScreenState();
}

class _ShiftScreenState extends State<ShiftScreen> {
  final List<Map<String, dynamic>> shifts = [
    {'name': 'Morning Shift', 'time': '07:00 AM - 03:00 PM', 'employees': 45},
    {'name': 'General Shift', 'time': '09:00 AM - 06:00 PM', 'employees': 120},
    {'name': 'Evening Shift', 'time': '02:00 PM - 10:00 PM', 'employees': 32},
    {'name': 'Night Shift', 'time': '10:00 PM - 06:00 AM', 'employees': 18},
  ];

  Future<void> _selectTime(BuildContext context, TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      if (!mounted) return;
      controller.text = picked.format(context);
    }
  }

  void _showCreateShiftDialog() {
    final nameController = TextEditingController();
    final startController = TextEditingController();
    final endController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: Container(
          width: 450,
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Create New Shift', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const Text('Define workspace timing for your staff members', style: TextStyle(color: Colors.grey, fontSize: 13)),
              const SizedBox(height: 32),
              _PrettyShiftField(
                controller: nameController, 
                label: 'Shift Name', 
                hint: 'e.g. Morning Shift', 
                icon: Icons.badge_outlined,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _PrettyShiftField(
                      controller: startController, 
                      label: 'Start Time', 
                      hint: 'Pick Time', 
                      icon: Icons.login_rounded,
                      readOnly: true,
                      onTap: () => _selectTime(context, startController),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _PrettyShiftField(
                      controller: endController, 
                      label: 'End Time', 
                      hint: 'Pick Time', 
                      icon: Icons.logout_rounded,
                      readOnly: true,
                      onTap: () => _selectTime(context, endController),
                    ),
                  ),
                ],
              ),
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
                    text: 'Create Shift',
                    onPressed: () {
                      if (nameController.text.isNotEmpty && startController.text.isNotEmpty && endController.text.isNotEmpty) {
                        setState(() {
                          shifts.insert(0, {
                            'name': nameController.text,
                            'time': '${startController.text} - ${endController.text}',
                            'employees': 0,
                          });
                        });
                        Navigator.pop(context);
                        AppToast.showSuccess(context, 'Shift Created Successfully');
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
    final isDesktop = MediaQuery.of(context).size.width > 900;

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
                  onPressed: _showCreateShiftDialog,
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
                            color: theme.colorScheme.primary.withOpacity(0.1),
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
          if (!isDesktop) ...[
            const SizedBox(height: 24),
            CustomButton(
              text: 'Create New Shift',
              icon: Icons.add_rounded,
              fullWidth: true,
              onPressed: _showCreateShiftDialog,
            ),
          ],
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

class _PrettyShiftField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final bool readOnly;
  final VoidCallback? onTap;

  const _PrettyShiftField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, size: 20, color: Colors.grey),
        filled: true,
        fillColor: Colors.grey.withOpacity(0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}
