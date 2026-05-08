import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hr_management/features/auth/presentation/auth_state.dart';
import 'package:hr_management/shared/widgets/custom_widgets.dart';
import 'package:hr_management/shared/widgets/main_layout.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final theme = Theme.of(context);
    final isDesktop = MediaQuery.of(context).size.width > 900;
    final isOwner = user?.role == UserRole.systemOwner;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Premium Header
          _ProfileHeader(user: user, isDesktop: isDesktop),
          const SizedBox(height: 32),

          if (isOwner) ...[
            const Padding(
              padding: EdgeInsets.only(bottom: 24, left: 4),
              child: Text('Platform Control Center', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
            ),
            _OwnerMetricsGrid(isDesktop: isDesktop, theme: theme),
            const SizedBox(height: 32),
          ],

          // Responsive Information Sections
          LayoutBuilder(
            builder: (context, constraints) {
              final useVertical = constraints.maxWidth < 800;
              return Flex(
                direction: useVertical ? Axis.vertical : Axis.horizontal,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: useVertical ? 0 : 1,
                    child: _InfoSection(
                      title: 'Personal Information',
                      icon: Icons.person_outline,
                      items: [
                        const _InfoItem(label: 'Full Name', value: 'Salman Hossain'),
                        const _InfoItem(label: 'Date of Birth', value: '10 July 2005'),
                        const _InfoItem(label: 'Gender', value: 'Male'),
                        const _InfoItem(label: 'Religion', value: 'Islam'),
                      ],
                    ),
                  ),
                  if (!useVertical) const SizedBox(width: 24) else const SizedBox(height: 24),
                  Expanded(
                    flex: useVertical ? 0 : 1,
                    child: isOwner 
                      ? _InfoSection(
                          title: 'Credentials & Security',
                          icon: Icons.security_outlined,
                          items: [
                            const _InfoItem(label: 'Admin ID', value: 'ADMIN-001'),
                            const _InfoItem(label: 'Email', value: 'owner@system.com'),
                            const _InfoItem(label: 'Account Status', value: 'Primary Admin', valueColor: Colors.green),
                            const _InfoItem(label: '2FA Status', value: 'Enabled', valueColor: Colors.blue),
                          ],
                        )
                      : _InfoSection(
                          title: 'Work Information',
                          icon: Icons.business_center_outlined,
                          items: [
                            const _InfoItem(label: 'Employee ID', value: '35013'),
                            const _InfoItem(label: 'Department', value: 'IT / Engineering'),
                            const _InfoItem(label: 'Designation', value: 'Flutter Developer'),
                            const _InfoItem(label: 'Joining Date', value: '20 Sep 2025'),
                          ],
                        ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ProfileHeader extends ConsumerWidget {
  final UserModel? user;
  final bool isDesktop;

  const _ProfileHeader({required this.user, required this.isDesktop});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.orange.shade50.withOpacity(0.3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.orange.shade100.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.amber.shade100,
                backgroundImage: user?.profileImage != null ? NetworkImage(user!.profileImage!) : null,
                child: user?.profileImage == null ? const Icon(Icons.person, size: 40, color: Colors.orange) : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
                  child: const Icon(Icons.camera_alt, size: 14, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(width: 32),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(user?.name ?? 'User Name', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: Colors.orange.shade100, borderRadius: BorderRadius.circular(20)),
                      child: Text(user?.role.name.toUpperCase() ?? 'ROLE', 
                        style: TextStyle(color: Colors.orange.shade800, fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 0.5)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.email_outlined, size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(user?.email ?? '', style: const TextStyle(color: Colors.grey, fontSize: 14)),
                    const SizedBox(width: 24),
                    const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    const Text('Dhaka, Bangladesh', style: TextStyle(color: Colors.grey, fontSize: 14)),
                  ],
                ),
              ],
            ),
          ),
          if (isDesktop)
            ElevatedButton.icon(
              onPressed: () => _showSettingsModal(context, ref, user),
              icon: const Icon(Icons.edit_note_rounded),
              label: const Text('Account Settings'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black87,
                elevation: 0,
                side: BorderSide(color: Colors.grey.shade200),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
        ],
      ),
    );
  }

  void _showSettingsModal(BuildContext context, WidgetRef ref, UserModel? user) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Settings',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.centerRight,
          child: Container(
            width: 450,
            height: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20)],
            ),
            child: Material(
              color: Colors.transparent,
              child: _SettingsView(user: user),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).animate(anim1),
          child: child,
        );
      },
    );
  }
}

