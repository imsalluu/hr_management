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
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Header Card
          CustomCard(
            child: Row(
              children: [
                CircleAvatar(
                  radius: isDesktop ? 50 : 35,
                  backgroundImage: user?.profileImage != null ? NetworkImage(user!.profileImage!) : null,
                  child: user?.profileImage == null ? const Icon(Icons.person, size: 40) : null,
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user?.name ?? 'User Name', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      Text(user?.role.name.toUpperCase() ?? 'ROLE', style: TextStyle(color: Colors.amber.shade700, fontWeight: FontWeight.bold, fontSize: 12)),
                      const SizedBox(height: 8),
                      Text(user?.email ?? 'email@company.com', style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
                if (isDesktop)
                  CustomButton(
                    text: 'Edit Profile',
                    icon: Icons.edit_outlined,
                    onPressed: () {},
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Info Sections
          Flex(
            direction: isDesktop ? Axis.horizontal : Axis.vertical,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: isDesktop ? 1 : 0,
                child: _InfoSection(
                  title: 'Personal Information',
                  items: [
                    _InfoItem(label: 'Date of Birth', value: '10 July 2005'),
                    _InfoItem(label: 'Gender', value: 'Male'),
                    _InfoItem(label: 'Religion', value: 'Islam'),
                    _InfoItem(label: 'Blood Group', value: 'O+'),
                  ],
                ),
              ),
              if (isDesktop) const SizedBox(width: 24) else const SizedBox(height: 24),
              Expanded(
                flex: isDesktop ? 1 : 0,
                child: _InfoSection(
                  title: 'Work Information',
                  items: [
                    _InfoItem(label: 'Employee ID', value: '35013'),
                    _InfoItem(label: 'Department', value: 'IT / Engineering'),
                    _InfoItem(label: 'Designation', value: 'Flutter Developer'),
                    _InfoItem(label: 'Joining Date', value: '20 Sep 2025'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  final String title;
  final List<_InfoItem> items;
  const _InfoSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 16),
          ...items,
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String label;
  final String value;
  const _InfoItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }
}
