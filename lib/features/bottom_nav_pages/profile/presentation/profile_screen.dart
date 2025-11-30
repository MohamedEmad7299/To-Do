
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:to_do/core/services/auth_service.dart';
import 'package:to_do/core/services/firestore_service.dart';
import 'package:to_do/core/services/storage_service.dart';
import 'package:to_do/core/routing/routes.dart';
import 'package:to_do/core/theme/theme_bloc.dart';
import 'package:to_do/core/theme/theme_event.dart';
import 'package:to_do/core/theme/theme_state.dart';
import 'package:to_do/core/widgets/color_picker_dialog.dart';
import 'package:to_do/l10n/app_localizations.dart';
import '../../../../generated/assets.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with WidgetsBindingObserver {
  final AuthService _authService = AuthService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();
  final StorageService _storageService = StorageService();
  String _displayName = 'User';
  String? _photoUrl;
  int _tasksLeft = 0;
  int _tasksDone = 0;
  StreamSubscription? _taskSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadUserData();
    _loadTaskCounts();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadUserData();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _taskSubscription?.cancel();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    print('ProfilePage: Loading user data...');
    final user = _auth.currentUser;
    if (user != null) {
      final localImagePath = await _storageService.getProfileImagePath();
      print('ProfilePage: Local image path: $localImagePath');
      print('ProfilePage: User photoURL: ${user.photoURL}');

      setState(() {
        _displayName = user.displayName ?? user.email?.split('@')[0] ?? 'User';
        // Use local storage path if available, otherwise fallback to photoURL
        _photoUrl = localImagePath ?? user.photoURL;
        print('ProfilePage: Set _photoUrl to: $_photoUrl');
      });
    }
  }

  Future<void> _navigateToChangeAccountImage() async {
    await context.push(Routes.changeAccountImage);
    imageCache.clear();
    imageCache.clearLiveImages();

    await _auth.currentUser?.reload();
    await _loadUserData();
  }

  void _loadTaskCounts() {
    _taskSubscription = _firestoreService.getUserTasks().listen((tasks) {
      if (mounted) {
        final pendingTasks = tasks.where((task) => !task.isCompleted).length;
        final completedTasks = tasks.where((task) => task.isCompleted).length;

        setState(() {
          _tasksLeft = pendingTasks;
          _tasksDone = completedTasks;
        });
      }
    });
  }

  Future<void> _navigateToChangeAccountName() async {
    final result = await context.push(Routes.changeAccountName);
    if (result == true) {
      _loadUserData();
    }
  }

  Future<void> _handleChangeThemeColor(BuildContext context) async {
    final themeBloc = context.read<ThemeBloc>();
    final currentColor = themeBloc.state.primaryColor;

    final selectedColor = await showDialog<Color>(
      context: context,
      builder: (BuildContext dialogContext) {
        return ColorPickerDialog(currentColor: currentColor);
      },
    );

    if (selectedColor != null && selectedColor != currentColor) {
      themeBloc.add(ChangeThemeColorEvent(selectedColor));
    }
  }

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          title: Text(
            AppLocalizations.of(context)!.logoutConfirmTitle,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          content: Text(
            AppLocalizations.of(context)!.logoutConfirmMessage,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text(
                AppLocalizations.of(context)!.cancel,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();

                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext loadingContext) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                );

                try {
                  await _authService.signOut();

                  if (context.mounted) {
                    Navigator.of(context).pop();

                    context.go(Routes.login);
                  }
                } catch (e) {
                  // Close loading indicator
                  if (context.mounted) {
                    Navigator.of(context).pop();

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(AppLocalizations.of(context)!.logoutFailed(e.toString())),
                        backgroundColor: Theme.of(context).colorScheme.error,
                      ),
                    );
                  }
                }
              },
              child: Text(
                AppLocalizations.of(context)!.logout,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          AppLocalizations.of(context)!.profile,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Profile Image
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.primary,
              ),
              child: ClipOval(
                child: _photoUrl != null && _photoUrl!.isNotEmpty
                    ? Image.file(
                        File(_photoUrl!),
                        key: ValueKey(_photoUrl), // Force rebuild when path changes
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          print('ProfilePage: Error loading image: $error');
                          return const Icon(Icons.person, size: 50, color: Colors.white);
                        },
                      )
                    : const Icon(Icons.person, size: 50, color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _displayName,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Theme.of(context).dividerColor,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            _tasksLeft == 1
                                ? '$_tasksLeft ${AppLocalizations.of(context)!.tasksLeft}'
                                : '$_tasksLeft ${AppLocalizations.of(context)!.tasksLeftPlural}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Theme.of(context).dividerColor,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            _tasksDone == 1
                                ? '$_tasksDone ${AppLocalizations.of(context)!.tasksDone}'
                                : '$_tasksDone ${AppLocalizations.of(context)!.tasksDonePlural}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppLocalizations.of(context)!.settings,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
            ),
            const SizedBox(height: 12),
            _buildMenuItem(
              context: context,
              icon: Assets.svgsSetting,
              title: AppLocalizations.of(context)!.appSettings,
              onTap: () {
                context.push(Routes.settings);
              },
            ),
            BlocBuilder<ThemeBloc, ThemeState>(
              builder: (context, themeState) {
                return _buildMenuItemWithColor(
                  context: context,
                  icon: Icons.palette,
                  title: AppLocalizations.of(context)!.themeColor,
                  onTap: () => _handleChangeThemeColor(context),
                  currentColor: themeState.primaryColor,
                );
              },
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppLocalizations.of(context)!.account,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
            ),
            const SizedBox(height: 12),
            _buildMenuItem(
              context: context,
              icon: Assets.svgsUser,
              title: AppLocalizations.of(context)!.changeAccountName,
              onTap: _navigateToChangeAccountName,
            ),
            _buildMenuItem(
              context: context,
              icon: Assets.svgsKey,
              title: AppLocalizations.of(context)!.changeAccountPassword,
              onTap: () {
                context.push(Routes.changePassword);
              },
            ),
            _buildMenuItem(
              context: context,
              icon: Assets.svgsCamera,
              title: AppLocalizations.of(context)!.changeAccountImage,
              onTap: _navigateToChangeAccountImage,
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppLocalizations.of(context)!.uptodo,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
            ),
            const SizedBox(height: 12),
            _buildMenuItem(
              context: context,
              icon: Assets.svgsMenu,
              title: AppLocalizations.of(context)!.aboutUs,
              onTap: () {
                context.push(Routes.aboutUs);
              },
            ),
            _buildMenuItem(
              context: context,
              icon: Assets.svgsInfoCircle,
              title: AppLocalizations.of(context)!.faq,
              onTap: () {
                context.push(Routes.faq);
              },
            ),
            _buildMenuItem(
              context: context,
              icon: Assets.svgsFlash,
              title: AppLocalizations.of(context)!.helpFeedback,
              onTap: () {
                context.push(Routes.help);
              },
            ),
            _buildMenuItem(
              context: context,
              icon: Assets.svgsLike,
              title: AppLocalizations.of(context)!.supportUs,
              onTap: () {
                context.push(Routes.support);
              },
            ),
            const SizedBox(height: 12),
            _buildMenuItem(
              context: context,
              icon: Assets.svgsLogout,
              title: AppLocalizations.of(context)!.logout,
              onTap: () => _handleLogout(context),
              isDestructive: true,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  static Widget _buildMenuItem({
    required BuildContext context,
    required String icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              SvgPicture.asset(
                icon,
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                  isDestructive
                      ? Theme.of(context).colorScheme.error
                      : Theme.of(context).colorScheme.primary,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: isDestructive
                        ? Theme.of(context).colorScheme.error
                        : Theme.of(context).textTheme.bodyLarge?.color,
                    fontSize: 15,
                  ),
                ),
              ),
              if (!isDestructive)
                Icon(
                  Icons.arrow_forward_ios,
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
                  size: 16,
                ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildMenuItemWithColor({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required Color currentColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Icon(
                icon,
                size: 24,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                    fontSize: 15,
                  ),
                ),
              ),
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: currentColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.arrow_forward_ios,
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
