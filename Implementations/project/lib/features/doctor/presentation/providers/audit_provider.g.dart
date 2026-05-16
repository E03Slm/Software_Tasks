// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(auditRepository)
final auditRepositoryProvider = AuditRepositoryProvider._();

final class AuditRepositoryProvider
    extends
        $FunctionalProvider<AuditRepository, AuditRepository, AuditRepository>
    with $Provider<AuditRepository> {
  AuditRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'auditRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$auditRepositoryHash();

  @$internal
  @override
  $ProviderElement<AuditRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuditRepository create(Ref ref) {
    return auditRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuditRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuditRepository>(value),
    );
  }
}

String _$auditRepositoryHash() => r'63286512f9e2d9bbea053c54f1b1618bd846842a';

@ProviderFor(AuditLogList)
final auditLogListProvider = AuditLogListProvider._();

final class AuditLogListProvider
    extends $AsyncNotifierProvider<AuditLogList, List<AuditLog>> {
  AuditLogListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'auditLogListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$auditLogListHash();

  @$internal
  @override
  AuditLogList create() => AuditLogList();
}

String _$auditLogListHash() => r'a39fe158b26a657fc8eea50a22ad2254fab4fff6';

abstract class _$AuditLogList extends $AsyncNotifier<List<AuditLog>> {
  FutureOr<List<AuditLog>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<AuditLog>>, List<AuditLog>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<AuditLog>>, List<AuditLog>>,
              AsyncValue<List<AuditLog>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
