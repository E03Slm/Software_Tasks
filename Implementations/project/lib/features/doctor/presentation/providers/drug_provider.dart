import 'package:riverpod_annotation/riverpod_annotation.dart';
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
