import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/drug_provider.dart';
import '../../domain/models/drug.dart';
import '../../../../features/auth/presentation/providers/auth_provider.dart';
import '../../../../core/theme/doctor_theme.dart';

class DrugLibraryScreen extends ConsumerWidget {
  const DrugLibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final drugListAsync = ref.watch(filteredDrugsProvider);
    final doctorColors = Theme.of(context).extension<DoctorColors>()!;

    return Scaffold(
      body: drugListAsync.when(
        data: (drugs) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                onChanged: (value) => ref.read(drugSearchProvider.notifier).setQuery(value),
                decoration: InputDecoration(
                  hintText: 'Search drugs...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () {
                      ref.read(drugSearchProvider.notifier).setQuery('');
                      ref.read(drugListProvider.notifier).refresh();
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: drugs.length,
                itemBuilder: (context, index) {
                  final drug = drugs[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      title: Text(drug.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${drug.concentration} ${drug.concentrationUnit}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => context.push('/doctor/edit-drug/${drug.id}'),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _confirmDelete(context, ref, drug),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/doctor/add-drug'),
        backgroundColor: doctorColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Drug', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, Drug drug) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Drug?'),
        content: Text('Are you sure you want to remove ${drug.name} from the library?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () async {
              try {
                final currentUser = ref.read(authProvider);
                await ref.read(drugRepositoryProvider).deleteDrug(drug.id, currentUser?.id ?? '');
                // Invalidate the provider to trigger a fresh fetch
                ref.invalidate(drugListProvider);
                if (context.mounted) Navigator.pop(context);
              } catch (e) {
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Cannot delete drug: It might be in use or protected.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('DELETE', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
