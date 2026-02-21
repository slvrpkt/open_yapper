import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../services/native_bridge.dart';
import '../services/recording_service.dart';
import '../services/settings_storage.dart';
import '../widgets/pasteable_text_field.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    super.key,
    required this.recordingService,
    required this.onHotKeyChanged,
  });

  final RecordingService recordingService;
  final VoidCallback onHotKeyChanged;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _apiKeyController = TextEditingController();
  bool _apiKeyObscured = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final key = await loadGeminiApiKey();
    if (mounted) {
      setState(() {
        _apiKeyController.text = key ?? '';
      });
    }
  }

  Future<void> _saveApiKey() async {
    await saveGeminiApiKey(_apiKeyController.text);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('API key saved')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListenableBuilder(
      listenable: widget.recordingService,
      builder: (context, _) {
        final recordingService = widget.recordingService;
        return ListView(
          padding: const EdgeInsets.all(24),
          children: [
            _Section(
              title: 'Gemini API Key',
              icon: Symbols.key,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Required for voice-to-AI processing. Get a key at https://aistudio.google.com/apikey',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: PasteableTextField(
                          controller: _apiKeyController,
                          obscureText: _apiKeyObscured,
                          decoration: InputDecoration(
                            hintText: 'Enter your Gemini API key',
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _apiKeyObscured
                                    ? Symbols.visibility
                                    : Symbols.visibility_off,
                                size: 20,
                              ),
                              onPressed: () {
                                setState(
                                    () => _apiKeyObscured = !_apiKeyObscured);
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      FilledButton(
                        onPressed: _saveApiKey,
                        child: const Text('Save'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Stored securely in macOS Keychain',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant.withValues(
                        alpha: 0.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _Section(
              title: 'Global Hotkey',
              icon: Symbols.keyboard,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Press the hotkey to start or stop recording. Works even when the app is in the background.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '⌥ Space (Option + Space)',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Hotkey customization coming in a future update.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant.withValues(
                        alpha: 0.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _Section(
              title: 'Permissions',
              icon: Symbols.shield,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _PermissionRow(
                    label: 'Microphone',
                    granted: recordingService.hasPermission,
                    onFix: () => NativeBridge.instance.openMicrophoneSettings(),
                  ),
                  const SizedBox(height: 8),
                  _PermissionRow(
                    label: 'Accessibility',
                    granted: recordingService.accessibilityGranted,
                    onFix: () =>
                        NativeBridge.instance.openAccessibilitySettings(),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _PermissionRow extends StatelessWidget {
  const _PermissionRow({
    required this.label,
    required this.granted,
    required this.onFix,
  });

  final String label;
  final bool granted;
  final VoidCallback onFix;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(
          granted ? Symbols.check_circle : Symbols.error,
          color: granted ? theme.colorScheme.primary : theme.colorScheme.error,
          size: 18,
        ),
        const SizedBox(width: 8),
        Text(label, style: theme.textTheme.bodyLarge),
        const Spacer(),
        if (!granted)
          FilledButton.tonal(
            onPressed: onFix,
            child: const Text('Open Settings'),
          ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.icon,
    required this.child,
  });

  final String title;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 24,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}
