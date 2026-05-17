import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';

class SessionTimeoutWrapper extends ConsumerStatefulWidget {
  final Widget child;
  const SessionTimeoutWrapper({super.key, required this.child});

  @override
  ConsumerState<SessionTimeoutWrapper> createState() => _SessionTimeoutWrapperState();
}

class _SessionTimeoutWrapperState extends ConsumerState<SessionTimeoutWrapper> {
  Timer? _inactivityTimer;
  Timer? _countdownTimer;
  
  // Set total timeout to 15 minutes, warning duration to 60 seconds
  static const Duration timeoutDuration = Duration(minutes: 15);
  static const Duration warningDuration = Duration(seconds: 60);
  
  bool _isWarningVisible = false;
  int _secondsLeft = 60;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _resetInactivityTimer();
    });
  }

  void _resetInactivityTimer() {
    _inactivityTimer?.cancel();
    _countdownTimer?.cancel();
    
    if (mounted) {
      setState(() {
        _isWarningVisible = false;
        _secondsLeft = warningDuration.inSeconds;
      });
    }

    // Only run the timer if a user is logged in
    final authUser = ref.read(authProvider);
    if (authUser == null) return;

    _inactivityTimer = Timer(timeoutDuration - warningDuration, _showWarning);
  }

  void _showWarning() {
    if (!mounted) return;
    
    setState(() {
      _isWarningVisible = true;
      _secondsLeft = warningDuration.inSeconds;
    });
    
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      
      if (_secondsLeft > 0) {
        setState(() {
          _secondsLeft--;
        });
      } else {
        timer.cancel();
        _logout();
      }
    });
  }

  void _logout() {
    _inactivityTimer?.cancel();
    _countdownTimer?.cancel();
    
    if (mounted) {
      setState(() {
        _isWarningVisible = false;
      });
    }
    
    // Trigger logout
    ref.read(authProvider.notifier).logout();
  }

  void _handleUserInteraction(PointerEvent _) {
    final authUser = ref.read(authProvider);
    if (authUser != null) {
      if (_isWarningVisible) {
        // Do not auto-reset if the warning is visible. 
        // User MUST explicitly click "Stay logged in" to reset the session.
      } else {
        _resetInactivityTimer();
      }
    }
  }

  @override
  void dispose() {
    _inactivityTimer?.cancel();
    _countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Listen to auth changes to start/stop timers immediately
    ref.listen(authProvider, (previous, next) {
      if (next == null) {
        _inactivityTimer?.cancel();
        _countdownTimer?.cancel();
        if (mounted && _isWarningVisible) {
           setState(() => _isWarningVisible = false);
        }
      } else if (previous == null && next != null) {
        _resetInactivityTimer();
      }
    });

    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: _handleUserInteraction,
      onPointerMove: _handleUserInteraction,
      onPointerUp: _handleUserInteraction,
      child: Stack(
        children: [
          widget.child,
          if (_isWarningVisible)
            Positioned(
              top: MediaQuery.of(context).padding.top + 16,
              left: 16,
              right: 16,
              child: Material(
                elevation: 12,
                borderRadius: BorderRadius.circular(12),
                color: Colors.red.shade900,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 32),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Session Timeout Warning',
                              style: TextStyle(
                                color: Colors.white, 
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              'Inactivity detected. Logging out in $_secondsLeft seconds',
                              style: const TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _resetInactivityTimer,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.red.shade900,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          minimumSize: Size.zero,
                        ),
                        child: const Text('Stay logged in', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
