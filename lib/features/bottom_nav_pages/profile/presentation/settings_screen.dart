
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:to_do/core/services/biometric_auth_service.dart';
import 'package:to_do/core/services/auth_service.dart';

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
      // User wants to enable biometric
      final authenticated = await _biometricService.authenticate(
        reason: 'Authenticate to enable fingerprint login',
      );

      if (authenticated) {
        // Check if we need to ask for password to save credentials
        final user = FirebaseAuth.instance.currentUser;

        if (user == null) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please sign in first to enable fingerprint login'),
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
                const SnackBar(
                  content: Text('Password is required to enable fingerprint login'),
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
                const SnackBar(
                  content: Text('Incorrect password. Please try again.'),
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
            const SnackBar(
              content: Text('Fingerprint login enabled'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Authentication failed'),
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
          const SnackBar(
            content: Text('Fingerprint login disabled'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  Future<String?> _showPasswordDialog() async {
    final controller = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enter Your Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'To enable fingerprint login, please enter your password. It will be stored securely on your device.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock_outline),
              ),
              autofocus: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(null),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(controller.text),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Security Section
          _buildSectionHeader(context, 'Security'),
          const SizedBox(height: 8),
          _buildSecurityCard(context),
          const SizedBox(height: 24),

          // Appearance Section
          _buildSectionHeader(context, 'Appearance'),
          const SizedBox(height: 8),
          _buildThemeCard(context),
          const SizedBox(height: 24),

          // Notifications Section (Placeholder for future)
          _buildSectionHeader(context, 'Notifications'),
          const SizedBox(height: 8),
          _buildNotificationsCard(context),
          const SizedBox(height: 24),

          // General Section (Placeholder for future)
          _buildSectionHeader(context, 'General'),
          const SizedBox(height: 8),
          _buildGeneralCard(context),
          const SizedBox(height: 24),

          // About Section
          _buildSectionHeader(context, 'About'),
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
          leading: Icon(
            Icons.fingerprint,
            color: Colors.grey,
          ),
          title: const Text('Fingerprint Login'),
          subtitle: const Text('Not available on this device'),
        ),
      );
    }

    return Card(
      child: SwitchListTile(
        title: const Text('Fingerprint Login'),
        subtitle: Text(
          _isBiometricEnabled
              ? 'Use fingerprint to quickly access your account'
              : 'Enable fingerprint authentication',
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

  Widget _buildThemeCard(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(
          Icons.palette_outlined,
          color: Theme.of(context).colorScheme.primary,
        ),
        title: const Text('Theme Color'),
        subtitle: const Text('Lavender Purple (Dark Mode)'),
        trailing: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            shape: BoxShape.circle,
            border: Border.all(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationsCard(BuildContext context) {
    return Card(
      child: Column(
        children: [
          SwitchListTile(
            title: const Text('Push Notifications'),
            subtitle: Text(
              'Receive task reminders',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            secondary: Icon(
              Icons.notifications_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
            value: true,
            onChanged: (value) {
              // TODO: Implement notifications toggle
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Notifications feature coming soon!'),
                  duration: Duration(seconds: 2),
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
              Icons.schedule_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: const Text('Default Reminder Time'),
            subtitle: const Text('30 minutes before'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // TODO: Implement reminder time picker
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Reminder settings coming soon!'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGeneralCard(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: Icon(
              Icons.language_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: const Text('Language'),
            subtitle: const Text('English'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // TODO: Implement language selection
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Language selection coming soon!'),
                  duration: Duration(seconds: 2),
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
              Icons.storage_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: const Text('Clear Cache'),
            subtitle: const Text('Free up storage space'),
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
            title: const Text('App Version'),
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
            title: const Text('Privacy Policy'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // TODO: Show privacy policy
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Privacy policy coming soon!'),
                  duration: Duration(seconds: 2),
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
            title: const Text('Terms of Service'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // TODO: Show terms of service
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Terms of service coming soon!'),
                  duration: Duration(seconds: 2),
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
      builder: (context) => AlertDialog(
        title: const Text('Clear Cache'),
        content: const Text(
          'Are you sure you want to clear the app cache? This will not delete your tasks or data.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Cache cleared successfully!'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: Text(
              'Clear',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }
}
