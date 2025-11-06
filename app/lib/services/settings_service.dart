import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/avatar_settings.dart';

class SettingsService {
  static const String _settingsKey = 'avatar_settings';
  static SettingsService? _instance;
  static SettingsService get instance => _instance ??= SettingsService._();
  
  SettingsService._();
  
  AvatarSettings _settings = AvatarSettings();
  AvatarSettings get settings => _settings;
  
  Future<void> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = prefs.getString(_settingsKey);
      if (settingsJson != null) {
        final map = jsonDecode(settingsJson) as Map<String, dynamic>;
        _settings = AvatarSettings.fromJson(map);
      }
    } catch (e) {
      debugPrint('Error loading settings: $e');
      // Use defaults if loading fails
      _settings = AvatarSettings();
    }
  }
  
  Future<void> save() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = jsonEncode(_settings.toJson());
      await prefs.setString(_settingsKey, settingsJson);
    } catch (e) {
      debugPrint('Error saving settings: $e');
    }
  }
  
  Future<void> update(AvatarSettings newSettings) async {
    _settings = newSettings;
    await save();
  }
}

