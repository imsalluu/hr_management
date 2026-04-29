import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hr_management/features/auth/presentation/auth_state.dart';
import 'package:hr_management/shared/widgets/custom_widgets.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _login(UserRole role) async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1)); // Simulate API
    
    final user = UserModel.mock(role);
    ref.read(currentUserProvider.notifier).state = user;
    ref.read(authProvider.notifier).state = true;
    
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 900;

    return Scaffold(
      body: Row(
        children: [
          if (isDesktop)
            Expanded(
              flex: 1,
              child: Container(
                color: theme.colorScheme.primary.withValues(alpha: 0.05),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.business_center, size: 80, color: Color(0xFFFFC107)),
                        const SizedBox(height: 24),
                        Text(
                          'Streamline your HR workflow with PeopleDesk',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'The all-in-one SaaS platform for attendance, leave, and employee management.',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          Expanded(
            flex: 1,
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(40),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.business_center, size: 48, color: Color(0xFFFFC107)),
                      const SizedBox(height: 24),
                      const Text(
                        'Welcome Back',
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Enter your credentials to access your dashboard',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 32),
                      TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email Address',
                          hintText: 'name@company.com',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock_outline),
                        ),
                      ),
                      const SizedBox(height: 24),
                      CustomButton(
                        text: 'Login',
                        fullWidth: true,
                        isLoading: _isLoading,
                        onPressed: () => _login(UserRole.member),
                      ),
                      const SizedBox(height: 32),
                      const Center(child: Text('OR LOGIN AS (DEMO)', style: TextStyle(color: Colors.grey, fontSize: 12))),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _RoleChip(label: 'System Owner', role: UserRole.systemOwner, onTap: _login),
                          _RoleChip(label: 'Business Owner', role: UserRole.businessOwner, onTap: _login),
                          _RoleChip(label: 'HR Manager', role: UserRole.hr, onTap: _login),
                          _RoleChip(label: 'Supervisor', role: UserRole.supervisor, onTap: _login),
                          _RoleChip(label: 'Employee', role: UserRole.member, onTap: _login),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoleChip extends StatelessWidget {
  final String label;
  final UserRole role;
  final Function(UserRole) onTap;

  const _RoleChip({required this.label, required this.role, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(label, style: const TextStyle(fontSize: 12)),
      onPressed: () => onTap(role),
      backgroundColor: Colors.amber.shade50,
      side: BorderSide(color: Colors.amber.shade200),
    );
  }
}
