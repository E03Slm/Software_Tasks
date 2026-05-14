// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DoctorRepository)
final doctorRepositoryProvider = DoctorRepositoryProvider._();

final class DoctorRepositoryProvider
    extends $NotifierProvider<DoctorRepository, void> {
  DoctorRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'doctorRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$doctorRepositoryHash();

  @$internal
  @override
  DoctorRepository create() => DoctorRepository();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$doctorRepositoryHash() => r'7d7852e7631ec260c72ba926fbe33fc285015f37';

abstract class _$DoctorRepository extends $Notifier<void> {
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

@ProviderFor(clinicalAuditLogs)
final clinicalAuditLogsProvider = ClinicalAuditLogsProvider._();

final class ClinicalAuditLogsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Map<String, dynamic>>>,
          List<Map<String, dynamic>>,
          Stream<List<Map<String, dynamic>>>
        >
    with
        $FutureModifier<List<Map<String, dynamic>>>,
        $StreamProvider<List<Map<String, dynamic>>> {
  ClinicalAuditLogsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'clinicalAuditLogsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$clinicalAuditLogsHash();

  @$internal
  @override
  $StreamProviderElement<List<Map<String, dynamic>>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Map<String, dynamic>>> create(Ref ref) {
    return clinicalAuditLogs(ref);
  }
}

String _$clinicalAuditLogsHash() => r'9309da2d6d3df9fbad7197548981b13fe5c6a8d5';

@ProviderFor(doctorDashboardStats)
final doctorDashboardStatsProvider = DoctorDashboardStatsProvider._();

final class DoctorDashboardStatsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, int>>,
          Map<String, int>,
          FutureOr<Map<String, int>>
        >
    with $FutureModifier<Map<String, int>>, $FutureProvider<Map<String, int>> {
  DoctorDashboardStatsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'doctorDashboardStatsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$doctorDashboardStatsHash();

  @$internal
  @override
  $FutureProviderElement<Map<String, int>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, int>> create(Ref ref) {
    return doctorDashboardStats(ref);
  }
}

String _$doctorDashboardStatsHash() =>
    r'b2cc4c10ebf298d413a79413adab701219f3db99';

@ProviderFor(clinicalReports)
final clinicalReportsProvider = ClinicalReportsProvider._();

final class ClinicalReportsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Map<String, dynamic>>>,
          List<Map<String, dynamic>>,
          Stream<List<Map<String, dynamic>>>
        >
    with
        $FutureModifier<List<Map<String, dynamic>>>,
        $StreamProvider<List<Map<String, dynamic>>> {
  ClinicalReportsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'clinicalReportsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$clinicalReportsHash();

  @$internal
  @override
  $StreamProviderElement<List<Map<String, dynamic>>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Map<String, dynamic>>> create(Ref ref) {
    return clinicalReports(ref);
  }
}

String _$clinicalReportsHash() => r'f112ec0eacd470ca844778f82109b1f8f785595b';
