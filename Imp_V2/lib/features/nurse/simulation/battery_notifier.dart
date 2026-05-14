import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'infusion_state_machine.dart';
import 'models/infusion_state.dart';

part 'battery_notifier.g.dart';

@riverpod
class BatteryNotifier extends _$BatteryNotifier {
  Timer? _timer;

  @override
  double build() {
    ref.onDispose(() => _timer?.cancel());
    return 100.0;
  }

  void startDrain() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _drain());
  }

  void stopDrain() {
    _timer?.cancel();
    _timer = null;
  }

  void _drain() {
    state -= 0.1;
    
    if (state <= 0) {
      state = 0;
      stopDrain();
      ref.read(infusionProvider.notifier).emergencyStop();
      return;
    }

    if (state <= 5) {
      // Emergency stop condition from DESIGN.md
      ref.read(infusionProvider.notifier).emergencyStop();
    } else if (state <= 20) {
      // Trigger battery low alarm
      // ref.read(alarmListProvider.notifier).add(AlarmType.batteryLow);
    }
  }

  void charge() {
    stopDrain();
    state = 100.0;
  }
}
