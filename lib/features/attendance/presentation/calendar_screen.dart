import 'package:flutter/material.dart';
import 'package:hr_management/shared/widgets/custom_widgets.dart';
import 'package:hr_management/shared/widgets/main_layout.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // Mock data for calendar marking
  final Map<DateTime, List<String>> _events = {
    DateTime(2026, 4, 1): ['Present'],
    DateTime(2026, 4, 2): ['Present'],
    DateTime(2026, 4, 3): ['Absent'],
    DateTime(2026, 4, 4): ['Holiday'],
    DateTime(2026, 4, 5): ['Holiday'],
    DateTime(2026, 4, 6): ['Leave'],
    DateTime(2026, 4, 7): ['Present'],
    // ... more mock dates
  };

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Present': return Colors.green;
      case 'Absent': return Colors.red;
      case 'Leave': return Colors.amber;
      case 'Holiday': return Colors.blueGrey;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Flex(
            direction: isDesktop ? Axis.horizontal : Axis.vertical,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Calendar Component
              Expanded(
                flex: isDesktop ? 2 : 0,
                child: CustomCard(
                  padding: const EdgeInsets.all(8),
                  child: TableCalendar(
                    firstDay: DateTime.utc(2025, 1, 1),
                    lastDay: DateTime.utc(2027, 12, 31),
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                    },
                    headerStyle: const HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      titleTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    calendarStyle: CalendarStyle(
                      todayDecoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.3),
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      markerDecoration: const BoxDecoration(
                        color: Colors.transparent, // We'll build custom markers
                      ),
                    ),
                    calendarBuilders: CalendarBuilders(
                      markerBuilder: (context, date, events) {
                        // Simple mock logic for markers
                        final d = DateTime(date.year, date.month, date.day);
                        if (_events.containsKey(d)) {
                          final status = _events[d]!.first;
                          return Positioned(
                            bottom: 4,
                            child: Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: _getStatusColor(status),
                                shape: BoxShape.circle,
                              ),
                            ),
                          );
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ),
              if (isDesktop) const SizedBox(width: 24) else const SizedBox(height: 24),
              
              // Legend & Details
              Expanded(
                flex: isDesktop ? 1 : 0,
                child: Column(
                  children: [
                    // Legend Card
                    CustomCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Legend', style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 16),
                          _LegendItem(color: Colors.green, label: 'Present'),
                          _LegendItem(color: Colors.red, label: 'Absent'),
                          _LegendItem(color: Colors.amber, label: 'Leave'),
                          _LegendItem(color: Colors.blueGrey, label: 'Holiday'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Details Card
                    CustomCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Details for ${_selectedDay?.day}/${_selectedDay?.month}/${_selectedDay?.year}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          const _DetailRow(label: 'Shift', value: 'General (09:00 - 06:00)'),
                          const Divider(),
                          const _DetailRow(label: 'Check-in', value: '09:02 AM'),
                          const Divider(),
                          const _DetailRow(label: 'Check-out', value: '06:15 PM'),
                          const Divider(),
                          const _DetailRow(label: 'Worked', value: '09h 13m'),
                        ],
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

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
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
