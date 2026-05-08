import 'package:flutter/material.dart';
import 'package:hr_management/features/auth/presentation/auth_state.dart';
import 'package:hr_management/shared/widgets/custom_widgets.dart';

class HRProfileScreen extends StatefulWidget {
  final String hrId;
  const HRProfileScreen({super.key, required this.hrId});

  @override
  State<HRProfileScreen> createState() => _HRProfileScreenState();
}

class _HRProfileScreenState extends State<HRProfileScreen> {
  // Mock Team Data managed in state
  final List<Map<String, String>> team = [
    {'name': 'Hossain Employee', 'role': 'Flutter Developer', 'dept': 'IT', 'status': 'Active'},
    {'name': 'Jane Doe', 'role': 'Graphics Designer', 'dept': 'Design', 'status': 'Active'},
    {'name': 'Robert Fox', 'role': 'Backend Dev', 'dept': 'IT', 'status': 'Away'},
  ];

  void _showAssignMemberDialog() {
    final availableEmployees = [
      {'name': 'Alex Johnson', 'role': 'UI Designer', 'dept': 'IT'},
      {'name': 'Emma Wilson', 'role': 'Supervisor', 'dept': 'Marketing'},
      {'name': 'John Doe', 'role': 'Manager', 'dept': 'Operations'},
      {'name': 'Guy Hawkins', 'role': 'Marketing Coord.', 'dept': 'Marketing'},
    ];

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Assign Member to Team', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const Text('Select an employee to assign to this HR', style: TextStyle(color: Colors.grey, fontSize: 13)),
              const SizedBox(height: 24),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search employees...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey.withOpacity(0.05),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 16),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: availableEmployees.length,
                  itemBuilder: (context, index) {
                    final emp = availableEmployees[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=${index + 10}')),
                      title: Text(emp['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      subtitle: Text(emp['role']!, style: const TextStyle(fontSize: 12)),
                      trailing: IconButton(
                        icon: const Icon(Icons.add_circle_outline, color: Colors.blue),
                        onPressed: () {
                          setState(() {
                            team.add({
                              ...emp,
                              'status': 'Active',
                            });
                          });
                          Navigator.pop(context);
                          AppToast.showSuccess(context, '${emp['name']} assigned to team');
                        },
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: 'Close',
                fullWidth: true,
                onPressed: () => Navigator.pop(context),
                backgroundColor: Colors.grey.shade200,
                textColor: Colors.black,
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
    
    // Mock HR Data
    final hr = UserModel.mock(UserRole.hr);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _HRHeader(hr: hr, isDesktop: isDesktop),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Managed Team (${team.length})', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              CustomButton(
                text: 'Assign Member',
                icon: Icons.person_add_outlined,
                onPressed: _showAssignMemberDialog,
              ),
            ],
          ),
          const SizedBox(height: 16),
          CustomCard(
            padding: EdgeInsets.zero,
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: team.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final member = team[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=${index + 50}'),
                  ),
                  title: Text(member['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${member['role']} • ${member['dept']}'),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: member['status'] == 'Active' ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      member['status']!,
                      style: TextStyle(
                        color: member['status'] == 'Active' ? Colors.green : Colors.orange,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
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

class _HRHeader extends StatelessWidget {
  final UserModel hr;
  final bool isDesktop;
  const _HRHeader({required this.hr, required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=2'),
          ),
          const SizedBox(width: 32),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(hr.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                Text(hr.position ?? 'Senior HR Manager', style: const TextStyle(color: Colors.grey, fontSize: 16)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.email_outlined, size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(hr.email, style: const TextStyle(color: Colors.grey)),
                    const SizedBox(width: 24),
                    const Icon(Icons.business_outlined, size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(hr.department ?? 'HR Department', style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ),
          if (isDesktop)
            Column(
              children: [
                const Text('TEAM PERFORMANCE', style: TextStyle(fontSize: 10, color: Colors.grey, letterSpacing: 1)),
                const SizedBox(height: 8),
                Text('94%', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.green.shade700)),
              ],
            ),
        ],
      ),
    );
  }
}
