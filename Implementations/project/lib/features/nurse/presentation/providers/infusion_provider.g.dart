// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'infusion_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AlarmNotifier)
final alarmProvider = AlarmNotifierProvider._();

final class AlarmNotifierProvider
    extends $NotifierProvider<AlarmNotifier, List<Alarm>> {
  AlarmNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'alarmProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$alarmNotifierHash();

  @$internal
  @override
  AlarmNotifier create() => AlarmNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Alarm> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Alarm>>(value),
    );
  }
}

String _$alarmNotifierHash() => r'2471772623189e6c1d9af4881b7262dbc156da4c';

abstract class _$AlarmNotifier extends $Notifier<List<Alarm>> {
  List<Alarm> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<List<Alarm>, List<Alarm>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<Alarm>, List<Alarm>>,
              List<Alarm>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(BatteryNotifier)
final batteryProvider = BatteryNotifierProvider._();

final class BatteryNotifierProvider
    extends $NotifierProvider<BatteryNotifier, double> {
  BatteryNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'batteryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$batteryNotifierHash();

  @$internal
  @override
  BatteryNotifier create() => BatteryNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(double value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<double>(value),
    );
  }
}

String _$batteryNotifierHash() => r'95ab247f111297b13419a61c7d986d7d9f5b281e';

abstract class _$BatteryNotifier extends $Notifier<double> {
  double build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<double, double>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<double, double>,
              double,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(InfusionNotifier)
final infusionProvider = InfusionNotifierProvider._();

final class InfusionNotifierProvider
    extends $NotifierProvider<InfusionNotifier, InfusionSession> {
  InfusionNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'infusionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$infusionNotifierHash();

  @$internal
  @override
  InfusionNotifier create() => InfusionNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InfusionSession value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InfusionSession>(value),
    );
  }
}

String _$infusionNotifierHash() => r'fdedd9a31589a73bdbb2ff9e076926fb2f2cce63';

abstract class _$InfusionNotifier extends $Notifier<InfusionSession> {
  InfusionSession build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<InfusionSession, InfusionSession>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<InfusionSession, InfusionSession>,
              InfusionSession,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
