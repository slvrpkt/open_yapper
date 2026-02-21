import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _hotkeyStorageKey = 'record_hotkey';

/// Default: Cmd+Shift+Space on macOS.
HotKey get defaultRecordHotKey => HotKey(
      key: PhysicalKeyboardKey.space,
      modifiers: [HotKeyModifier.meta, HotKeyModifier.shift],
      scope: HotKeyScope.system,
    );

/// Ensures the hotkey uses system scope for global registration.
HotKey _withSystemScope(HotKey hotKey) {
  return HotKey(
    key: hotKey.key,
    modifiers: hotKey.modifiers,
    scope: HotKeyScope.system,
  );
}

Future<HotKey> loadRecordHotKey() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_hotkeyStorageKey);
    if (jsonStr == null) return defaultRecordHotKey;

    final map = jsonDecode(jsonStr) as Map<String, dynamic>;
    return _withSystemScope(HotKey.fromJson(map));
  } catch (_) {
    return defaultRecordHotKey;
  }
}

Future<void> saveRecordHotKey(HotKey hotKey) async {
  try {
    final normalized = _withSystemScope(hotKey);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_hotkeyStorageKey, jsonEncode(normalized.toJson()));
  } catch (_) {
    // Silently ignore
  }
}
