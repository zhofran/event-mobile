import 'dart:convert';
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

/// A singleton class for managing SharedPreferences operations.
///
/// This class provides a centralized way to handle all SharedPreferences
/// operations throughout the app. It must be initialized at app startup
/// using [SharedPreferencesManager.init()].
///
/// Example usage:
/// ```dart
/// // Initialize at app startup (e.g., in main.dart)
/// await SharedPreferencesManager.init();
///
/// // Write data
/// await SharedPreferencesManager.instance.write('username', 'john_doe');
/// await SharedPreferencesManager.instance.writeInt('age', 25);
/// await SharedPreferencesManager.instance.writeBool('isLoggedIn', true);
///
/// // Read data
/// final username = SharedPreferencesManager.instance.read('username');
/// final age = SharedPreferencesManager.instance.readInt('age');
/// final isLoggedIn = SharedPreferencesManager.instance.readBool('isLoggedIn');
///
/// // Delete data
/// await SharedPreferencesManager.instance.delete('username');
///
/// // Clear all data
/// await SharedPreferencesManager.instance.clear();
/// ```
class  SharedPreferencesManager {
  SharedPreferencesManager._();

  static SharedPreferencesManager? _instance;
  static SharedPreferences? _prefs;

  /// Gets the singleton instance of SharedPreferencesManager.
  ///
  /// Throws an error if [init()] hasn't been called first.
  static SharedPreferencesManager get instance {
    if (_instance == null) {
      throw Exception(
        'SharedPreferencesManager is not initialized. '
        'Call SharedPreferencesManager.init() first.',
      );
    }
    return _instance!;
  }

  /// Initializes the SharedPreferences instance.
  ///
  /// This must be called at app startup, typically in main.dart
  /// before runApp() is called.
  ///
  /// Returns the singleton instance of SharedPreferencesManager.
  static Future<SharedPreferencesManager> init() async {
    if (_instance == null) {
      _instance = SharedPreferencesManager._();
      _prefs = await SharedPreferences.getInstance();
    }
    return _instance!;
  }

  /// Returns true if the SharedPreferencesManager has been initialized.
  static bool get isInitialized => _instance != null && _prefs != null;

  // ==================== Write Operations ====================

  /// Writes a String value to SharedPreferences.
  Future<bool> write(String key, String value) async {
    log('Writing String - key: "$key", value: "$value"', name: 'prefs');
    final result = await _prefs!.setString(key, value);
    log('Write String ${result ? "success" : "failed"} - key: "$key"', name: 'prefs');
    return result;
  }

  /// Writes an int value to SharedPreferences.
  Future<bool> writeInt(String key, int value) async {
    log('Writing Int - key: "$key", value: $value', name: 'prefs');
    final result = await _prefs!.setInt(key, value);
    log('Write Int ${result ? "success" : "failed"} - key: "$key"', name: 'prefs');
    return result;
  }

  /// Writes a double value to SharedPreferences.
  Future<bool> writeDouble(String key, double value) async {
    log('Writing Double - key: "$key", value: $value', name: 'prefs');
    final result = await _prefs!.setDouble(key, value);
    log('Write Double ${result ? "success" : "failed"} - key: "$key"', name: 'prefs');
    return result;
  }

  /// Writes a bool value to SharedPreferences.
  Future<bool> writeBool(String key, bool value) async {
    log('Writing Bool - key: "$key", value: $value', name: 'prefs');
    final result = await _prefs!.setBool(key, value);
    log('Write Bool ${result ? "success" : "failed"} - key: "$key"', name: 'prefs');
    return result;
  }

  /// Writes a List<String> to SharedPreferences.
  Future<bool> writeStringList(String key, List<String> value) async {
    log('Writing StringList - key: "$key", items: ${value.length}', name: 'prefs');
    final result = await _prefs!.setStringList(key, value);
    log('Write StringList ${result ? "success" : "failed"} - key: "$key"', name: 'prefs');
    return result;
  }

