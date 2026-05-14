import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme.dart';

class SessionLogScreen extends ConsumerWidget {
  const SessionLogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Session Log')),
      body: ListView.builder(
        padding: const EdgeInsets.all(spaceMd),
        itemCount: 10, // Mock data for now
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: spaceMd),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '12:0${index} PM',
                  style: captionStyle.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: spaceMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Infusion update', style: bodyStyle),
                      Text('Volume infused: ${index * 1.5} mL', style: captionStyle.copyWith(color: Colors.grey)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
