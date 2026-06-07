import 'package:relic/relic.dart';
import 'handlers.dart';
import 'middlewares.dart';

RelicApp app() {
  return RelicApp()
    // sessions API
    ..get('/sessions', newSessionHandler)
    ..use('/sessions/:session', checkSessionId())
    ..use('/sessions/:session', checkSessionExists())
    ..delete('/sessions/:session', deleteSessionHandler)
    ..get('/sessions/:session', getSessionHandler)

    // cache API
    ..use('/cache/:session/:key', checkSessionId())
    ..use('/cache/:session/:key', checkSessionExists())
    ..use('/cache/:session/:key', checkKeyExists())
    ..get('/cache/:session', getCacheLengthHandler)
    ..get('/cache/:session/:key', getCacheHandler)
    ..post('/cache/:session/:key', postCacheHandler)
    ..delete('/cache/:session/:key', deleteCacheHandler)

    // wildcard
    ..fallback = respondWith(
      (_) => Response.notFound(
        body: Body.fromString("not found"),
      ),
    );
}
