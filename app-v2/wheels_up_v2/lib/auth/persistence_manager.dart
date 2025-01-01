
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pocketbase/pocketbase.dart';

abstract class RecordAuthPersistenceManager {
  Future<void> save(RecordAuth record);
  Future<RecordAuth?> get();
  Future<void> clear();
}

class SecureStoragePersistenceManager implements RecordAuthPersistenceManager {
  final FlutterSecureStorage _storage;
  final _storageKey = 'record_auth';

  const SecureStoragePersistenceManager(this._storage);

  @override
  Future<RecordAuth?> get() async {
    String? recordJson = await _storage.read(key: _storageKey);
    if (recordJson != null) {
      return RecordAuth.fromJson(jsonDecode(recordJson));
    }

    return null;
  }

  @override
  Future<void> save(RecordAuth record) {
    final String recordJson = jsonEncode(record.toJson());
    return _storage.write(key: _storageKey, value: recordJson);
  }

  @override
  Future<void> clear() {
    return _storage.delete(key: _storageKey);
  }
}

class InMemoryPersistenceManager implements RecordAuthPersistenceManager {
  final Map<String, String> _storage = {};
  final _storageKey = 'record_auth';

  @override
  Future<void> save(RecordAuth record) async {
    final String recordJson = jsonEncode(record.toJson());
    _storage[_storageKey] = recordJson;
  }

  @override
  Future<RecordAuth?> get() async {
    if (_storage[_storageKey] == null) {
      return null;
    }

    return RecordAuth.fromJson(jsonDecode(_storage[_storageKey]!));
  }

  @override
  Future<void> clear() async => _storage.remove(_storageKey);
}
