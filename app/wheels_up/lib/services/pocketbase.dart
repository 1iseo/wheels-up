import 'package:pocketbase/pocketbase.dart';
import 'package:wheels_up/config/api_config.dart';

class PocketbaseSingleton {
  static final PocketbaseSingleton _singleton = PocketbaseSingleton._internal();

  // TODO: Use flutter_secure_storage as authStore (AsyncAuthStore)
  PocketBase pocketbase = PocketBase(ApiConfig.pocketbaseUrl);

  factory PocketbaseSingleton() => _singleton;

  PocketbaseSingleton._internal();
}
