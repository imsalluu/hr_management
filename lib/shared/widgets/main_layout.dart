import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_management/features/auth/presentation/auth_state.dart';

class MainLayout extends ConsumerWidget {
  final Widget child;
  final String title;
  final List<Widget>? actions;

  const MainLayout({
    super.key,
    required this.child,
    required this.title,
    this.actions,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 900;
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87),
        ),
        actions: [
          if (actions != null) ...actions!,
          const SizedBox(width: 8),
          _ProfileMenu(user: user),
          const SizedBox(width: 16),
        ],
      ),
      drawer: isDesktop ? null : _Sidebar(currentLocation: GoRouterState.of(context).matchedLocation),
      body: Row(
        children: [
          if (isDesktop)
             Container(
               width: 260,
               decoration: const BoxDecoration(
                 color: Colors.white,
                 border: Border(right: BorderSide(color: Color(0x1A000000))),
               ),
               child: _Sidebar(currentLocation: GoRouterState.of(context).matchedLocation),
             ),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _Sidebar extends StatelessWidget {
  final String currentLocation;
  const _Sidebar({required this.currentLocation});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      child: Column(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.white),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.business_center, size: 48, color: Color(0xFFFFC107)),
                SizedBox(height: 12),
                Text('PeopleDesk', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black87)),
              ],
            ),
          ),
          Expanded(
            child: Consumer(
              builder: (context, ref, child) {
                final user = ref.watch(currentUserProvider);
                final role = user?.role ?? UserRole.member;

                return ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    if (role == UserRole.systemOwner)
                      _SidebarItem(icon: Icons.analytics_outlined, label: 'Platform Dashboard', route: '/system-dashboard', current: currentLocation),

                    if (role != UserRole.systemOwner)
                      _SidebarItem(icon: Icons.dashboard_outlined, label: 'Dashboard', route: '/', current: currentLocation),
                    
                    // Management / Admin Only: Approvals
                    if (role != UserRole.member && role != UserRole.systemOwner)
                      _SidebarItem(icon: Icons.fact_check_outlined, label: 'Approvals', route: '/approvals', current: currentLocation),
                    
                    if (role != UserRole.systemOwner) ...[
                      _SidebarItem(icon: Icons.fingerprint_rounded, label: 'Attendance', route: '/attendance', current: currentLocation),
                      _SidebarItem(icon: Icons.calendar_month_outlined, label: 'Calendar', route: '/calendar', current: currentLocation),
                      _SidebarItem(icon: Icons.beach_access_outlined, label: 'Leave', route: '/leave', current: currentLocation),
                    ],
                    
                    // HR / Business Owner Only
                    if (role == UserRole.hr || role == UserRole.businessOwner) ...[
                      _SidebarItem(icon: Icons.schedule_outlined, label: 'Shifts', route: '/shift', current: currentLocation),
                      _SidebarItem(icon: Icons.people_outline, label: 'Employees', route: '/employee', current: currentLocation),
                    ],

                    // System Owner Only
                    if (role == UserRole.systemOwner) ...[
                      _SidebarItem(icon: Icons.business_rounded, label: 'Businesses', route: '/tenants', current: currentLocation),
                      _SidebarItem(icon: Icons.payments_outlined, label: 'Billing', route: '/billing', current: currentLocation),
                    ],
                    
                    _SidebarItem(icon: Icons.person_outline, label: 'Profile', route: '/profile', current: currentLocation),
                  ],
                );
              },
            ),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('v1.0.0', style: TextStyle(color: Colors.grey, fontSize: 12)),
          ),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String route;
  final String current;

  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.route,
    required this.current,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSelected = current == route;
    
    return ListTile(
      leading: Icon(icon, color: isSelected ? theme.colorScheme.primary : Colors.grey),
      title: Text(
        label,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? theme.colorScheme.primary : null,
        ),
      ),
      selected: isSelected,
      selectedTileColor: theme.colorScheme.primary.withValues(alpha: 0.1),
      onTap: () => context.go(route),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
    );
  }
}

class _ProfileMenu extends ConsumerWidget {
  final UserModel? user;
  const _ProfileMenu({this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton(
      offset: const Offset(0, 40),
      child: CircleAvatar(
        radius: 18,
        backgroundColor: Colors.amber.shade100,
        backgroundImage: user?.profileImage != null ? NetworkImage(user!.profileImage!) : null,
        child: user?.profileImage == null ? const Icon(Icons.person, color: Colors.orange) : null,
      ),
      itemBuilder: (context) => <PopupMenuEntry>[
        PopupMenuItem(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user?.name ?? 'Guest', style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(user?.email ?? '', style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          child: const Row(children: [Icon(Icons.settings_outlined, size: 20), SizedBox(width: 12), Text('Settings')]),
          onTap: () {},
        ),
        PopupMenuItem(
          child: const Row(children: [Icon(Icons.logout_rounded, size: 20, color: Colors.red), SizedBox(width: 12), Text('Logout', style: TextStyle(color: Colors.red))]),
          onTap: () {
            ref.read(authProvider.notifier).state = false;
            ref.read(currentUserProvider.notifier).state = null;
          },
        ),
      ],
    );
  }
}