  /// Writes an object to SharedPreferences as JSON string.
  ///
  /// The object must have a `toJson()` method that returns a Map<String, dynamic>.
  ///
  /// Example:
  /// ```dart
  /// await prefs.writeObject('user', userModel);
  /// ```
  Future<bool> writeObject<T>(String key, T object) async {
    try {
      log('Writing Object<$T> - key: "$key"', name: 'prefs');
      // Call toJson() method on the object
      final json = (object as dynamic).toJson() as Map<String, dynamic>;
      final jsonString = jsonEncode(json);
      final result = await _prefs!.setString(key, jsonString);
      log('Write Object<$T> ${result ? "success" : "failed"} - key: "$key"', name: 'prefs');
      return result;
    } catch (e) {
      log('Write Object<$T> error - key: "$key", error: $e', name: 'prefs');
      throw Exception(
        'Failed to write object. Make sure the object has a toJson() method. Error: $e',
      );
    }
  }

  /// Writes a list of objects to SharedPreferences as JSON string.
  ///
  /// Each object must have a `toJson()` method that returns a Map<String, dynamic>.
  ///
  /// Example:
  /// ```dart
  /// await prefs.writeObjectList('users', [user1, user2, user3]);
  /// ```
  Future<bool> writeObjectList<T>(String key, List<T> objects) async {
    try {
      log('Writing ObjectList<$T> - key: "$key", items: ${objects.length}', name: 'prefs');
      final jsonList = objects
          .map((obj) => (obj as dynamic).toJson() as Map<String, dynamic>)
          .toList();
      final jsonString = jsonEncode(jsonList);
      final result = await _prefs!.setString(key, jsonString);
      log('Write ObjectList<$T> ${result ? "success" : "failed"} - key: "$key"', name: 'prefs');
      return result;
    } catch (e) {
      log('Write ObjectList<$T> error - key: "$key", error: $e', name: 'prefs');
      throw Exception(
        'Failed to write object list. Make sure each object has a toJson() method. Error: $e',
      );
    }
  }

  // ==================== Read Operations ====================

  /// Reads a String value from SharedPreferences.
  ///
  /// Returns null if the key doesn't exist.
  String? read(String key) {
    log('Reading String - key: "$key"', name: 'prefs');
    final result = _prefs!.getString(key);
    log('Read String ${result != null ? "found" : "not found"} - key: "$key"', name: 'prefs');
    return result;
  }

  /// Reads an int value from SharedPreferences.
  ///
  /// Returns null if the key doesn't exist.
  int? readInt(String key) {
    log('Reading Int - key: "$key"', name: 'prefs');
    final result = _prefs!.getInt(key);
    log('Read Int ${result != null ? "found: $result" : "not found"} - key: "$key"', name: 'prefs');
    return result;
  }

  /// Reads a double value from SharedPreferences.
  ///
  /// Returns null if the key doesn't exist.
  double? readDouble(String key) {
    log('Reading Double - key: "$key"', name: 'prefs');
    final result = _prefs!.getDouble(key);
    log('Read Double ${result != null ? "found: $result" : "not found"} - key: "$key"', name: 'prefs');
    return result;
  }

  /// Reads a bool value from SharedPreferences.
  ///
  /// Returns null if the key doesn't exist.
  bool? readBool(String key) {
    log('Reading Bool - key: "$key"', name: 'prefs');
    final result = _prefs!.getBool(key);
    log('Read Bool ${result != null ? "found: $result" : "not found"} - key: "$key"', name: 'prefs');
    return result;
  }

  /// Reads a List<String> from SharedPreferences.
  ///
  /// Returns null if the key doesn't exist.
  List<String>? readStringList(String key) {
    log('Reading StringList - key: "$key"', name: 'prefs');
    final result = _prefs!.getStringList(key);
    log('Read StringList ${result != null ? "found: ${result.length} items" : "not found"} - key: "$key"', name: 'prefs');
    return result;
  }

