import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../nurse/nurse_providers.dart';
import '../../../core/theme.dart';

class DrugLibraryScreen extends ConsumerWidget {
  const DrugLibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final drugListAsync = ref.watch(drugListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pharmaceutical Protocols'),
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
                  leading: const CircleAvatar(backgroundColor: Color(0xFFE0F2F1), child: Icon(Icons.medication, color: Color(0xFF00685D))),
                  title: Text(drug.name, style: bodyStyle.copyWith(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    '${drug.concentration} ${drug.concentrationUnit} • Limits: ${drug.softLimitThreshold}/${drug.hardLimitCeiling} mL/hr',
                    style: captionStyle,
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit_outlined, color: Color(0xFF00685D)),
                    onPressed: () => context.push('/doctor/drugs/${drug.id}/edit'),
                  ),
                );
              },
            ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/doctor/drugs/add'),
        backgroundColor: const Color(0xFF00685D),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('NEW PROTOCOL', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.library_books_outlined, size: 64, color: Colors.grey),
          const SizedBox(height: spaceMd),
          Text('Protocol Library Empty', style: titleStyle),
          const SizedBox(height: spaceSm),
          const Text('Create your first pharmaceutical protocol using the button below.', style: captionStyle, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
