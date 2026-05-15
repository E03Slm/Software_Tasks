// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patients_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(patients)
final patientsProvider = PatientsProvider._();

final class PatientsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ManagedUser>>,
          List<ManagedUser>,
          FutureOr<List<ManagedUser>>
        >
    with
        $FutureModifier<List<ManagedUser>>,
        $FutureProvider<List<ManagedUser>> {
  PatientsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'patientsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$patientsHash();

  @$internal
  @override
  $FutureProviderElement<List<ManagedUser>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ManagedUser>> create(Ref ref) {
    return patients(ref);
  }
}

String _$patientsHash() => r'287dd9075525dedfc195dde1700e60cea1fb1956';
