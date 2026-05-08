import 'package:flutter/material.dart';
import 'package:hr_management/shared/widgets/custom_widgets.dart';

class SubscriptionPlansScreen extends StatefulWidget {
  const SubscriptionPlansScreen({super.key});

  @override
  State<SubscriptionPlansScreen> createState() => _SubscriptionPlansScreenState();
}

class _SubscriptionPlansScreenState extends State<SubscriptionPlansScreen> {
  final List<Map<String, dynamic>> _plans = [
    {
      'id': '1',
      'name': 'Free Tier',
      'price': '0',
      'users': 'Up to 5',
      'features': ['Basic Attendance', 'Employee Directory', 'Mobile App Access'],
      'color': Colors.grey,
    },
    {
      'id': '2',
      'name': 'Standard',
      'price': '49',
      'users': 'Up to 50',
      'features': ['Multi-shift Support', 'Leave Management', 'Basic Reports', 'Email Support'],
      'color': Colors.blue,
    },
    {
      'id': '3',
      'name': 'Enterprise',
      'price': '199',
      'users': 'Unlimited',
      'features': ['Advanced Analytics', 'Custom Workflows', 'API Access', '24/7 Priority Support', 'Dedicated Manager'],
      'color': Colors.purple,
    },
  ];

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
                    'Subscription Plans',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Define and manage platform pricing models',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              CustomButton(
                text: 'Create New Plan',
                icon: Icons.add_rounded,
                onPressed: () => _showPlanDialog(),
              ),
            ],
          ),
          const SizedBox(height: 32),
          
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth > 1200 ? 3 : (constraints.maxWidth > 700 ? 2 : 1);
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 24,
                  mainAxisSpacing: 24,
                  childAspectRatio: 0.75,
                ),
                itemCount: _plans.length,
                itemBuilder: (context, index) {
                  final plan = _plans[index];
                  return _PlanCard(
                    plan: plan,
                    onEdit: () => _showPlanDialog(plan: plan),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  void _showPlanDialog({Map<String, dynamic>? plan}) {
    final nameController = TextEditingController(text: plan?['name'] ?? '');
    final priceController = TextEditingController(text: plan?['price'] ?? '');
    final usersController = TextEditingController(text: plan?['users'] ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(plan == null ? 'Create New Plan' : 'Edit Plan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Plan Name', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(labelText: 'Monthly Price (\$)', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: usersController,
              decoration: const InputDecoration(labelText: 'User Limit', border: OutlineInputBorder()),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              setState(() {
                if (plan == null) {
                  _plans.add({
                    'id': DateTime.now().toString(),
                    'name': nameController.text,
                    'price': priceController.text,
                    'users': usersController.text,
                    'features': ['Basic Features'],
                    'color': Colors.orange,
                  });
                } else {
                  final index = _plans.indexOf(plan);
                  _plans[index] = {
                    ...plan,
                    'name': nameController.text,
                    'price': priceController.text,
                    'users': usersController.text,
                  };
                }
              });
              Navigator.pop(context);
            },
            child: Text(plan == null ? 'Create' : 'Save Changes'),
          ),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final Map<String, dynamic> plan;
  final VoidCallback onEdit;

  const _PlanCard({required this.plan, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = plan['color'] as Color;

    return CustomCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Column(
              children: [
                Text(
                  plan['name'],
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('\$', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, height: 1.5)),
                    Text(
                      plan['price'],
                      style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                    const Text('/mo', style: TextStyle(fontSize: 14, color: Colors.grey, height: 2.8)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  plan['users'],
                  style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('FEATURES', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2, color: Colors.grey)),
                  const SizedBox(height: 12),
                  ...(plan['features'] as List<String>).map((feature) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle, size: 16, color: Colors.green),
                        const SizedBox(width: 8),
                        Expanded(child: Text(feature, style: const TextStyle(fontSize: 13))),
                      ],
                    ),
                  )),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: OutlinedButton.icon(
              onPressed: onEdit,
              icon: const Icon(Icons.edit_outlined, size: 18),
              label: const Text('Edit Plan'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
