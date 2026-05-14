// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AuthRepository)
final authRepositoryProvider = AuthRepositoryProvider._();

final class AuthRepositoryProvider
    extends $NotifierProvider<AuthRepository, AppUser?> {
  AuthRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authRepositoryHash();

  @$internal
  @override
  AuthRepository create() => AuthRepository();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppUser? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppUser?>(value),
    );
  }
}

String _$authRepositoryHash() => r'e380e8962816272103baf63e9ba2ed085012a6aa';

abstract class _$AuthRepository extends $Notifier<AppUser?> {
  AppUser? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AppUser?, AppUser?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AppUser?, AppUser?>,
              AppUser?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(role)
final roleProvider = RoleProvider._();

final class RoleProvider
    extends $FunctionalProvider<RoleType?, RoleType?, RoleType?>
    with $Provider<RoleType?> {
  RoleProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'roleProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$roleHash();

  @$internal
  @override
  $ProviderElement<RoleType?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RoleType? create(Ref ref) {
    return role(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RoleType? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RoleType?>(value),
    );
  }
}

String _$roleHash() => r'056de25750f403b46c5f8e567c50aa86ed1d9b88';
