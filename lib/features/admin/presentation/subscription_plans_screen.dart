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
      'colors': [Colors.grey.shade400, Colors.grey.shade600],
      'popular': false,
    },
    {
      'id': '2',
      'name': 'Standard',
      'price': '49',
      'users': 'Up to 50',
      'features': ['Multi-shift Support', 'Leave Management', 'Basic Reports', 'Email Support'],
      'colors': [Colors.blue.shade400, Colors.blue.shade700],
      'popular': true,
    },
    {
      'id': '3',
      'name': 'Enterprise',
      'price': '199',
      'users': 'Unlimited',
      'features': ['Advanced Analytics', 'Custom Workflows', 'API Access', '24/7 Priority Support', 'Dedicated Manager'],
      'colors': [Colors.purple.shade400, Colors.purple.shade700],
      'popular': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Colors.black87, Colors.black54],
                    ).createShader(bounds),
                    child: const Text(
                      'Platform Subscription Plans',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text('Configure pricing and features for your SaaS tenants', style: TextStyle(color: Colors.grey, fontSize: 14)),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () => _showPlanDialog(),
                icon: const Icon(Icons.add, size: 20),
                label: const Text('New Plan'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 48),
          
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth > 1200 ? 3 : (constraints.maxWidth > 800 ? 2 : 1);
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 32,
                  mainAxisSpacing: 32,
                  childAspectRatio: isDesktop(context) ? 0.72 : 0.85,
                ),
                itemCount: _plans.length,
                itemBuilder: (context, index) {
                  return _PlanCard(
                    plan: _plans[index],
                    onEdit: () => _showPlanDialog(plan: _plans[index]),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  bool isDesktop(BuildContext context) => MediaQuery.of(context).size.width > 900;

  void _showPlanDialog({Map<String, dynamic>? plan}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _PlanEditDialog(
        plan: plan,
        onSave: (updatedPlan) {
          setState(() {
            if (plan == null) {
              _plans.add({
                ...updatedPlan,
                'id': DateTime.now().toString(),
                'colors': [Colors.orange.shade400, Colors.orange.shade700],
                'popular': false,
              });
            } else {
              final index = _plans.indexOf(plan);
              _plans[index] = {...plan, ...updatedPlan};
            }
          });
        },
      ),
    );
  }
}

class _PlanEditDialog extends StatefulWidget {
  final Map<String, dynamic>? plan;
  final Function(Map<String, dynamic>) onSave;

  const _PlanEditDialog({this.plan, required this.onSave});

  @override
  State<_PlanEditDialog> createState() => _PlanEditDialogState();
}

class _PlanEditDialogState extends State<_PlanEditDialog> {
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _usersController;
  late List<String> _features;
  final _featureController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.plan?['name'] ?? '');
    _priceController = TextEditingController(text: widget.plan?['price'] ?? '');
    _usersController = TextEditingController(text: widget.plan?['users'] ?? '');
    _features = List<String>.from(widget.plan?['features'] ?? []);
  }

  void _addFeature() {
    if (_featureController.text.isNotEmpty) {
      setState(() {
        _features.add(_featureController.text);
        _featureController.clear();
      });
    }
  }

  void _removeFeature(int index) {
    setState(() => _features.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: 550,
        height: 750,
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.plan == null ? 'Create Subscription Plan' : 'Edit Subscription Plan', 
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _Label('Plan Identification'),
                    TextField(
                      controller: _nameController,
                      decoration: _inputDecoration('Plan Name', Icons.label_outline),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const _Label('Price (Monthly)'),
                              TextField(
                                controller: _priceController,
                                decoration: _inputDecoration('\$', Icons.payments_outlined),
                                keyboardType: TextInputType.number,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const _Label('User Limit'),
                              TextField(
                                controller: _usersController,
                                decoration: _inputDecoration('e.g. Up to 50', Icons.people_outline),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    const _Label('Feature Management'),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _featureController,
                                  decoration: const InputDecoration(
                                    hintText: 'New feature...',
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(fontSize: 14),
                                  ),
                                  onSubmitted: (_) => _addFeature(),
                                ),
                              ),
                              IconButton(
                                onPressed: _addFeature,
                                icon: const Icon(Icons.add_circle, color: Colors.blue),
                              ),
                            ],
                          ),
                          const Divider(),
                          const SizedBox(height: 8),
                          if (_features.isEmpty)
                            const Center(child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text('No features added yet', style: TextStyle(color: Colors.grey, fontSize: 12)),
                            ))
                          else
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _features.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.check_circle, size: 16, color: Colors.green),
                                      const SizedBox(width: 12),
                                      Expanded(child: Text(_features[index], style: const TextStyle(fontSize: 13))),
                                      IconButton(
                                        onPressed: () => _removeFeature(index),
                                        icon: const Icon(Icons.delete_outline, size: 18, color: Colors.red),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    widget.onSave({
                      'name': _nameController.text,
                      'price': _priceController.text,
                      'users': _usersController.text,
                      'features': _features,
                    });
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Save Plan'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, size: 20),
      filled: true,
      fillColor: Colors.grey.shade50,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      contentPadding: const EdgeInsets.symmetric(vertical: 16),
    );
  }
}

class _Label extends StatelessWidget {
  final String label;
  const _Label(this.label);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87)),
  );
}

class _PlanCard extends StatelessWidget {
  final Map<String, dynamic> plan;
  final VoidCallback onEdit;

  const _PlanCard({required this.plan, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    final colors = plan['colors'] as List<Color>;
    final isPopular = plan['popular'] as bool;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: colors[0].withValues(alpha: 0.1), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: colors, begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Column(
                  children: [
                    Text(plan['name'], style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('\$', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white70, height: 1.5)),
                        Text(plan['price'], style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white)),
                        const Text('/mo', style: TextStyle(fontSize: 14, color: Colors.white70, height: 3.2)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(plan['users'], style: const TextStyle(color: Colors.white70, fontSize: 13)),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('KEY FEATURES', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2, color: Colors.grey)),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ListView.builder(
                          itemCount: (plan['features'] as List).length,
                          itemBuilder: (context, i) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                children: [
                                  Icon(Icons.check_circle_rounded, size: 18, color: colors[0]),
                                  const SizedBox(width: 12),
                                  Expanded(child: Text(plan['features'][i], style: const TextStyle(fontSize: 13, color: Colors.black87))),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: onEdit,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        border: Border.all(color: colors[0].withValues(alpha: 0.3)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.edit_note_rounded, size: 20, color: colors[0]),
                            const SizedBox(width: 8),
                            Text('Configure Plan', style: TextStyle(fontWeight: FontWeight.bold, color: colors[0])),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (isPopular)
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(20)),
                child: const Text('MOST POPULAR', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ),
        ],
      ),
    );
  }
}
