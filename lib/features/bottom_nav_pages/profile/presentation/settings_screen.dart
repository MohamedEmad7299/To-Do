
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do/core/services/biometric_auth_service.dart';
import 'package:to_do/core/services/auth_service.dart';
import 'package:to_do/core/locale/locale_bloc.dart';
import 'package:to_do/core/locale/locale_event.dart';
import 'package:to_do/core/locale/locale_state.dart';
import 'package:to_do/core/services/locale_service.dart';
import 'package:to_do/l10n/app_localizations.dart';
import '../../tasks/presentation/bloc/task_bloc.dart';
import '../../tasks/presentation/bloc/task_event.dart';
import 'privacy_policy_screen.dart';
import 'terms_of_service_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final BiometricAuthService _biometricService = BiometricAuthService();
  final AuthService _authService = AuthService();
  bool _isBiometricAvailable = false;
  bool _isBiometricEnabled = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkBiometricStatus();
  }

  Future<void> _checkBiometricStatus() async {
    final isAvailable = await _biometricService.isBiometricAvailable();
    final isEnabled = await _biometricService.isBiometricEnabled();

    setState(() {
      _isBiometricAvailable = isAvailable;
      _isBiometricEnabled = isEnabled;
      _isLoading = false;
    });
  }

  Future<void> _toggleBiometric(bool value) async {
    if (value) {

      final authenticated = await _biometricService.authenticate(
        reason: 'Authenticate to enable fingerprint login',
      );

      if (authenticated) {
        // Check if we need to ask for password to save credentials
        final user = FirebaseAuth.instance.currentUser;

        if (user == null) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppLocalizations.of(context)!.pleaseSignInFirst),
                backgroundColor: Colors.red,
              ),
            );
          }
          return;
        }

        // Check if user signed in with email/password
        final isEmailProvider = user.providerData.any((info) => info.providerId == 'password');

        if (isEmailProvider) {
          // Ask for password to save it securely
          final password = await _showPasswordDialog();

          if (password == null || password.isEmpty) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppLocalizations.of(context)!.passwordRequired),
                  backgroundColor: Colors.orange,
                ),
              );
            }
            return;
          }

          // Verify the password is correct by trying to sign in
          try {
            await _authService.signIn(
              email: user.email!,
              password: password,
            );

            // Password is correct, save credentials
            await _biometricService.saveCredentials(
              email: user.email!,
              password: password,
            );
            await _biometricService.saveAuthMethod(AuthMethod.email);
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppLocalizations.of(context)!.incorrectPassword),
                  backgroundColor: Colors.red,
                ),
              );
            }
            return;
          }
        } else {
          // User signed in with Google or Facebook
          // Determine which provider
          final isGoogleProvider = user.providerData.any((info) => info.providerId == 'google.com');
          final isFacebookProvider = user.providerData.any((info) => info.providerId == 'facebook.com');

          if (isGoogleProvider) {
            await _biometricService.saveAuthMethod(AuthMethod.google);
          } else if (isFacebookProvider) {
            await _biometricService.saveAuthMethod(AuthMethod.facebook);
          }

          await _biometricService.saveLastUserEmail(user.email!);
        }

        await _biometricService.setBiometricEnabled(true);
        setState(() {
          _isBiometricEnabled = true;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.fingerprintEnabled),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.authenticationFailed),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } else {
      // User wants to disable biometric
      await _biometricService.setBiometricEnabled(false);
      await _biometricService.clearAuthData();
      setState(() {
        _isBiometricEnabled = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.fingerprintDisabled),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  Future<String?> _showPasswordDialog() async {
    final controller = TextEditingController();
    bool hasPasswordText = false;
    bool obscurePassword = true;

    return showDialog<String>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(AppLocalizations.of(dialogContext)!.enterYourPassword),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.of(dialogContext)!.passwordDialogMessage,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                obscureText: obscurePassword,
                onChanged: (value) {
                  setState(() {
                    hasPasswordText = value.isNotEmpty;
                  });
                },
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(dialogContext)!.password,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: hasPasswordText
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.highlight_remove,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              onPressed: () {
                                controller.clear();
                                setState(() {
                                  hasPasswordText = false;
                                });
                              },
                            ),
                            Container(
                              width: 1,
                              height: 24,
                              color: Colors.grey.shade400,
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                            ),
                            IconButton(
                              icon: Icon(
                                obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              onPressed: () {
                                setState(() {
                                  obscurePassword = !obscurePassword;
                                });
                              },
                            ),
                          ],
                        )
                      : IconButton(
                          icon: Icon(
                            obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                        ),
                ),
                autofocus: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(controller.text),
              child: Text(AppLocalizations.of(context)!.confirm),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Security Section
          _buildSectionHeader(context, AppLocalizations.of(context)!.security),
          const SizedBox(height: 8),
          _buildSecurityCard(context),
          const SizedBox(height: 24),

          // General Section (Placeholder for future)
          _buildSectionHeader(context, AppLocalizations.of(context)!.general),
          const SizedBox(height: 8),
          _buildGeneralCard(context),
          const SizedBox(height: 24),

          // About Section
          _buildSectionHeader(context, AppLocalizations.of(context)!.about),
          const SizedBox(height: 8),
          _buildAboutCard(context),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }

  Widget _buildSecurityCard(BuildContext context) {
    if (_isLoading) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    if (!_isBiometricAvailable) {
      return Card(
        child: ListTile(
          leading: const Icon(
            Icons.fingerprint,
            color: Colors.grey,
          ),
          title: Text(AppLocalizations.of(context)!.fingerprintLogin),
          subtitle: Text(AppLocalizations.of(context)!.notAvailableOnDevice),
        ),
      );
    }

    return Card(
      child: SwitchListTile(
        title: Text(AppLocalizations.of(context)!.fingerprintLogin),
        subtitle: Text(
          _isBiometricEnabled
              ? AppLocalizations.of(context)!.fingerprintDescription
              : AppLocalizations.of(context)!.enableFingerprint,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        secondary: Icon(
          Icons.fingerprint,
          color: Theme.of(context).colorScheme.primary,
        ),
        value: _isBiometricEnabled,
        onChanged: _toggleBiometric,
      ),
    );
  }



  Widget _buildGeneralCard(BuildContext context) {
    return Card(
      child: Column(
        children: [
          BlocBuilder<LocaleBloc, LocaleState>(
            builder: (context, localeState) {
              return ListTile(
                leading: Icon(
                  Icons.language_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: Text(AppLocalizations.of(context)!.language),
                subtitle: Text(LocaleService.getLocaleDisplayName(localeState.locale)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  _showLanguageDialog(context);
                },
              );
            },
          ),
          Divider(
            height: 1,
            indent: 16,
            endIndent: 16,
            color: Theme.of(context).dividerColor,
          ),
          ListTile(
            leading: Icon(
              Icons.storage_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: Text(AppLocalizations.of(context)!.clearCache),
            subtitle: Text(AppLocalizations.of(context)!.freeUpStorage),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              _showClearCacheDialog(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAboutCard(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: Icon(
              Icons.info_outline,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: Text(AppLocalizations.of(context)!.appVersion),
            subtitle: const Text('1.0.0'),
          ),
          Divider(
            height: 1,
            indent: 16,
            endIndent: 16,
            color: Theme.of(context).dividerColor,
          ),
          ListTile(
            leading: Icon(
              Icons.policy_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: Text(AppLocalizations.of(context)!.privacyPolicy),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PrivacyPolicyScreen(),
                ),
              );
            },
          ),
          Divider(
            height: 1,
            indent: 16,
            endIndent: 16,
            color: Theme.of(context).dividerColor,
          ),
          ListTile(
            leading: Icon(
              Icons.description_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: Text(AppLocalizations.of(context)!.termsOfService),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TermsOfServiceScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showClearCacheDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.clearAllTasks),
        content: Text(
          AppLocalizations.of(context)!.clearAllTasksMessage,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              AppLocalizations.of(context)!.cancel,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () {
              context.read<TaskBloc>().add(DeleteAllTasksEvent());
              Navigator.of(dialogContext).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppLocalizations.of(context)!.allTasksCleared),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: Text(
              AppLocalizations.of(context)!.clearAll,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final currentLocale = context.read<LocaleBloc>().state.locale;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.language),
        content: RadioGroup<Locale>(
          groupValue: currentLocale,
          onChanged: (Locale? value) {
            if (value != null) {
              context.read<LocaleBloc>().add(ChangeLocaleEvent(value));
              Navigator.of(dialogContext).pop();
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<Locale>(
                title: Text(AppLocalizations.of(context)!.english),
                value: LocaleService.englishLocale,
                activeColor: Theme.of(context).colorScheme.primary,
              ),
              RadioListTile<Locale>(
                title: Text(AppLocalizations.of(context)!.arabic),
                value: LocaleService.arabicLocale,
                activeColor: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
        ],
      ),
    );
  }
}
