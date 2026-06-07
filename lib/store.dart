class CacheStore {
  static final Map<String, String> _store= <String, String>{};

  CacheStore();

  bool exists(String key) => _store.containsKey(key);

  int length() => _store.length;

  String put(String key, String value) {
    _store[key] = value;
    return key;
  }

  String? get(String key) => _store[key];
  
  String? delete(String key) => _store.remove(key);
}
