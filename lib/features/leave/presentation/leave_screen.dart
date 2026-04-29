import 'package:flutter/material.dart';
import 'package:hr_management/shared/widgets/custom_widgets.dart';
import 'package:hr_management/shared/widgets/main_layout.dart';

class LeaveScreen extends StatefulWidget {
  const LeaveScreen({super.key});

  @override
  State<LeaveScreen> createState() => _LeaveScreenState();
}

class _LeaveScreenState extends State<LeaveScreen> {
  final _reasonController = TextEditingController();
  final _dateController = TextEditingController();
  String _selectedType = 'Casual';
  
  final List<String> _leaveTypes = ['Casual', 'Sick', 'Paid', 'Maternity', 'Paternity'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Leave Balance Overview
          Flex(
            direction: isDesktop ? Axis.horizontal : Axis.vertical,
            children: [
              _BalanceCard(label: 'Casual Leave', total: 10, taken: 4, color: Colors.blue),
              if (isDesktop) const SizedBox(width: 20) else const SizedBox(height: 20),
              _BalanceCard(label: 'Sick Leave', total: 14, taken: 2, color: Colors.green),
              if (isDesktop) const SizedBox(width: 20) else const SizedBox(height: 20),
              _BalanceCard(label: 'Paid Leave', total: 12, taken: 0, color: Colors.orange),
            ],
          ),
          const SizedBox(height: 32),

          // Form & History
          Flex(
            direction: isDesktop ? Axis.horizontal : Axis.vertical,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Apply Form
              Expanded(
                flex: isDesktop ? 2 : 0,
                child: CustomCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Apply For Leave', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 24),
                      DropdownButtonFormField<String>(
                        value: _selectedType,
                        decoration: const InputDecoration(labelText: 'Leave Type'),
                        items: _leaveTypes.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                        onChanged: (v) => setState(() => _selectedType = v!),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _dateController,
                        decoration: const InputDecoration(
                          labelText: 'Date Range',
                          hintText: 'Select dates',
                          suffixIcon: Icon(Icons.calendar_today_outlined),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _reasonController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Reason',
                          hintText: 'Enter your reason for leave',
                        ),
                      ),
                      const SizedBox(height: 32),
                      CustomButton(
                        text: 'Submit Application',
                        fullWidth: true,
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Leave application submitted!')),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              if (isDesktop) const SizedBox(width: 32) else const SizedBox(height: 32),
              
              // History & Approval Flow
              Expanded(
                flex: isDesktop ? 3 : 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('My Leave History', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    CustomCard(
                      padding: EdgeInsets.zero,
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 2,
                        separatorBuilder: (context, index) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          return ExpansionTile(
                            title: const Text('Sick Leave', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            subtitle: const Text('20 Apr - 22 Apr 2026 • 3 Days', style: TextStyle(fontSize: 12)),
                            trailing: _StatusBadge(status: index == 0 ? 'Pending' : 'Approved'),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Approval Timeline:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                    const SizedBox(height: 16),
                                    _TimelineItem(label: 'Supervisor', status: 'Approved', time: '20 Apr, 10:00 AM', isFirst: true),
                                    _TimelineItem(label: 'Line Manager', status: 'Approved', time: '21 Apr, 09:30 AM'),
                                    _TimelineItem(label: 'HR Manager', status: index == 0 ? 'Pending' : 'Approved', time: index == 0 ? '--' : '22 Apr, 11:00 AM', isLast: true),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
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

class _BalanceCard extends StatelessWidget {
  final String label;
  final int total;
  final int taken;
  final Color color;

  const _BalanceCard({required this.label, required this.total, required this.taken, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: CustomCard(
        child: Column(
          children: [
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
            const SizedBox(height: 12),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 60,
                  width: 60,
                  child: CircularProgressIndicator(
                    value: taken / total,
                    strokeWidth: 8,
                    backgroundColor: color.withValues(alpha: 0.1),
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
                Text('${total - taken}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
            const SizedBox(height: 12),
            Text('Left out of $total', style: const TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color = status == 'Approved' ? Colors.green : (status == 'Rejected' ? Colors.red : Colors.orange);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
      child: Text(
        status, 
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final String label;
  final String status;
  final String time;
  final bool isFirst;
  final bool isLast;

  const _TimelineItem({required this.label, required this.status, required this.time, this.isFirst = false, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    Color color = status == 'Approved' ? Colors.green : (status == 'Pending' ? Colors.orange : Colors.red);
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            if (!isLast) Container(width: 2, height: 40, color: Colors.grey.shade200),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                   Text(status, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
                ],
              ),
              Text(time, style: const TextStyle(color: Colors.grey, fontSize: 11)),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }
}
