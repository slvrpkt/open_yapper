import 'dart:io' show Platform;

import 'package:shared_preferences/shared_preferences.dart';

import 'native_bridge.dart';

const _geminiApiKeyKey = 'gemini_api_key';

Future<String?> loadGeminiApiKeyFromKeychain() async {
  if (!Platform.isMacOS) {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_geminiApiKeyKey);
    } catch (_) {
      return null;
    }
  }
  try {
    return await NativeBridge.instance.keychainLoad(_geminiApiKeyKey);
  } catch (_) {
    return null;
  }
}

Future<void> saveGeminiApiKeyToKeychain(String key) async {
  final trimmed = key.trim();
  if (!Platform.isMacOS) {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_geminiApiKeyKey, trimmed);
      return;
    } catch (_) {
      return;
    }
  }
  try {
    await NativeBridge.instance.keychainSave(_geminiApiKeyKey, trimmed);
  } catch (_) {
    // Ignore native errors; caller will surface failures via load.
  }
}
