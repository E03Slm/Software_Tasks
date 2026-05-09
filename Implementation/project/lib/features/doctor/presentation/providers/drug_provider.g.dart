// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drug_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(drugRepository)
final drugRepositoryProvider = DrugRepositoryProvider._();

final class DrugRepositoryProvider
    extends $FunctionalProvider<DrugRepository, DrugRepository, DrugRepository>
    with $Provider<DrugRepository> {
  DrugRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'drugRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$drugRepositoryHash();

  @$internal
  @override
  $ProviderElement<DrugRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DrugRepository create(Ref ref) {
    return drugRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DrugRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DrugRepository>(value),
    );
  }
}

String _$drugRepositoryHash() => r'61abb625d633c1b2b6309cef2bf91da15356b436';

@ProviderFor(DrugListNotifier)
final drugListProvider = DrugListNotifierProvider._();

final class DrugListNotifierProvider
    extends $AsyncNotifierProvider<DrugListNotifier, List<Drug>> {
  DrugListNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'drugListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$drugListNotifierHash();

  @$internal
  @override
  DrugListNotifier create() => DrugListNotifier();
}

String _$drugListNotifierHash() => r'56f06e00d1b46da9481c9f0c3fce41c906b1c902';

abstract class _$DrugListNotifier extends $AsyncNotifier<List<Drug>> {
  FutureOr<List<Drug>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Drug>>, List<Drug>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Drug>>, List<Drug>>,
              AsyncValue<List<Drug>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(DrugSearch)
final drugSearchProvider = DrugSearchProvider._();

final class DrugSearchProvider extends $NotifierProvider<DrugSearch, String> {
  DrugSearchProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'drugSearchProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$drugSearchHash();

  @$internal
  @override
  DrugSearch create() => DrugSearch();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$drugSearchHash() => r'd3bcfc6c2154e5dc6ef14a3233c2135b573c748b';

abstract class _$DrugSearch extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(filteredDrugs)
final filteredDrugsProvider = FilteredDrugsProvider._();

final class FilteredDrugsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Drug>>,
          AsyncValue<List<Drug>>,
          AsyncValue<List<Drug>>
        >
    with $Provider<AsyncValue<List<Drug>>> {
  FilteredDrugsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filteredDrugsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filteredDrugsHash();

  @$internal
  @override
  $ProviderElement<AsyncValue<List<Drug>>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<List<Drug>> create(Ref ref) {
    return filteredDrugs(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<Drug>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<List<Drug>>>(value),
    );
  }
}

String _$filteredDrugsHash() => r'4f1eccd259d21648edcd460eb381176c3c5422aa';
