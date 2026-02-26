import 'dart:io' show Platform;

import 'package:flutter/services.dart';

class NativeBridge {
  static const _channel = MethodChannel('com.openyapper/native');

  static bool get _isMacOS => Platform.isMacOS;

  static Future<T?> _invokeOptional<T>(
    String method, [
    dynamic arguments,
  ]) async {
    if (!_isMacOS) return null;
    try {
      return await _channel.invokeMethod<T>(method, arguments);
    } on MissingPluginException {
      // Gracefully degrade when the native side isn't implemented (e.g. Windows).
      return null;
    }
  }

  static final NativeBridge instance = NativeBridge._();
  NativeBridge._();

  VoidCallback? _onHotkeyStart;
  VoidCallback? _onHotkeyStop;
  VoidCallback? _onHotkeyHoldDown;
  VoidCallback? _onHotkeyHoldUp;
  VoidCallback? _onCancelRequested;

  /// Set up callbacks for global hotkeys.
  void setHotkeyCallbacks({
    required VoidCallback onStart,
    required VoidCallback onStop,
    required VoidCallback onHoldDown,
    required VoidCallback onHoldUp,
  }) {
    _onHotkeyStart = onStart;
    _onHotkeyStop = onStop;
    _onHotkeyHoldDown = onHoldDown;
    _onHotkeyHoldUp = onHoldUp;
    _installChannelHandler();
  }

  /// Set up the callback for when the user taps the escape button on the overlay.
  void setCancelCallback(VoidCallback onCancel) {
    _onCancelRequested = onCancel;
    _installChannelHandler();
  }

  void _installChannelHandler() {
    _channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'onHotkeyStart':
          _onHotkeyStart?.call();
          break;
        case 'onHotkeyStop':
          _onHotkeyStop?.call();
          break;
        case 'onHotkeyHoldDown':
          _onHotkeyHoldDown?.call();
          break;
        case 'onHotkeyHoldUp':
          _onHotkeyHoldUp?.call();
          break;
        case 'onCancelRequested':
          _onCancelRequested?.call();
          break;
      }
      return null;
    });
  }

  /// Apply hotkey configuration to the native listener.
  Future<void> setHotkeyConfig({
    required int startKeyCode,
    required int startFlags,
    required int stopKeyCode,
    required int stopFlags,
    required int holdKeyCode,
    required int holdFlags,
    required bool startEnabled,
    required bool stopEnabled,
    required bool holdEnabled,
  }) async {
    await _invokeOptional<void>('setHotkeyConfig', {
      'startKeyCode': startKeyCode,
      'startFlags': startFlags,
      'stopKeyCode': stopKeyCode,
      'stopFlags': stopFlags,
      'holdKeyCode': holdKeyCode,
      'holdFlags': holdFlags,
      'startEnabled': startEnabled,
      'stopEnabled': stopEnabled,
      'holdEnabled': holdEnabled,
    });
  }

  /// Capture the next key press and return keyCode and flags.
  /// Used when remapping hotkeys in settings.
  Future<Map<String, int>> captureNextHotkey() async {
    if (!_isMacOS) {
      throw UnsupportedError(
        'Hotkey capture is only supported on macOS at the moment.',
      );
    }
    final result =
        await _invokeOptional<Map<dynamic, dynamic>>('captureNextHotkey');
    if (result == null) {
      throw Exception('Failed to capture hotkey');
    }
    return {
      'keyCode': result['keyCode'] as int,
      'flags': result['flags'] as int,
    };
  }

  Future<void> startHotkeyListener() async {
    await _invokeOptional<void>('startHotkeyListener');
  }

  Future<void> stopHotkeyListener() async {
    await _invokeOptional<void>('stopHotkeyListener');
  }

  Future<void> setStopHotkeyEnabled(bool enabled) async {
    await _invokeOptional<void>(
      'setStopHotkeyEnabled',
      {'enabled': enabled},
    );
  }

  Future<void> pasteText(String text, {bool restoreClipboard = true}) async {
    if (!_isMacOS) {
      // On non-macOS platforms, fall back to copying the text to the clipboard.
      await Clipboard.setData(ClipboardData(text: text));
      return;
    }
    await _invokeOptional<void>('pasteText', {
      'text': text,
      'restoreClipboard': restoreClipboard,
    });
  }

  Future<String?> getFrontmostAppName() async {
    if (!_isMacOS) return 'Default';
    return await _invokeOptional<String>('getFrontmostAppName');
  }

  /// Returns list of installed apps with name and base64 PNG icon.
  /// Each map: {name: String, path: String, iconBase64: String}
  Future<List<Map<String, dynamic>>> getInstalledApps() async {
    final result = await _invokeOptional<List<dynamic>>('getInstalledApps');
    if (result == null) return [];
    return result
        .map(
          (e) => (e as Map<dynamic, dynamic>).map(
            (k, v) => MapEntry(k.toString(), v),
          ),
        )
        .map((m) => Map<String, dynamic>.from(m))
        .toList();
  }

  Future<bool> checkAccessibility() async {
    if (!_isMacOS) {
      // Windows and other platforms don't use macOS Accessibility APIs.
      return true;
    }
    return await _invokeOptional<bool>('checkAccessibility') ?? true;
  }

  Future<bool> requestAccessibility() async {
    if (!_isMacOS) {
      // Nothing to request on non-macOS; treat as granted.
      return true;
    }
    return await _invokeOptional<bool>('requestAccessibility') ?? true;
  }

  Future<bool> checkMicrophonePermission() async {
    if (!_isMacOS) {
      // The record plugin manages microphone permissions on other platforms.
      return true;
    }
    return await _invokeOptional<bool>('checkMicrophonePermission') ?? true;
  }

  Future<void> openAccessibilitySettings() async {
    if (!_isMacOS) return;
    await _invokeOptional<void>('openAccessibilitySettings');
  }

  Future<void> openMicrophoneSettings() async {
    if (!_isMacOS) return;
    await _invokeOptional<void>('openMicrophoneSettings');
  }

  /// Restart the app (needed after granting Accessibility - macOS doesn't detect it until restart).
  Future<void> restartApp() async {
    if (!_isMacOS) return;
    await _invokeOptional<void>('restartApp');
  }

  Future<void> showRecordingOverlay() async {
    await _invokeOptional<void>('showRecordingOverlay');
  }

  Future<void> updateOverlayState(
    String state, {
    int? charCount,
    double? duration,
  }) async {
    final args = <String, dynamic>{'state': state};
    if (charCount != null) args['charCount'] = charCount;
    if (duration != null) args['duration'] = duration;
    await _invokeOptional<void>('updateOverlayState', args);
  }

  Future<void> updateOverlayLevel(double level) async {
    await _invokeOptional<void>('updateOverlayLevel', {'level': level});
  }

  Future<void> updateOverlayDuration(double duration) async {
    await _invokeOptional<void>(
      'updateOverlayDuration',
      {'duration': duration},
    );
  }

  Future<void> dismissRecordingOverlay() async {
    await _invokeOptional<void>('dismissRecordingOverlay');
  }

  Future<void> keychainSave(String key, String value) async {
    await _invokeOptional<void>(
      'keychainSave',
      {'key': key, 'value': value},
    );
  }

  Future<String?> keychainLoad(String key) async {
    return await _invokeOptional<String>(
      'keychainLoad',
      {'key': key},
    );
  }

  /// Trigger native updater UI (Sparkle on macOS).
  Future<void> checkForNativeUpdates() async {
    if (!_isMacOS) return;
    await _invokeOptional<void>('checkForNativeUpdates');
  }
}
