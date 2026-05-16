import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/models/drug.dart';
import '../../data/repositories/drug_repository.dart';
import './audit_provider.dart';

part 'drug_provider.g.dart';

@riverpod
DrugRepository drugRepository(Ref ref) {
  final auditRepo = ref.watch(auditRepositoryProvider);
  return DrugRepository(auditRepo);
}

@riverpod
Stream<List<Drug>> drugList(Ref ref) {
  return ref.watch(drugRepositoryProvider).streamDrugs();
}

@riverpod
class DrugSearch extends _$DrugSearch {
  @override
  String build() => '';

  void setQuery(String query) => state = query;
}

@riverpod
AsyncValue<List<Drug>> filteredDrugs(Ref ref) {
  final drugsAsync = ref.watch(drugListProvider);
  final query = ref.watch(drugSearchProvider).toLowerCase();

  if (query.isEmpty) return drugsAsync;

  return drugsAsync.whenData((drugs) {
    return drugs.where((drug) {
      return drug.name.toLowerCase().contains(query);
    }).toList();
  });
}

final drugNamesMapProvider = FutureProvider<Map<String, String>>((ref) async {
  try {
    final client = Supabase.instance.client;
    // We fetch ALL drugs, including deleted ones, so audit logs can resolve names for historical data
    final response = await client.from('drug').select('drug_id, name');
    return {
      for (final d in response) 
        d['drug_id'] as String: d['name'] as String
    };
  } catch (e) {
    print('Error fetching drug names: $e');
    return {};
  }
});
