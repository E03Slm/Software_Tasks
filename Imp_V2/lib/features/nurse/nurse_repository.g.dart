// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nurse_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(NurseRepository)
final nurseRepositoryProvider = NurseRepositoryProvider._();

final class NurseRepositoryProvider
    extends $NotifierProvider<NurseRepository, void> {
  NurseRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'nurseRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$nurseRepositoryHash();

  @$internal
  @override
  NurseRepository create() => NurseRepository();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$nurseRepositoryHash() => r'e1d675bb00fef9e55b9037fe725c03cf6336d387';

abstract class _$NurseRepository extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
