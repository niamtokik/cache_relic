import 'package:relic/relic.dart';
import 'store.dart';
import 'session.dart';

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
