import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';

import '../providers/auth_provider.dart';
import '../../../core/errors/exceptions.dart';
import '../../../services/auth_service.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey   = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl  = TextEditingController();
  bool _obscure    = true;
  String? _errorMsg;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _tryBiometric());
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _tryBiometric() async {
    final service   = ref.read(authServiceProvider);
    final enabled   = await service.isBiometricEnabled();
    final available = await service.isBiometricAvailable();
    if (!enabled || !available || !mounted) return;

    final ok = await service.authenticateWithBiometric(
      reason: 'Use biometrics to sign in',
    );
    if (ok && mounted) {
      ref.invalidate(authNotifierProvider);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _errorMsg = null);

    // Capture notifier BEFORE async gap
    final notifier = ref.read(authNotifierProvider.notifier);
    await notifier.login(_emailCtrl.text.trim(), _passCtrl.text);

    if (!mounted) return;

    final authState = ref.read(authNotifierProvider);
    authState.whenOrNull(
      error: (e, _) => setState(() =>
      _errorMsg = e is AuthException ? e.message : 'Login failed. Try again.'),
    );

    if (mounted && authState.valueOrNull?.isLoggedIn == true) {
      _offerBiometricSetup();
    }
  }

  Future<void> _offerBiometricSetup() async {
    final service   = ref.read(authServiceProvider);
    final available = await service.isBiometricAvailable();
    final enabled   = await service.isBiometricEnabled();
    if (!available || enabled || !mounted) return;

    final biometrics = await service.getAvailableBiometrics();
    if (!mounted) return;

    final label = _biometricLabel(biometrics);

    // Capture notifier BEFORE dialog (async gap ahead)
    final notifier = ref.read(authNotifierProvider.notifier);

    final enable = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog( // ✅ 1. Name the dialog's context
        title: Text('Enable $label?'),
        content: Text(
          'Sign in faster next time using your $label instead of your password.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false), // ✅ 2. Use it here
            child: const Text('Not now'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true), // ✅ 3. And here
            child: const Text('Enable'),
          ),
        ],
      ),
    );

    if (enable == true) {
      await notifier.enableBiometric();
    }
  }

  String _biometricLabel(List<BiometricType> types) {
    if (types.contains(BiometricType.face))        return 'Face ID';
    if (types.contains(BiometricType.fingerprint)) return 'Fingerprint';
    if (types.contains(BiometricType.iris))        return 'Iris scan';
    return 'Biometrics';
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authNotifierProvider).isLoading;
    final cs        = Theme.of(context).colorScheme;
    final tt        = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Logo ─────────────────────────────────────────────────
                  Center(
                    child: Container(
                      width: 80, height: 80,
                      decoration: BoxDecoration(
                        color: cs.primaryContainer,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(Icons.engineering_rounded,
                          size: 48, color: cs.primary),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text('FieldPulse',
                      textAlign: TextAlign.center,
                      style: tt.headlineLarge
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text('Sign in to your account',
                      textAlign: TextAlign.center,
                      style: tt.bodyMedium
                          ?.copyWith(color: cs.onSurfaceVariant)),
                  const SizedBox(height: 40),

                  // ── Error banner ──────────────────────────────────────────
                  if (_errorMsg != null) ...[
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: cs.errorContainer,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(children: [
                        Icon(Icons.error_outline,
                            color: cs.onErrorContainer, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(_errorMsg!,
                              style:
                              TextStyle(color: cs.onErrorContainer)),
                        ),
                      ]),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // ── Email ─────────────────────────────────────────────────
                  TextFormField(
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    autocorrect: false,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      hintText:  'tech@fieldpulse.com',
                      prefixIcon:
                      Icon(Icons.email_outlined, color: cs.primary),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor:
                      cs.surfaceContainerHighest.withValues(alpha: 0.4),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty)
                        return 'Email is required';
                      if (!v.contains('@')) return 'Enter a valid email';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // ── Password ──────────────────────────────────────────────
                  TextFormField(
                    controller: _passCtrl,
                    obscureText: _obscure,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _submit(),
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon:
                      Icon(Icons.lock_outlined, color: cs.primary),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscure
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: cs.onSurfaceVariant,
                        ),
                        onPressed: () =>
                            setState(() => _obscure = !_obscure),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor:
                      cs.surfaceContainerHighest.withValues(alpha: 0.4),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty)
                        return 'Password is required';
                      if (v.length < 6) return 'Minimum 6 characters';
                      return null;
                    },
                  ),
                  const SizedBox(height: 28),

                  // ── Sign In button ────────────────────────────────────────
                  FilledButton(
                    onPressed: isLoading ? null : _submit,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(52),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: isLoading
                        ? const SizedBox(
                        height: 22, width: 22,
                        child: CircularProgressIndicator(
                            strokeWidth: 2.5, color: Colors.white))
                        : const Text('Sign In',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(height: 16),

                  // ── Biometric quick-unlock (only if enabled) ──────────────
                  Consumer(builder: (_, r, __) {
                    final available =
                        r.watch(biometricAvailableProvider).valueOrNull ??
                            false;
                    final enabled =
                        r.watch(biometricEnabledProvider).valueOrNull ??
                            false;
                    if (!available || !enabled) return const SizedBox.shrink();

                    return OutlinedButton.icon(
                      onPressed: _tryBiometric,
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.fingerprint),
                      label: const Text('Use Biometrics'),
                    );
                  }),

                  const SizedBox(height: 24),
                  Center(
                    child: Text(
                      'Demo: tech@fieldpulse.com / password123',
                      style: tt.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant.withValues(alpha: 0.6)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}