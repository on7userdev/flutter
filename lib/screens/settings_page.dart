import 'package:flutter/material.dart';
import 'package:beacon_bloom/state/app_state.dart';
import 'package:beacon_bloom/services/user_storage_service.dart';
import 'package:beacon_bloom/models/user.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _userService = UserStorageService();
  User? _user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await _userService.loadUser();
    if (mounted) setState(() => _user = user);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme;
    final appState = AppState.I;

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: theme.textTheme.titleLarge),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          children: [
            // Profile card
            _DecoratedCard(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: color.secondary.withValues(alpha: 0.2),
                    backgroundImage: _user?.avatarUrl.isNotEmpty == true
                        ? NetworkImage(_user!.avatarUrl)
                        : null,
                    child: _user?.avatarUrl.isEmpty == true || _user == null
                        ? Icon(Icons.person, color: color.secondary)
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _user?.name ?? 'Guest',
                          style: theme.textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _user?.email ?? 'Sign in to personalize',
                          style: theme.textTheme.bodySmall
                              ?.copyWith(color: color.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Appearance
            Text('Appearance',
                style: theme.textTheme.titleSmall
                    ?.copyWith(color: color.onSurfaceVariant)),
            const SizedBox(height: 10),
            _DecoratedCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.brightness_6, color: color.primary),
                      const SizedBox(width: 10),
                      Text('Theme', style: theme.textTheme.titleMedium),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ValueListenableBuilder<ThemeMode>(
                    valueListenable: appState.themeMode,
                    builder: (context, mode, _) {
                      return SegmentedButton<ThemeMode>(
                        style: ButtonStyle(
                          visualDensity:
                              const VisualDensity(horizontal: -2, vertical: -2),
                        ),
                        segments: const [
                          ButtonSegment(
                            value: ThemeMode.system,
                            label: Text('System'),
                            icon: Icon(Icons.auto_mode),
                          ),
                          ButtonSegment(
                            value: ThemeMode.light,
                            label: Text('Light'),
                            icon: Icon(Icons.light_mode),
                          ),
                          ButtonSegment(
                            value: ThemeMode.dark,
                            label: Text('Dark'),
                            icon: Icon(Icons.dark_mode),
                          ),
                        ],
                        selected: {mode},
                        onSelectionChanged: (selection) {
                          final next = selection.first;
                          appState.setThemeMode(next);
                        },
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Preferences
            Text('Preferences',
                style: theme.textTheme.titleSmall
                    ?.copyWith(color: color.onSurfaceVariant)),
            const SizedBox(height: 10),
            _DecoratedCard(
              child: Column(
                children: [
                  SwitchListTile.adaptive(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    title: Text('Notifications',
                        style: theme.textTheme.titleMedium),
                    subtitle: Text('Get updates for events you follow',
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: color.onSurfaceVariant)),
                    secondary: Icon(Icons.notifications_active,
                        color: color.secondary),
                    value: appState.notificationsEnabled,
                    onChanged: (v) => setState(() {
                      appState.setNotificationsEnabled(v);
                    }),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // About
            Text('About',
                style: theme.textTheme.titleSmall
                    ?.copyWith(color: color.onSurfaceVariant)),
            const SizedBox(height: 10),
            _DecoratedCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info, color: color.tertiary),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(" ",
                                style: theme.textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w600)),
                            const SizedBox(height: 4),
                            Text('Version 1.0.0',
                                style: theme.textTheme.bodySmall
                                    ?.copyWith(color: color.onSurfaceVariant)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'We craft delightful event experiences that help people connect with unforgettable moments nearby. Our mission is to make discovery effortless and inspiring.',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _ChipButton(
                        icon: Icons.description,
                        label: 'Licenses',
                        onTap: () => showLicensePage(
                          context: context,
                          applicationName: 'Beacon Bloom',
                          applicationVersion: '1.0.0',
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DecoratedCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const _DecoratedCard({required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.symmetric(vertical: 6),
        child: child,
      ),
    );
  }
}

class _ChipButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ChipButton(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: color.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color.primary, size: 18),
            const SizedBox(width: 8),
            Text(label,
                style: TextStyle(
                    color: color.primary, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
