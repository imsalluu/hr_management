import 'package:flutter/material.dart';
import 'package:hr_management/shared/widgets/custom_widgets.dart';

class TenantManagementScreen extends StatelessWidget {
  const TenantManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    final tenants = [
      {'name': 'Tech Corp', 'domain': 'techcorp.peopledesk.com', 'employees': 124, 'status': 'Active'},
      {'name': 'Goliath National Bank', 'domain': 'gnb.peopledesk.com', 'employees': 1540, 'status': 'Active'},
      {'name': 'Stark Industries', 'domain': 'stark.peopledesk.com', 'employees': 850, 'status': 'Inactive'},
      {'name': 'Pied Piper', 'domain': 'pp.peopledesk.com', 'employees': 12, 'status': 'Active'},
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
                    'Business Management',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Manage multi-tenant companies on the system',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              CustomButton(
                text: 'Register New Business',
                icon: Icons.add_business_rounded,
                onPressed: () {
                   _showCreateTenantDialog(context);
                },
              ),
            ],
          ),
          const SizedBox(height: 32),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: tenants.length,
            itemBuilder: (context, index) {
              final tenant = tenants[index];
              final isActive = tenant['status'] == 'Active';
              final name = tenant['name'] as String;

              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: CustomCard(
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            name[0].toUpperCase(),
                            style: TextStyle(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            Text(tenant['domain'] as String, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.people_outline, size: 14, color: Colors.grey.shade600),
                              const SizedBox(width: 4),
                              Text('${tenant['employees']} Staff', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: isActive ? Colors.green.shade50 : Colors.red.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              (tenant['status'] as String).toUpperCase(),
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: isActive ? Colors.green : Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.more_vert, color: Colors.grey),
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

  void _showCreateTenantDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const _CreateTenantDialog(),
    );
  }
}

class _CreateTenantDialog extends StatefulWidget {
  const _CreateTenantDialog();

  @override
  State<_CreateTenantDialog> createState() => _CreateTenantDialogState();
}

class _CreateTenantDialogState extends State<_CreateTenantDialog> {
  int _currentStep = 0;
  final _pageController = PageController();

  // Step 1: Business Details
  final _nameController = TextEditingController();
  final _domainController = TextEditingController();
  final _addressController = TextEditingController();
  String _scale = '11-50';

  // Step 2: Plan
  String _selectedPlan = 'Standard';

  // Step 3: Admin Account
  final _adminNameController = TextEditingController();
  final _adminEmailController = TextEditingController();
  final _adminPasswordController = TextEditingController();

  void _nextStep() {
    if (_currentStep < 2) {
      setState(() => _currentStep++);
      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      // Final Submit
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Business registered successfully!'), backgroundColor: Colors.green),
      );
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: 600,
        height: 700,
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Register New Business', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('Step ${_currentStep + 1} of 3', style: const TextStyle(color: Colors.grey)),
                  ],
                ),
                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
              ],
            ),
            const SizedBox(height: 24),
            
            // Step Progress
            Row(
              children: [
                _buildStepIndicator(0, 'Info'),
                _buildStepConnector(0),
                _buildStepIndicator(1, 'Plan'),
                _buildStepConnector(1),
                _buildStepIndicator(2, 'Admin'),
              ],
            ),
            const SizedBox(height: 32),

            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildBusinessStep(),
                  _buildPlanStep(),
                  _buildAdminStep(),
                ],
              ),
            ),

            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentStep > 0)
                  OutlinedButton(
                    onPressed: _prevStep,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Back'),
                  )
                else
                  const SizedBox.shrink(),
                
                ElevatedButton(
                  onPressed: _nextStep,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(_currentStep == 2 ? 'Complete Registration' : 'Continue'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicator(int step, String label) {
    final active = _currentStep >= step;
    final theme = Theme.of(context);

    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: active ? theme.colorScheme.primary : Colors.grey[200],
            shape: BoxShape.circle,
          ),
          child: Center(
            child: active && _currentStep > step
                ? const Icon(Icons.check, color: Colors.white, size: 16)
                : Text('${step + 1}', style: TextStyle(color: active ? Colors.white : Colors.grey, fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 10, color: active ? theme.colorScheme.primary : Colors.grey, fontWeight: active ? FontWeight.bold : FontWeight.normal)),
      ],
    );
  }

  Widget _buildStepConnector(int afterStep) {
    final active = _currentStep > afterStep;
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 16),
        color: active ? Theme.of(context).colorScheme.primary : Colors.grey[200],
      ),
    );
  }

  Widget _buildBusinessStep() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _FormLabel('Business Name'),
          _FormTextField(controller: _nameController, hint: 'e.g. Acme Corporation'),
          const SizedBox(height: 16),
          const _FormLabel('Custom Subdomain'),
          _FormTextField(controller: _domainController, hint: 'company.peopledesk.com'),
          const SizedBox(height: 16),
          const _FormLabel('Business Address'),
          _FormTextField(controller: _addressController, hint: 'Full physical address', maxLines: 2),
          const SizedBox(height: 16),
          const _FormLabel('Employee Scale'),
          DropdownButtonFormField<String>(
            value: _scale,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[50],
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
            items: ['1-10', '11-50', '51-200', '201-500', '500+'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
            onChanged: (v) => setState(() => _scale = v!),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanStep() {
    final plans = [
      {'name': 'Free Tier', 'desc': 'Best for startups', 'price': '0'},
      {'name': 'Standard', 'desc': 'For growing teams', 'price': '49'},
      {'name': 'Enterprise', 'desc': 'Full control', 'price': '199'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Choose a platform plan', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        ...plans.map((p) {
          final isSelected = _selectedPlan == p['name'];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              onTap: () => setState(() => _selectedPlan = p['name']!),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey[200]!, width: 2),
                  borderRadius: BorderRadius.circular(12),
                  color: isSelected ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.05) : null,
                ),
                child: Row(
                  children: [
                    Icon(isSelected ? Icons.radio_button_checked : Icons.radio_button_off, 
                      color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(p['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text(p['desc']!, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    ),
                    Text('\$${p['price']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildAdminStep() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Configure the initial administrator account for this business.', style: TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 24),
          const _FormLabel('Admin Full Name'),
          _FormTextField(controller: _adminNameController, hint: 'e.g. John Doe'),
          const SizedBox(height: 16),
          const _FormLabel('Work Email'),
          _FormTextField(controller: _adminEmailController, hint: 'admin@company.com'),
          const SizedBox(height: 16),
          const _FormLabel('Initial Password'),
          _FormTextField(controller: _adminPasswordController, hint: '••••••••', obscure: true),
          const SizedBox(height: 8),
          const Text('The admin will be forced to change this on first login.', style: TextStyle(fontSize: 11, color: Colors.orange, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _FormLabel extends StatelessWidget {
  final String label;
  const _FormLabel(this.label);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
  );
}

class _FormTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final int maxLines;
  final bool obscure;

  const _FormTextField({required this.controller, required this.hint, this.maxLines = 1, this.obscure = false});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
      ),
    );
  }
}