class _SettingsView extends StatefulWidget {
  final UserModel? user;
  const _SettingsView({this.user});

  @override
  State<_SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<_SettingsView> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  bool _darkMode = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user?.name);
    _emailController = TextEditingController(text: widget.user?.email);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Account Settings', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
          ],
        ),
        const SizedBox(height: 32),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionTitle('PROFILE CUSTOMIZATION'),
                const SizedBox(height: 16),
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.amber.shade100,
                        backgroundImage: widget.user?.profileImage != null ? NetworkImage(widget.user!.profileImage!) : null,
                        child: widget.user?.profileImage == null ? const Icon(Icons.person, size: 32, color: Colors.orange) : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
                          child: const Icon(Icons.edit, size: 12, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _SettingLabel('Full Name'),
                TextField(
                  controller: _nameController,
                  decoration: _inputDecoration('Enter your name'),
                ),
                const SizedBox(height: 16),
                _SettingLabel('Email Address'),
                TextField(
                  controller: _emailController,
                  decoration: _inputDecoration('Enter your email'),
                ),
                const SizedBox(height: 40),
                _SectionTitle('SECURITY'),
                const SizedBox(height: 16),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.lock_outline),
                  title: const Text('Change Password', style: TextStyle(fontSize: 14)),
                  trailing: const Icon(Icons.chevron_right, size: 20),
                  onTap: () {},
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.verified_user_outlined),
                  title: const Text('Two-Factor Authentication', style: TextStyle(fontSize: 14)),
                  trailing: Switch(value: true, onChanged: (v) {}),
                ),
                const SizedBox(height: 40),
                _SectionTitle('PREFERENCES'),
                const SizedBox(height: 16),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.dark_mode_outlined),
                  title: const Text('Dark Mode', style: TextStyle(fontSize: 14)),
                  trailing: Switch(value: _darkMode, onChanged: (v) => setState(() => _darkMode = v)),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.language_outlined),
                  title: const Text('Language', style: TextStyle(fontSize: 14)),
                  trailing: const Text('English (US)', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 20),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Save Changes'),
          ),
        ),
      ],
    );
  }

  Widget _SectionTitle(String title) {
    return Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.2));
  }

  Widget _SettingLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black87)),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.grey.shade50,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }
}

class _OwnerMetricsGrid extends StatelessWidget {
  final bool isDesktop;
  final ThemeData theme;

  const _OwnerMetricsGrid({required this.isDesktop, required this.theme});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: isDesktop ? 4 : 2,
      crossAxisSpacing: 24,
      mainAxisSpacing: 24,
      childAspectRatio: 1.5,
      children: [
        _MetricTile(label: 'Total Revenue', value: '\$142,500', icon: Icons.payments, color: Colors.green),
        _MetricTile(label: 'Active Clients', value: '42 Businesses', icon: Icons.business, color: Colors.blue),
        _MetricTile(label: 'System Uptime', value: '99.98%', icon: Icons.speed, color: Colors.purple),
        _MetricTile(label: 'Active Users', value: '8,420', icon: Icons.people, color: Colors.orange),
      ],
    );
  }
}

class _MetricTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _MetricTile({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, size: 20, color: color),
          ),
          const Spacer(),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<_InfoItem> items;
  const _InfoSection({required this.title, required this.icon, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: Colors.blue),
              const SizedBox(width: 12),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 24),
          ...items,
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  const _InfoItem({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: valueColor)),
        ],
      ),
    );
  }
}