  /// Reads an object from SharedPreferences.
  ///
  /// The [fromJson] parameter is a factory function that creates an instance
  /// of type T from a Map<String, dynamic>.
  ///
  /// Returns null if the key doesn't exist.
  ///
  /// Example:
  /// ```dart
  /// final user = prefs.readObject('user', (json) => UserModel.fromJson(json));
  /// ```
  T? readObject<T>(String key, T Function(Map<String, dynamic>) fromJson) {
    try {
      log('Reading Object<$T> - key: "$key"', name: 'prefs');
      final jsonString = _prefs!.getString(key);
      if (jsonString == null) {
        log('Read Object<$T> not found - key: "$key"', name: 'prefs');
        return null;
      }

      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      final result = fromJson(json);
      log('Read Object<$T> success - key: "$key"', name: 'prefs');
      return result;
    } catch (e) {
      log('Read Object<$T> error - key: "$key", error: $e', name: 'prefs');
      throw Exception(
        'Failed to read object from key "$key". Error: $e',
      );
    }
  }

  /// Reads a list of objects from SharedPreferences.
  ///
  /// The [fromJson] parameter is a factory function that creates an instance
  /// of type T from a Map<String, dynamic>.
  ///
  /// Returns null if the key doesn't exist.
  ///
  /// Example:
  /// ```dart
  /// final users = prefs.readObjectList('users', (json) => UserModel.fromJson(json));
  /// ```
  List<T>? readObjectList<T>(
      String key, T Function(Map<String, dynamic>) fromJson) {
    try {
      log('Reading ObjectList<$T> - key: "$key"', name: 'prefs');
      final jsonString = _prefs!.getString(key);
      if (jsonString == null) {
        log('Read ObjectList<$T> not found - key: "$key"', name: 'prefs');
        return null;
      }

      final jsonList = jsonDecode(jsonString) as List<dynamic>;
      final result = jsonList
          .map((json) => fromJson(json as Map<String, dynamic>))
          .toList();
      log('Read ObjectList<$T> success - key: "$key", items: ${result.length}', name: 'prefs');
      return result;
    } catch (e) {
      log('Read ObjectList<$T> error - key: "$key", error: $e', name: 'prefs');
      throw Exception(
        'Failed to read object list from key "$key". Error: $e',
      );
    }
  }

  /// Reads a value with a default fallback.
  ///
  /// If the key doesn't exist, returns [defaultValue].
  T readWithDefault<T>(String key, T defaultValue) {
    if (T == String) {
      return (_prefs!.getString(key) ?? defaultValue) as T;
    } else if (T == int) {
      return (_prefs!.getInt(key) ?? defaultValue) as T;
    } else if (T == double) {
      return (_prefs!.getDouble(key) ?? defaultValue) as T;
    } else if (T == bool) {
      return (_prefs!.getBool(key) ?? defaultValue) as T;
    } else {
      throw UnsupportedError('Type $T is not supported');
    }
  }

  // ==================== Check Operations ====================

  /// Checks if a key exists in SharedPreferences.
  bool containsKey(String key) {
    return _prefs!.containsKey(key);
  }

  /// Gets all keys stored in SharedPreferences.
  Set<String> getAllKeys() {
    return _prefs!.getKeys();
  }

  // ==================== Delete Operations ====================

  /// Deletes a specific key from SharedPreferences.
  Future<bool> delete(String key) async {
    log('Deleting key: "$key"', name: 'prefs');
    final result = await _prefs!.remove(key);
    log('Delete ${result ? "success" : "failed"} - key: "$key"', name: 'prefs');
    return result;
  }

  /// Deletes multiple keys from SharedPreferences.
  Future<void> deleteMultiple(List<String> keys) async {
    log('Deleting multiple keys: ${keys.length} items', name: 'prefs');
    for (final key in keys) {
      await _prefs!.remove(key);
      log('Deleted key: "$key"', name: 'prefs');
    }
    log('Delete multiple completed', name: 'prefs');
  }

  /// Clears all data from SharedPreferences.
  Future<bool> clear() async {
    log('Clearing all SharedPreferences data', name: 'prefs');
    final result = await _prefs!.clear();
    log('Clear ${result ? "success" : "failed"}', name: 'prefs');
    return result;
  }

  // ==================== Reload Operation ====================

  /// Reloads data from SharedPreferences storage.
  ///
  /// This is useful when you want to sync with changes made by
  /// other instances or after a clear operation.
  Future<void> reload() async {
    await _prefs!.reload();
  }
}
