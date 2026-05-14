import 'package:flutter/material.dart';
import '../../../core/theme.dart';

class AdminLogsScreen extends StatelessWidget {
  const AdminLogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(spaceMd),
        child: Column(
          children: [
            // Filter Card
            Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(spaceMd)),
              child: Padding(
                padding: const EdgeInsets.all(spaceMd),
                child: Column(
                  children: [
                    _buildFilterField(context, Icons.calendar_today, 'Date Range', 'Last 7 Days'),
                    const SizedBox(height: spaceSm),
                    _buildFilterField(context, Icons.medication, 'Drug Name', 'All Drugs'),
                    const SizedBox(height: spaceSm),
                    _buildFilterField(context, Icons.person_search, 'User ID', 'Search ID...'),
                    const SizedBox(height: spaceMd),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 44),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(spaceSm)),
                      ),
                      child: const Text('≡ More Filters'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: spaceMd),

            // Log Table Card
            Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(spaceMd)),
              child: Column(
                children: [
                  const _TableHeader(),
                  const Divider(height: 1),
                  _LogEntry(
                    timestamp: '14 May 2026\n23:15 UTC',
                    type: 'CONFIG CHANGE',
                    typeColor: Colors.blue,
                    description: 'Global VTBI hard limit updated to 2000mL',
                    userId: 'AD-0012',
                  ),
                  const Divider(height: 1),
                  _LogEntry(
                    timestamp: '14 May 2026\n22:42 UTC',
                    type: 'CRITICAL ALERT',
                    typeColor: Colors.red,
                    description: 'Slave node #4 timeout during handshake',
                    userId: 'SYS-ENG',
                  ),
                  const Divider(height: 1),
                  _LogEntry(
                    timestamp: '14 May 2026\n21:10 UTC',
                    type: 'AUTH SUCCESS',
                    typeColor: Colors.green,
                    description: 'Nurse N-8842 logged in from station B',
                    userId: 'N-8842',
                  ),
                  const Padding(
                    padding: EdgeInsets.all(spaceMd),
                    child: Text('Showing 1–3 of 1,204 entries', style: captionStyle),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterField(BuildContext context, IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(spaceSm),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          Text(label, style: captionStyle.copyWith(fontWeight: FontWeight.bold)),
          const Spacer(),
          Text(value, style: bodyStyle.copyWith(fontSize: 14)),
          const Icon(Icons.arrow_drop_down),
        ],
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  const _TableHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.grey.shade50,
      child: Row(
        children: [
          Expanded(flex: 2, child: Text('Timestamp', style: labelCaps)),
          Expanded(flex: 2, child: Text('Event Type', style: labelCaps)),
          Expanded(flex: 3, child: Text('Description', style: labelCaps)),
          const Icon(Icons.chevron_right, color: Colors.transparent),
        ],
      ),
    );
  }
}

class _LogEntry extends StatelessWidget {
  final String timestamp;
  final String type;
  final Color typeColor;
  final String description;
  final String userId;

  const _LogEntry({
    required this.timestamp,
    required this.type,
    required this.typeColor,
    required this.description,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(timestamp, style: captionStyle.copyWith(height: 1.2)),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: typeColor.withOpacity(0.1),
                    border: Border.all(color: typeColor.withOpacity(0.3)),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(type, style: TextStyle(color: typeColor, fontSize: 8, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(description, style: bodyStyle.copyWith(fontSize: 13, height: 1.2), maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text('User: $userId', style: captionStyle.copyWith(fontSize: 11, color: Colors.grey)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
        ],
      ),
    );
  }
}
