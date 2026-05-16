import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:project/features/doctor/presentation/providers/drug_provider.dart';
import 'package:project/features/nurse/presentation/providers/infusion_provider.dart';
import 'package:project/core/theme/nurse_theme.dart';

class DrugSelectionScreen extends ConsumerStatefulWidget {
  const DrugSelectionScreen({super.key});

  @override
  ConsumerState<DrugSelectionScreen> createState() => _DrugSelectionScreenState();
}

class _DrugSelectionScreenState extends ConsumerState<DrugSelectionScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final drugListAsync = ref.watch(drugListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Infusion Monitor'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
        actions: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Icon(Icons.account_circle, size: 32),
          ),
        ],
      ),
      body: drugListAsync.when(
        data: (drugList) {
          final filteredList = drugList
              .where((d) => d.name.toLowerCase().contains(_searchQuery.toLowerCase()))
              .toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                _buildSearchBar(),
                const SizedBox(height: 32),
                _buildCommonlyPrescribed(drugList),
                const SizedBox(height: 32),
                _buildFullLibrary(filteredList),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Medication',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          'Select a drug to begin infusion programming',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: TextField(
        onChanged: (value) => setState(() => _searchQuery = value),
        decoration: InputDecoration(
          hintText: 'Search drug library...',
          prefixIcon: const Icon(Icons.search),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  Widget _buildCommonlyPrescribed(List<dynamic> drugList) {
    // Sort by name or just take the first 3 for now. 
    // In a real app, you'd sort by a 'prescription_count' field from DB.
    final commonDrugs = drugList.take(3).toList();
    if (commonDrugs.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Commonly Prescribed',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: commonDrugs.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1, // Stack them on mobile for better visibility
            mainAxisSpacing: 12,
            childAspectRatio: 4.5, 
          ),
          itemBuilder: (context, index) {
            final drug = commonDrugs[index];
            return _buildCommonlyDrugCard(drug);
          },
        ),
      ],
    );
  }

  Widget _buildCommonlyDrugCard(dynamic drug) {
    return InkWell(
      onTap: () => _selectDrug(drug),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.blue.shade50.withValues(alpha: 0.3)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.star, color: Colors.blue, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    drug.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    '${drug.concentration} ${drug.concentrationUnit}',
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 12),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Theme.of(context).colorScheme.primary),
          ],
        ),
      ),
    );
  }

  Widget _buildDrugCard(dynamic drug) {
    return InkWell(
      onTap: () => _selectDrug(drug),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'VASCULAR', // Mocked category
                    style: TextStyle(color: Colors.blue.shade900, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
                const Icon(Icons.star, color: Colors.amber, size: 16),
              ],
            ),
            Text(
              drug.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              '${drug.concentration} ${drug.concentrationUnit}',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 11),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  'Select Drug',
                  style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 12, fontWeight: FontWeight.bold),
                ),
                Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.primary, size: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFullLibrary(List<dynamic> filteredList) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainer,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Active Drug Library', style: TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    Icon(Icons.filter_list, color: Theme.of(context).colorScheme.onSurfaceVariant, size: 20),
                    const SizedBox(width: 8),
                    Icon(Icons.sort_by_alpha, color: Theme.of(context).colorScheme.onSurfaceVariant, size: 20),
                  ],
                ),
              ],
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredList.length,
            separatorBuilder: (context, index) => Divider(height: 1, color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.3)),
            itemBuilder: (context, index) {
              final drug = filteredList[index];
              return ListTile(
                onTap: () => _selectDrug(drug),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.medication, color: Colors.blue),
                ),
                title: Text(drug.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text('Conc: ${drug.concentration} ${drug.concentrationUnit}'),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        _buildBadge('Rate: ${drug.defaultRate} mL/hr', Colors.grey.shade100, Colors.grey.shade700),
                        const SizedBox(width: 8),
                        _buildBadge('Max: ${drug.hardLimitHigh} mL/hr', Colors.red.shade50, Colors.red.shade700),
                      ],
                    ),
                  ],
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              );
            },
          ),
        ],
      ),
    );
  }

  void _selectDrug(dynamic drug) {
    ref.read(infusionProvider.notifier).selectDrug(drug);
    context.push('/nurse/parameters');
  }

  Widget _buildBadge(String label, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(color: textColor, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }
}

