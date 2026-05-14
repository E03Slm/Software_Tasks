import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../nurse_providers.dart';
import '../../../core/theme.dart';

class DrugSelectionScreen extends ConsumerWidget {
  const DrugSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final drugListAsync = ref.watch(drugListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Pharmaceutical Protocol'),
      ),
      body: drugListAsync.when(
        data: (drugs) => drugs.isEmpty 
          ? _buildEmptyState()
          : ListView.separated(
              padding: const EdgeInsets.all(spaceMd),
              itemCount: drugs.length,
              separatorBuilder: (_, __) => const SizedBox(height: spaceSm),
              itemBuilder: (context, index) {
                final drug = drugs[index];
                return ListTile(
                  tileColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(spaceSm)),
                  title: Text(drug.name, style: bodyStyle.copyWith(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    '${drug.concentration} ${drug.concentrationUnit} • Default: ${drug.defaultRate} mL/hr',
                    style: captionStyle,
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    ref.read(selectedDrugProvider.notifier).select(drug);
                    context.push('/nurse/parameters');
                  },
                );
              },
            ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.medication_outlined, size: 64, color: Colors.grey),
          const SizedBox(height: spaceMd),
          Text('No Drug Protocols Found', style: titleStyle),
          const SizedBox(height: spaceSm),
          const Text('Contact clinical administration to add protocols.', style: captionStyle, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
