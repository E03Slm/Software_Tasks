import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'providers/auth_provider.dart';
import '../../../core/providers/connection_provider.dart';
import '../domain/enums/role_type.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _nationalIdController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _handleLogin() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final success = await ref.read(authProvider.notifier).login(
      _nationalIdController.text.trim(),
      _passwordController.text.trim(),
    );

    if (success) {
      if (mounted) {
        final role = ref.read(roleProvider);
        if (role == RoleType.doctor || role == RoleType.admin) {
          context.go('/doctor');
        } else {
          context.go('/nurse');
        }
      }
    } else {
      if (mounted) {
        setState(() {
          _errorMessage = 'Invalid National ID or password. Please try again.';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Logo/Icon
                    const Icon(
                      Icons.local_hospital_rounded,
                      size: 64,
                      color: Color(0xFF005EA4),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'SMART INFUSION',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF191C21),
                        letterSpacing: 1.2,
                      ),
                    ),
                    const Text(
                      'PUMP SIMULATOR',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF43474F),
                        letterSpacing: 4,
                      ),
                    ),
                    const SizedBox(height: 48),
                    
                    if (_errorMessage != null)
                      Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 24),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(color: Colors.red.shade800, fontSize: 13),
                          textAlign: TextAlign.center,
                        ),
                      ),

                    TextField(
                      controller: _nationalIdController,
                      decoration: InputDecoration(
                        labelText: 'National ID',
                        prefixIcon: const Icon(Icons.badge_outlined),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                      ),
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outline_rounded),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 32),
                    
                    SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF005EA4),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 0,
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                'LOGIN',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.1),
                              ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextButton(
                      onPressed: () {},
                      child: const Text('Forgot Password?', style: TextStyle(color: Color(0xFF43474F))),
                    ),
                    const Divider(),
                    const SizedBox(height: 8),
                    Consumer(
                      builder: (context, ref, child) {
                        final connection = ref.watch(connectionStatusProvider);
                        return connection.when(
                          data: (isConnected) => Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                isConnected ? Icons.check_circle : Icons.error,
                                size: 16,
                                color: isConnected ? Colors.green : Colors.red,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                isConnected ? 'Connected to Supabase' : 'Database Connection Failed',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isConnected ? Colors.green : Colors.red,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          loading: () => const Center(child: SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2))),
                          error: (err, stack) => Column(
                            children: [
                              const Icon(Icons.error, size: 16, color: Colors.red),
                              const SizedBox(height: 4),
                              Text(
                                'Error: $err',
                                style: const TextStyle(fontSize: 10, color: Colors.red),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
