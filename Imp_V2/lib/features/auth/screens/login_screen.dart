import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../auth_repository.dart';
import '../../../core/theme.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await ref.read(authRepositoryProvider.notifier).login(
            _emailController.text.trim(),
            _passwordController.text.trim(),
          );
      // Redirect handled by GoRouter
    } catch (e) {
      setState(() => _error = 'Login failed. Please check your credentials.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(spaceLg),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo/Icon
                const Icon(
                  Icons.monitor_heart,
                  size: 80,
                  color: Color(0xFF005EA4),
                ),
                const SizedBox(height: spaceMd),
                Text(
                  'Smart Infusion',
                  textAlign: TextAlign.center,
                  style: h1Style.copyWith(color: const Color(0xFF005EA4)),
                ),
                Text(
                  'Simulator v2.0',
                  textAlign: TextAlign.center,
                  style: captionStyle,
                ),
                const SizedBox(height: spaceXl),

                if (_error != null)
                  Container(
                    padding: const EdgeInsets.all(spaceSm),
                    margin: const EdgeInsets.only(bottom: spaceMd),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(spaceSm),
                      border: Border.all(color: Colors.red),
                    ),
                    child: Text(
                      _error!,
                      style: bodyStyle.copyWith(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),

                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'National ID',
                    prefixIcon: Icon(Icons.badge_outlined),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: spaceMd),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock_outline),
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  autofillHints: const [AutofillHints.password],
                ),
                const SizedBox(height: spaceLg),

                ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: spaceMd),
                    backgroundColor: const Color(0xFF005EA4),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(spaceSm),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('SIGN IN'),
                ),
                
                const SizedBox(height: spaceXl),
                Text(
                  'Clinical Use Only. System access is monitored.',
                  textAlign: TextAlign.center,
                  style: captionStyle.copyWith(fontSize: 10),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
