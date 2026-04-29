import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hr_management/shared/widgets/custom_widgets.dart';
import 'package:hr_management/shared/widgets/main_layout.dart';
import 'package:image_picker/image_picker.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  bool _isClockedIn = false;
  XFile? _selfie;
  final ImagePicker _picker = ImagePicker();

  Future<void> _takeSelfie() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() => _selfie = photo);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 900;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Current Time & Status
          CustomCard(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  const Text(
                    '08:45 AM',
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Wednesday, 29 April 2026',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: _isClockedIn ? Colors.green.shade50 : Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _isClockedIn ? 'YOU ARE CLOCKED IN' : 'YOU ARE NOT CLOCKED IN',
                      style: TextStyle(
                        color: _isClockedIn ? Colors.green : Colors.orange,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Main Core Section: Photo & Action
          Flex(
            direction: isDesktop ? Axis.horizontal : Axis.vertical,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Selfie Component
              Expanded(
                flex: isDesktop ? 1 : 0,
                child: CustomCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Selfie Verification', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: _takeSelfie,
                        child: Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
                          ),
                          child: _selfie != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.file(File(_selfie!.path), fit: BoxFit.cover),
                                )
                              : const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.camera_alt_outlined, size: 40, color: Colors.grey),
                                    SizedBox(height: 8),
                                    Text('Click to take a selfie', style: TextStyle(color: Colors.grey, fontSize: 12)),
                                  ],
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (isDesktop) const SizedBox(width: 24) else const SizedBox(height: 24),
              
              // Clock Action & Location
              Expanded(
                flex: isDesktop ? 1 : 0,
                child: Column(
                  children: [
                    CustomCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Location', style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 12),
                          const Row(
                            children: [
                              Icon(Icons.location_on, color: Colors.red, size: 20),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'House-32, Road-04, Sector-01, Uttara, Dhaka, Bangladesh',
                                  style: TextStyle(fontSize: 13, color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          CustomButton(
                            text: _isClockedIn ? 'Clock Out Now' : 'Clock In Now',
                            fullWidth: true,
                            icon: _isClockedIn ? Icons.logout_rounded : Icons.login_rounded,
                            backgroundColor: _isClockedIn ? Colors.red.shade400 : null,
                            onPressed: () {
                              if (_selfie == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Please take a selfie first!')),
                                );
                                return;
                              }
                              setState(() => _isClockedIn = !_isClockedIn);
                              if (!_isClockedIn) _selfie = null; // Reset for next time
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Attendance History
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Recent Attendance Activity',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          CustomCard(
            padding: EdgeInsets.zero,
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.green.shade50, shape: BoxShape.circle),
                    child: const Icon(Icons.check, color: Colors.green, size: 16),
                  ),
                  title: Text('${28 - index} April 2026', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  subtitle: const Text('Check-in: 09:02 AM • Check-out: 06:15 PM', style: TextStyle(fontSize: 12)),
                  trailing: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('9h 13m', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('Present', style: TextStyle(fontSize: 10, color: Colors.grey)),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
