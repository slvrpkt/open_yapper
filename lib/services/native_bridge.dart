import 'package:flutter/services.dart';

class NativeBridge {
  static const _channel = MethodChannel('com.openyapper/native');

  static final NativeBridge instance = NativeBridge._();
  NativeBridge._();

  VoidCallback? _onHotkeyPressed;
  VoidCallback? _onCancelRequested;

  /// Set up the callback for when the global hotkey is pressed.
  /// The native side invokes "onHotkeyPressed" when the user presses the hotkey.
  void setHotkeyCallback(VoidCallback onPressed) {
    _onHotkeyPressed = onPressed;
    _installChannelHandler();
  }

  /// Set up the callback for when the user taps the escape button on the overlay.
  void setCancelCallback(VoidCallback onCancel) {
    _onCancelRequested = onCancel;
    _installChannelHandler();
  }

  void _installChannelHandler() {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'onHotkeyPressed') {
        _onHotkeyPressed?.call();
      } else if (call.method == 'onCancelRequested') {
        _onCancelRequested?.call();
      }
      return null;
    });
  }

  Future<void> startHotkeyListener() async {
    await _channel.invokeMethod('startHotkeyListener');
  }

  Future<void> stopHotkeyListener() async {
    await _channel.invokeMethod('stopHotkeyListener');
  }

  Future<void> pasteText(String text, {bool restoreClipboard = true}) async {
    await _channel.invokeMethod('pasteText', {
      'text': text,
      'restoreClipboard': restoreClipboard,
    });
  }

  Future<String?> getFrontmostAppName() async {
    return await _channel.invokeMethod<String>('getFrontmostAppName');
  }

  /// Returns list of installed apps with name and base64 PNG icon.
  /// Each map: {name: String, path: String, iconBase64: String}
  Future<List<Map<String, dynamic>>> getInstalledApps() async {
    final result = await _channel.invokeMethod<List<dynamic>>('getInstalledApps');
    if (result == null) return [];
    return result
        .map((e) => (e as Map<dynamic, dynamic>).map(
              (k, v) => MapEntry(k.toString(), v),
            ))
        .map((m) => Map<String, dynamic>.from(m))
        .toList();
  }

  Future<bool> checkAccessibility() async {
    return await _channel.invokeMethod<bool>('checkAccessibility') ?? false;
  }

  Future<bool> requestAccessibility() async {
    return await _channel.invokeMethod<bool>('requestAccessibility') ?? false;
  }

  Future<bool> checkMicrophonePermission() async {
    return await _channel.invokeMethod<bool>('checkMicrophonePermission') ??
        false;
  }

  Future<void> openAccessibilitySettings() async {
    await _channel.invokeMethod('openAccessibilitySettings');
  }

  Future<void> openMicrophoneSettings() async {
    await _channel.invokeMethod('openMicrophoneSettings');
  }

  /// Restart the app (needed after granting Accessibility - macOS doesn't detect it until restart).
  Future<void> restartApp() async {
    await _channel.invokeMethod('restartApp');
  }

  Future<void> showRecordingOverlay() async {
    await _channel.invokeMethod('showRecordingOverlay');
  }

  Future<void> updateOverlayState(String state) async {
    await _channel.invokeMethod('updateOverlayState', {'state': state});
  }

  Future<void> updateOverlayLevel(double level) async {
    await _channel.invokeMethod('updateOverlayLevel', {'level': level});
  }

  Future<void> updateOverlayDuration(double duration) async {
    await _channel.invokeMethod('updateOverlayDuration', {'duration': duration});
  }

  Future<void> dismissRecordingOverlay() async {
    await _channel.invokeMethod('dismissRecordingOverlay');
  }

  Future<void> keychainSave(String key, String value) async {
    await _channel.invokeMethod('keychainSave', {'key': key, 'value': value});
  }

  Future<String?> keychainLoad(String key) async {
    return await _channel.invokeMethod<String>('keychainLoad', {'key': key});
  }
}
