import 'package:test/test.dart';
import 'package:cache_relic/store.dart';

void main() {
  group('store', () {
    test('create a new store', () {
      expect(CacheStore(), isA<CacheStore>());  
    });
    test('insert and deleting keys', () {
      CacheStore s = CacheStore();
      expect(s.length(), equals(0));

      s.put("test", "test");
      expect(s.get("test"), equals("test"));
      expect(s.length(), equals(1));
      expect(s.exists("test"), equals(true));

      s.delete("test");
      expect(s.get("test"), equals(null));
      expect(s.exists("test"), equals(false));
      expect(s.length(), equals(0));
    });
  });
}
