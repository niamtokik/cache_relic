import 'dart:math';
import 'package:relic/relic.dart';

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
  
  String? delete(String key) => _store[key];

}

class CacheSession {
  final String sessionName;
  final CacheStore cache = CacheStore();  
  static final Map<String, CacheSession> _sessions = <String, CacheSession>{};
 
  factory CacheSession(String id) {
    return _sessions.putIfAbsent(id, () {
      return CacheSession._init(id);
    });
  }

  CacheSession._init(this.sessionName);

  static bool exists(String id) {
    return _sessions.containsKey(id);
  }

  static String? delete(String sessionName) {
    if (_sessions.remove(sessionName) != null) {
      return sessionName;
    }
    return null;
  }

  String toString() => sessionName;
}

String generateSessionId() {
  return Random.secure().nextInt(1<<31).toString();
}

Response newSessionHandler(final Request req) {
  var sessionId = generateSessionId();
  var s = CacheSession(sessionId);
  return Response.ok(
    body: Body.fromString(sessionId),
  );
}

Response getSessionHandler(final Request req) {
  final String sessionId = req.rawPathParameters[#session]!;
  if (CacheSession.exists(sessionId)) {
    return Response.ok(
      body: Body.fromString("")
    );
  }
  return Response.notFound(
    body: Body.fromString("")
  );
}

Response deleteSessionHandler(final Request req) {
  final String sessionId = req.rawPathParameters[#session]!;
  String? id = CacheSession.delete(sessionId);
  if (id != null) {
    return Response.ok(
      body: Body.fromString(id),
    );
  }
  return Response.notFound(
    body: Body.fromString('not found'),
  );
}

/// check if the session id has been defined in the
/// URL path.
Middleware checkSessionId() {
  return (final Handler next) {
    return (final Request req) async {
      final sessionId = req.rawPathParameters[#session];
      if (sessionId == null)
        return Response.badRequest(
          body: Body.fromString('sessionId not defined'),
        );
      return await next(req);
    };
  };
}

/// check if the session id exists in the sessions
/// store.
Middleware checkSessionExists() {
  return (final Handler next) {
    return (final Request req) async {
      final String sessionId = req.rawPathParameters[#session]!;
      if (!CacheSession.exists(sessionId))
        return Response.badRequest(
           body: Body.fromString('sessionId "${sessionId}" does not exist'),
        );
      return await next(req);
    };
  };
}

/// check if the key has been defined in the URL path
Middleware checkKeyExists() {
  return (final Handler next) {
    return (final Request req) async {
      final key = req.rawPathParameters[#key];
      if (key == null)
        return Response.badRequest(
          body: Body.fromString('key not defined'),
        );
      return await next(req);
    };
  };
}

Future<Response> getCacheLengthHandler(final Request req) async {
  final String sessionId = req.rawPathParameters[#session]!;
  final CacheSession s = CacheSession(sessionId)!;

  return Response.ok(
    body: Body.fromString(s.cache.length().toString()),
  );
}

Future<Response> getCacheHandler(final Request req) async {
  final String sessionId = req.rawPathParameters[#session]!;
  final CacheSession s = CacheSession(sessionId)!;
  final key = req.rawPathParameters[#key]!;

  if (!s.cache.exists(key))
    return Response.notFound(
      body: Body.fromString("not found"),
    );

  String? value = s.cache.get(key);

  if (value != null)
    return Response.ok(
      body: Body.fromString(value),
    );
  else
    return Response.ok(
      body: Body.fromString(""),
    );
}

Future<Response> postCacheHandler(final Request req) async {
  final String sessionId = req.rawPathParameters[#session]!;
  final CacheSession s = CacheSession(sessionId)!;
  final key = req.rawPathParameters[#key]!;

  String body = await req.readAsString(maxLength: 10000);

  s.cache.put(key, body);
  return Response.ok(
    body: Body.fromString("ok"),
  );
}

Future<Response> deleteCacheHandler(final Request req) async {
  final String sessionId = req.rawPathParameters[#session]!;
  final CacheSession s = CacheSession(sessionId)!;
  final key = req.rawPathParameters[#key]!;

  s.cache.delete(key);
  return Response.ok(
    body: Body.fromString("ok"),
  );
}
