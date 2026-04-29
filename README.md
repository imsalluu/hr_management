# PeopleDesk HR - Multi-Tenant HR Management SaaS

PeopleDesk is a premium, modern HR Management SaaS platform built with Flutter. It features a robust multi-tenant architecture with a refined role-based access control (RBAC) system, tailored for both platform owners and business entities.

![Banner Placeholder](https://via.placeholder.com/1200x400.png?text=PeopleDesk+HR+SaaS+Platform)

## ✨ Core Features

### 🏢 Multi-Tenant Infrastructure
- **System Owner (Platform Admin)**: High-level dashboard for ecosystem health, business registration, and global billing metrics.
- **Business Owner**: Full administrative control over their specific company tenant.
- **Tenant Isolation**: Secure data separation for multiple companies on a single platform.

### 🔐 Role-Based Access Control (RBAC)
- **Six Distinct Roles**: 
  - System Owner (Platform)
  - Business Owner (Company Admin)
  - HR Manager
  - Line Manager
  - Supervisor
  - Member (Employee)
- **Dynamic UI**: Sidebars and dashboards adapt in real-time based on user permissions.

### 🤳 Attendance & Shift Management
- **Selfie Verification**: Photo-based check-in/out for field employees.
- **Shift Scheduling**: Create and assign shifts to staff.
- **Location Tracking**: Placeholder for GPS-based attendance validation.

### 📅 Advanced Visuals
- **Interactive Calendar**: Color-coded attendance status (Present, Absent, Leave, Holiday).
- **Premium Yellow Theme**: A soft, professional #FFC107 yellow and white aesthetic.
- **Responsive Design**: Consistent experience across Desktop (Web) and Mobile.

### 💳 Billing & Analytics
- **Platform Analytics**: Total revenue and tenant growth tracking.
- **Subscription Management**: Monitor invoice statuses (Paid, Due, Overdue).

## 🛠️ Tech Stack
- **Framework**: Flutter (Web & Mobile)
- **State Management**: [Riverpod](https://riverpod.dev/)
- **Navigation**: [GoRouter](https://pub.dev/packages/go_router)
- **Styling**: Vanilla CSS principles within Flutter widgets for maximum control.
- **Architecture**: Domain-Driven Design (DDD) inspired folder structure.

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (Latest Stable)
- Dart SDK

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/imsalluu/hr_management.git
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the application:
   ```bash
   flutter run -d chrome # For Web
   # OR
   flutter run # For Mobile
   ```

## 🧪 Demo Login
The application includes a mock authentication system for easy testing. On the login screen, you can use the quick-login chips to swap between roles:
- **System Owner**: Platform analytics & billing.
- **Business Owner**: Complete company management.
- **Employee**: Individual attendance and leave tools.

---
Developed with ❤️ by imsalluu
