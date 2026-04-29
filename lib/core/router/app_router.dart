import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hr_management/features/auth/presentation/auth_state.dart';
import 'package:hr_management/features/auth/presentation/login_screen.dart';
import 'package:hr_management/features/dashboard/presentation/dashboard_screen.dart';
import 'package:hr_management/features/attendance/presentation/attendance_screen.dart';
import 'package:hr_management/features/attendance/presentation/calendar_screen.dart';
import 'package:hr_management/features/leave/presentation/leave_screen.dart';
import 'package:hr_management/features/employee/presentation/employee_list_screen.dart';
import 'package:hr_management/features/dashboard/presentation/profile_screen.dart';
import 'package:hr_management/features/shift/presentation/shift_screen.dart';
import 'package:hr_management/features/management/presentation/approvals_screen.dart';
import 'package:hr_management/features/admin/presentation/tenant_management_screen.dart';
import 'package:hr_management/features/admin/presentation/system_dashboard_screen.dart';
import 'package:hr_management/features/admin/presentation/billing_screen.dart';
import 'package:hr_management/shared/widgets/main_layout.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);
  
  return GoRouter(
    initialLocation: '/login',
    refreshListenable: _AuthListenable(ref),
    redirect: (context, state) {
      final loggingIn = state.matchedLocation == '/login';
      if (!authState) return loggingIn ? null : '/login';
      if (loggingIn) return '/';

      final user = ref.read(currentUserProvider);
      final role = user?.role ?? UserRole.member;
      final location = state.matchedLocation;

      // Protect management routes
      if ((location == '/employee' || location == '/shift' || location == '/approvals') && 
          (role == UserRole.member || role == UserRole.systemOwner)) {
        return '/';
      }

      // Protect System Owner routes
      if (location == '/tenants' && role != UserRole.systemOwner) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          // Determine the title based on the path
          String title = 'Dashboard';
          final location = state.matchedLocation;
          if (location == '/attendance') title = 'Attendance';
          if (location == '/calendar') title = 'Attendance Calendar';
          if (location == '/leave') title = 'Leave Management';
          if (location == '/shift') title = 'Shift Management';
          if (location == '/employee') title = 'Employee Management';
          if (location == '/profile') title = 'My Profile';
          if (location == '/approvals') title = 'Approvals';
          if (location == '/tenants') title = 'Business Management';
          if (location == '/system-dashboard') title = 'Platform Analytics';
          if (location == '/billing') title = 'Platform Billing';

          return MainLayout(
            title: title,
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/attendance',
            builder: (context, state) => const AttendanceScreen(),
          ),
          GoRoute(
            path: '/calendar',
            builder: (context, state) => const CalendarScreen(),
          ),
          GoRoute(
            path: '/leave',
            builder: (context, state) => const LeaveScreen(),
          ),
          GoRoute(
            path: '/employee',
            builder: (context, state) => const EmployeeListScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: '/shift',
            builder: (context, state) => const ShiftScreen(),
          ),
          GoRoute(
            path: '/approvals',
            builder: (context, state) => const ApprovalsScreen(),
          ),
          GoRoute(
            path: '/tenants',
            builder: (context, state) => const TenantManagementScreen(),
          ),
          GoRoute(
            path: '/system-dashboard',
            builder: (context, state) => const SystemDashboardScreen(),
          ),
          GoRoute(
            path: '/billing',
            builder: (context, state) => const BillingScreen(),
          ),
        ],
      ),
    ],
  );
});

class _AuthListenable extends ChangeNotifier {
  _AuthListenable(Ref ref) {
    ref.listen(authProvider, (_, __) => notifyListeners());
  }
}

class _PlaceholderScreen extends StatelessWidget {
  final String title;
  const _PlaceholderScreen({required this.title});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text(title)),
    );
  }
}
