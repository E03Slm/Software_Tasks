// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nurse_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(drugList)
final drugListProvider = DrugListProvider._();

final class DrugListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Drug>>,
          List<Drug>,
          FutureOr<List<Drug>>
        >
    with $FutureModifier<List<Drug>>, $FutureProvider<List<Drug>> {
  DrugListProvider._()
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
  String debugGetCreateSourceHash() => _$drugListHash();

  @$internal
  @override
  $FutureProviderElement<List<Drug>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Drug>> create(Ref ref) {
    return drugList(ref);
  }
}

String _$drugListHash() => r'7b5317ad8aa60cb87fa2148b6aec69965b01ecd6';

@ProviderFor(SelectedDrug)
final selectedDrugProvider = SelectedDrugProvider._();

final class SelectedDrugProvider
    extends $NotifierProvider<SelectedDrug, Drug?> {
  SelectedDrugProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedDrugProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedDrugHash();

  @$internal
  @override
  SelectedDrug create() => SelectedDrug();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Drug? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Drug?>(value),
    );
  }
}

String _$selectedDrugHash() => r'4f10297883446e196ddd07f99ae4f52777d6daf1';

abstract class _$SelectedDrug extends $Notifier<Drug?> {
  Drug? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Drug?, Drug?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Drug?, Drug?>,
              Drug?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(activeAlarms)
final activeAlarmsProvider = ActiveAlarmsProvider._();

final class ActiveAlarmsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Map<String, dynamic>>>,
          List<Map<String, dynamic>>,
          Stream<List<Map<String, dynamic>>>
        >
    with
        $FutureModifier<List<Map<String, dynamic>>>,
        $StreamProvider<List<Map<String, dynamic>>> {
  ActiveAlarmsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeAlarmsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeAlarmsHash();

  @$internal
  @override
  $StreamProviderElement<List<Map<String, dynamic>>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Map<String, dynamic>>> create(Ref ref) {
    return activeAlarms(ref);
  }
}

String _$activeAlarmsHash() => r'0ac6a832b3665a6a7bfb110dc39fd07464e690c5';
