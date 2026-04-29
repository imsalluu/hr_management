import 'package:flutter/material.dart';
import 'package:hr_management/shared/widgets/custom_widgets.dart';

class ApprovalsScreen extends StatefulWidget {
  const ApprovalsScreen({super.key});

  @override
  State<ApprovalsScreen> createState() => _ApprovalsScreenState();
}

class _ApprovalsScreenState extends State<ApprovalsScreen> {
  final List<Map<String, dynamic>> _requests = [
    {
      'id': '1',
      'name': 'Salman Hossain',
      'type': 'Leave Request',
      'details': 'Sick Leave • 2 Days (May 10-11)',
      'status': 'Pending',
      'avatar': 'https://i.pravatar.cc/150?u=99'
    },
    {
      'id': '2',
      'name': 'Sarah Smith',
      'type': 'Attendance Correction',
      'details': 'Forgot to clock out on April 28',
      'status': 'Pending',
      'avatar': 'https://i.pravatar.cc/150?u=1'
    },
    {
      'id': '3',
      'name': 'John Doe',
      'type': 'Leave Request',
      'details': 'Casual Leave • Today',
      'status': 'Pending',
      'avatar': 'https://i.pravatar.cc/150?u=3'
    },
  ];

  void _handleAction(String id, String newStatus) {
    setState(() {
      final index = _requests.indexWhere((r) => r['id'] == id);
      if (index != -1) {
        _requests[index]['status'] = newStatus;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Request $newStatus')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pendingRequests = _requests.where((r) => r['status'] == 'Pending').toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pending Approvals',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const Text(
            'Review and manage employee requests',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          if (pendingRequests.isEmpty)
            Center(
              child: Column(
                children: [
                   const SizedBox(height: 60),
                   Icon(Icons.done_all_rounded, size: 64, color: Colors.green.withValues(alpha: 0.2)),
                   const SizedBox(height: 16),
                   const Text('All caught up!', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                ],
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: pendingRequests.length,
              itemBuilder: (context, index) {
                final request = pendingRequests[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: CustomCard(
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundImage: NetworkImage(request['avatar']),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                request['name'],
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Text(
                                request['type'],
                                style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                              Text(
                                request['details'],
                                style: const TextStyle(color: Colors.black54, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Row(
                          children: [
                            IconButton.filled(
                              onPressed: () => _handleAction(request['id'], 'Rejected'),
                              icon: const Icon(Icons.close),
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.red.shade50,
                                foregroundColor: Colors.red,
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton.filled(
                              onPressed: () => _handleAction(request['id'], 'Approved'),
                              icon: const Icon(Icons.check),
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.green.shade50,
                                foregroundColor: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
