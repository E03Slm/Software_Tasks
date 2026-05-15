// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(adminRepository)
final adminRepositoryProvider = AdminRepositoryProvider._();

final class AdminRepositoryProvider
    extends
        $FunctionalProvider<AdminRepository, AdminRepository, AdminRepository>
    with $Provider<AdminRepository> {
  AdminRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminRepositoryHash();

  @$internal
  @override
  $ProviderElement<AdminRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AdminRepository create(Ref ref) {
    return adminRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AdminRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AdminRepository>(value),
    );
  }
}

String _$adminRepositoryHash() => r'a2ece64091677da3a5ac7fdee8fa4defa150a051';

@ProviderFor(adminUserList)
final adminUserListProvider = AdminUserListProvider._();

final class AdminUserListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ManagedUser>>,
          List<ManagedUser>,
          Stream<List<ManagedUser>>
        >
    with
        $FutureModifier<List<ManagedUser>>,
        $StreamProvider<List<ManagedUser>> {
  AdminUserListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminUserListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminUserListHash();

  @$internal
  @override
  $StreamProviderElement<List<ManagedUser>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<ManagedUser>> create(Ref ref) {
    return adminUserList(ref);
  }
}

String _$adminUserListHash() => r'9714b11c92fb923557ea65bf354a0afabcc9657d';

@ProviderFor(adminAuditLogs)
final adminAuditLogsProvider = AdminAuditLogsProvider._();

final class AdminAuditLogsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<AuditLog>>,
          List<AuditLog>,
          FutureOr<List<AuditLog>>
        >
    with $FutureModifier<List<AuditLog>>, $FutureProvider<List<AuditLog>> {
  AdminAuditLogsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminAuditLogsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminAuditLogsHash();

  @$internal
  @override
  $FutureProviderElement<List<AuditLog>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<AuditLog>> create(Ref ref) {
    return adminAuditLogs(ref);
  }
}

String _$adminAuditLogsHash() => r'd83810000431061f593d19194c3afb0a836e1fe4';

@ProviderFor(systemStats)
final systemStatsProvider = SystemStatsProvider._();

final class SystemStatsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, dynamic>>,
          Map<String, dynamic>,
          FutureOr<Map<String, dynamic>>
        >
    with
        $FutureModifier<Map<String, dynamic>>,
        $FutureProvider<Map<String, dynamic>> {
  SystemStatsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'systemStatsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$systemStatsHash();

  @$internal
  @override
  $FutureProviderElement<Map<String, dynamic>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, dynamic>> create(Ref ref) {
    return systemStats(ref);
  }
}

String _$systemStatsHash() => r'd0ad8730b36d4fdab240c56c0dd5a0eb345e0fb3';

@ProviderFor(UserSearchQuery)
final userSearchQueryProvider = UserSearchQueryProvider._();

final class UserSearchQueryProvider
    extends $NotifierProvider<UserSearchQuery, String> {
  UserSearchQueryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userSearchQueryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userSearchQueryHash();

  @$internal
  @override
  UserSearchQuery create() => UserSearchQuery();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$userSearchQueryHash() => r'38f56d2c73f4c65761bb5eca5abe7985758c975e';

abstract class _$UserSearchQuery extends $Notifier<String> {
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
