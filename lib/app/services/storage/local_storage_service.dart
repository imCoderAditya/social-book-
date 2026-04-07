// ignore: depend_on_referenced_packages
import 'package:get_storage/get_storage.dart';
import 'package:social_book/app/core/config/theme/app_colors.dart';
import 'package:social_book/app/services/storage/storage_keys.dart';

class LocalStorageService {
  static final _storage = GetStorage();

  /// Write any value to local storage
  static Future<void> write(String key, dynamic value) async {
    await _storage.write(key, value);
  }

  /// Read value from local storage
  static T? read<T>(String key) {
    return _storage.read<T>(key);
  }

  /// Remove a key
  static Future<void> remove(String key) async {
    await _storage.remove(key);
  }

  /// Clear all storage (use carefully!)
  static Future<void> clear() async {
    await _storage.erase();
  }

  // -----------------------------
  // 🔒 Common Use Functions (optional)
  // -----------------------------

  static bool isLoggedIn() => read<bool>(StorageKeys.isLoggedIn) ?? false;

  static int? getUserId() => read<int>(StorageKeys.userId);
  static String? getProfileType() => read<String>(StorageKeys.profileType);
  static int? getProfileId() => read<int>(StorageKeys.profileId);

  static String? getToken() => read<String>(StorageKeys.token);
  static String? getRefreshToken() => read<String>(StorageKeys.refreshToken);

  // static int? getSocialProfileId() =>
  //     read<int>(StorageKeys.userSocialProfileId);
  // static int? getProfessionalProfileId() =>
  //     read<int>(StorageKeys.userProfessionalProfileId);
  // static int? getHiddenProfileId() =>
  //     read<int>(StorageKeys.userHiddenProfileId);
  // static int? getMatrimonialProfileId() =>
  //     read<int>(StorageKeys.userMatrimonialProfileId);

  static Future<void> saveLogin({
    required int userId,
    String? token,
    String? refreshToken,
    int? userSocialProfileId,
    int? userProfessionalProfileId,
    int? userHiddenProfileId,
    int? userMatrimonialProfileId,
  }) async {
    await write(StorageKeys.userId, userId);
    await write(StorageKeys.token, token);
    await write(StorageKeys.refreshToken, refreshToken);

    await write(StorageKeys.isLoggedIn, true);
  }

  static Future<void>? setToken(String? token) async {
    await write(StorageKeys.token, token);
  }

  static Future<void>? setProfileType(String? profileType) async {
    await write(StorageKeys.profileType, profileType);
  }

  static Future<void>? setProfileId(int? profileId) async {
    await write(StorageKeys.profileId, profileId);
  }

  static Future<void> logout() async {
    await remove(StorageKeys.userId);

    // await remove(StorageKeys.userHiddenProfileId);
    // await remove(StorageKeys.userProfessionalProfileId);
    // await remove(StorageKeys.userSocialProfileId);
    // await remove(StorageKeys.userMatrimonialProfileId);
    await remove(StorageKeys.token);
    await remove(StorageKeys.refreshToken);
    await write(StorageKeys.isLoggedIn, false);
  }

  /// SET + STORE + Color
  static Future<void> setPrimaryColor(String hexColor) async {
    AppColors.primaryColor = hexToColor(hexColor); // set Color primaryColor
    AppColors.accentColor = AppColors.primaryColor.withValues(
      alpha: 0.5,
    ); // set Color accentColor
    await LocalStorageService.write(StorageKeys.primaryColor, hexColor);
  }

  /// GET + STORE + Color
  static Future<void> loadPrimaryColor() async {
    final hex = LocalStorageService.read<String>(StorageKeys.primaryColor);
    if (hex != null && hex.isNotEmpty) {
      AppColors.primaryColor = hexToColor(hex);
      AppColors.accentColor = AppColors.primaryColor.withValues(alpha: 0.5);
    }
  }
}
