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
        isAutoDispose: false,
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

String _$alarmNotifierHash() => r'afdcd29214fd14e843e86722f28fea185b1ff880';

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
    extends $NotifierProvider<BatteryNotifier, PowerState> {
  BatteryNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'batteryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$batteryNotifierHash();

  @$internal
  @override
  BatteryNotifier create() => BatteryNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PowerState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PowerState>(value),
    );
  }
}

String _$batteryNotifierHash() => r'beec3d4765d45ac077f3a300236f92b4d66f003a';

abstract class _$BatteryNotifier extends $Notifier<PowerState> {
  PowerState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<PowerState, PowerState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PowerState, PowerState>,
              PowerState,
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

String _$infusionNotifierHash() => r'282c4ecf363979cb163690c23708cfa11c4093ee';

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
