import 'package:flutter_riverpod/flutter_riverpod.dart';

enum UserRole {
  member,
  supervisor,
  lineManager,
  hr,
  businessOwner,
  systemOwner
}

class UserModel {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String? companyName;
  final String? profileImage;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.companyName,
    this.profileImage,
  });

  factory UserModel.mock(UserRole role) {
    switch (role) {
      case UserRole.systemOwner:
        return UserModel(id: '1', name: 'Platform Admin', email: 'owner@system.com', role: role);
      case UserRole.businessOwner:
        return UserModel(id: '0', name: 'Salman Business', email: 'owner@company.com', role: role, companyName: 'Tech Corp');
      case UserRole.hr:
        return UserModel(id: '2', name: 'Sarah HR', email: 'hr@company.com', role: role, companyName: 'Tech Corp');
      case UserRole.lineManager:
        return UserModel(id: '3', name: 'John Manager', email: 'manager@company.com', role: role, companyName: 'Tech Corp');
      case UserRole.supervisor:
        return UserModel(id: '4', name: 'Jane Supervisor', email: 'supervisor@company.com', role: role, companyName: 'Tech Corp');
      case UserRole.member:
        return UserModel(id: '5', name: 'Hossain Employee', email: 'employee@company.com', role: role, companyName: 'Tech Corp', profileImage: 'https://i.pravatar.cc/150?u=99');
    }
  }
}

final currentUserProvider = StateProvider<UserModel?>((ref) => null);
final authProvider = StateProvider<bool>((ref) => false);
