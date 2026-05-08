import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_management/features/auth/presentation/auth_state.dart';
import 'package:hr_management/shared/widgets/custom_widgets.dart';

class HRManagementScreen extends StatefulWidget {
  const HRManagementScreen({super.key});

  @override
  State<HRManagementScreen> createState() => _HRManagementScreenState();
}

class _HRManagementScreenState extends State<HRManagementScreen> {
  final List<Map<String, String>> hrs = [
    {
      'id': '2',
      'name': 'Sarah HR',
      'role': 'Senior HR Manager',
      'dept': 'HR Department',
      'teamSize': '12',
      'status': 'Active',
      'image': 'https://i.pravatar.cc/150?u=2'
    },
    {
      'id': '10',
      'name': 'Michael Chen',
      'role': 'HR Operations',
      'dept': 'Recruitment',
      'teamSize': '08',
      'status': 'Active',
      'image': 'https://i.pravatar.cc/150?u=10'
    },
  ];

  void _showAppointHRDialog() {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final deptController = TextEditingController();
    final roleController = TextEditingController();
    final passController = TextEditingController();

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
              const Text('Appoint New HR', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const Text('Create credentials for your new HR personnel', style: TextStyle(color: Colors.grey, fontSize: 13)),
              const SizedBox(height: 32),
              _PrettyField(controller: nameController, label: 'Full Name', icon: Icons.person_outline),
              const SizedBox(height: 16),
              _PrettyField(controller: emailController, label: 'Email Address', icon: Icons.email_outlined),
              const SizedBox(height: 16),
              _PrettyField(controller: deptController, label: 'Department', icon: Icons.business_outlined),
              const SizedBox(height: 16),
              _PrettyField(controller: roleController, label: 'Position/Role', icon: Icons.work_outline),
              const SizedBox(height: 16),
              _PrettyField(controller: passController, label: 'Initial Password', icon: Icons.lock_outline, isPassword: true),
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
                    text: 'Save HR Profile',
                    onPressed: () {
                      if (nameController.text.isNotEmpty) {
                        setState(() {
                          hrs.add({
                            'id': DateTime.now().millisecondsSinceEpoch.toString(),
                            'name': nameController.text,
                            'role': roleController.text.isEmpty ? 'HR Executive' : roleController.text,
                            'dept': deptController.text.isEmpty ? 'HR' : deptController.text,
                            'teamSize': '0',
                            'status': 'Active',
                            'image': 'https://i.pravatar.cc/150?u=${hrs.length + 20}',
                          });
                        });
                        Navigator.pop(context);
                        AppToast.showSuccess(context, 'HR Appointed Successfully');
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
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('HR Management', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    Text('Oversee your HR department and team distribution', style: TextStyle(color: Colors.grey, fontSize: 13)),
                  ],
                ),
              ),
              if (isDesktop)
                CustomButton(
                  text: 'Appoint HR',
                  icon: Icons.add_moderator_rounded,
                  onPressed: _showAppointHRDialog,
                ),
            ],
          ),
          const SizedBox(height: 32),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isDesktop ? 3 : 1,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              mainAxisExtent: 220,
            ),
            itemCount: hrs.length,
            itemBuilder: (context, index) {
              final hr = hrs[index];
              return _HRCard(hr: hr);
            },
          ),
          if (!isDesktop) ...[
            const SizedBox(height: 32),
            CustomButton(
              text: 'Appoint HR',
              icon: Icons.add_moderator_rounded,
              fullWidth: true,
              onPressed: _showAppointHRDialog,
            ),
          ],
        ],
      ),
    );
  }
}

class _HRCard extends StatelessWidget {
  final Map<String, String> hr;
  const _HRCard({required this.hr});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(hr['image']!),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(hr['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(hr['role']!, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                      child: Text(hr['dept']!, style: const TextStyle(color: Colors.blue, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('TEAM SIZE', style: TextStyle(fontSize: 10, color: Colors.grey, letterSpacing: 1)),
                  Text('${hr['teamSize']} Members', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                ],
              ),
              TextButton(
                onPressed: () => context.go('/hr-details/${hr['id']}'),
                child: const Text('View Team'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PrettyField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool isPassword;

  const _PrettyField({
    required this.controller,
    required this.label,
    required this.icon,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
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
