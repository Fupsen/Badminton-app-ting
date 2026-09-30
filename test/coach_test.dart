import 'dart:convert';
import 'dart:io';

import 'package:badminton_app/content/coach_da.dart';
import 'package:badminton_app/content/technique.dart';
import 'package:badminton_app/data/coach_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Et svar fra Messages API'et med de givne indholdsblokke.
http.Response apiReply(
  List<Map<String, dynamic>> content, {
  String stopReason = 'end_turn',
}) => http.Response.bytes(
  utf8.encode(
    jsonEncode({
      'id': 'msg_1',
      'type': 'message',
      'role': 'assistant',
      'content': content,
      'stop_reason': stopReason,
    }),
  ),
  200,
  headers: {'content-type': 'application/json'},
);

http.Response apiError(int status, String type, String message) =>
    http.Response(
      jsonEncode({
        'type': 'error',
        'error': {'type': type, 'message': message},
      }),
      status,
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<CoachReply> ask(CoachService service) => service.send(
    apiKey: 'sk-test',
    model: CoachModel.opus,
    playerSummary: 'Spiller: Mette',
    messages: const [CoachMessage(fromUser: true, text: 'Hej')],
  );

  test(
    'request has key, browser header, cached knowledge and player data',
    () async {
      late http.Request sent;
      final service = CoachService(
        client: MockClient((request) async {
          sent = request;
          return apiReply([
            {'type': 'thinking', 'thinking': ''},
            {'type': 'text', 'text': 'Hej Mette! Æblegrød.'},
          ]);
        }),
      );

      final reply = await ask(service);
      // Tænkeblokke vises ikke, og æ/ø/å kommer rigtigt igennem.
      expect(reply.text, 'Hej Mette! Æblegrød.');
      expect(reply.truncated, isFalse);

      expect(sent.url.toString(), 'https://api.anthropic.com/v1/messages');
      expect(sent.headers['x-api-key'], 'sk-test');
      expect(sent.headers['anthropic-version'], '2023-06-01');
      expect(sent.headers['anthropic-dangerous-direct-browser-access'], 'true');
      final body = jsonDecode(sent.body) as Map<String, dynamic>;
      expect(body['model'], CoachModel.opus.apiId);
      expect(body['fallbacks'], 'default');
      final system = body['system'] as List<dynamic>;
      expect(system, hasLength(2));
      // Første blok (instruktioner og vidensbank) caches, spillerdata gør ikke.
      expect(system[0]['cache_control'], {'type': 'ephemeral'});
      expect(system[0]['text'], contains('3×15'));
      expect(system[0]['text'], contains('<fil navn="ovelser.md">'));
      expect(system[1].containsKey('cache_control'), isFalse);
      expect(system[1]['text'], contains('Spiller: Mette'));
      expect(body['messages'], [
        {'role': 'user', 'content': 'Hej'},
      ]);
    },
  );

  test('knowledge is identical between calls so it can be cached', () async {
    final service = CoachService(client: MockClient((_) async => apiReply([])));
    expect(await service.knowledge(), await service.knowledge());
    expect(await service.knowledge(), isNot(contains('Dato i dag')));
  });

  test('truncated answers are marked', () async {
    final service = CoachService(
      client: MockClient(
        (_) async => apiReply([
          {'type': 'text', 'text': 'Langt svar'},
        ], stopReason: 'max_tokens'),
      ),
    );
    expect((await ask(service)).truncated, isTrue);
  });

  test('errors are mapped to kinds the user can act on', () async {
    Future<CoachErrorKind> kindFor(http.Response response) async {
      final service = CoachService(client: MockClient((_) async => response));
      try {
        await ask(service);
      } on CoachException catch (e) {
        return e.kind;
      }
      fail('ingen fejl');
    }

    expect(
      await kindFor(apiError(401, 'authentication_error', 'invalid x-api-key')),
      CoachErrorKind.invalidKey,
    );
    expect(
      await kindFor(
        apiError(
          400,
          'invalid_request_error',
          'Your credit balance is too low to access the Anthropic API.',
        ),
      ),
      CoachErrorKind.noCredit,
    );
    expect(
      await kindFor(apiError(429, 'rate_limit_error', 'slow down')),
      CoachErrorKind.rateLimited,
    );
    expect(
      await kindFor(apiError(529, 'overloaded_error', 'Overloaded')),
      CoachErrorKind.overloaded,
    );
    expect(
      await kindFor(http.Response('<html>Bad gateway</html>', 502)),
      CoachErrorKind.overloaded,
    );
    expect(
      await kindFor(apiReply([], stopReason: 'refusal')),
      CoachErrorKind.refused,
    );
  });

  test('network failures become network errors', () async {
    final service = CoachService(
      client: MockClient((_) async => throw http.ClientException('offline')),
    );
    expect(
      () => ask(service),
      throwsA(
        isA<CoachException>().having(
          (e) => e.kind,
          'kind',
          CoachErrorKind.network,
        ),
      ),
    );
  });

  test('api key and model are stored on the device', () async {
    SharedPreferences.setMockInitialValues({});
    final service = CoachService(client: MockClient((_) async => apiReply([])));
    expect(await service.loadApiKey(), isNull);
    expect(await service.loadModel(), CoachModel.opus);

    await service.saveApiKey('  sk-ant-123  ');
    await service.saveModel(CoachModel.sonnet);
    expect(await service.loadApiKey(), 'sk-ant-123');
    expect(await service.loadModel(), CoachModel.sonnet);

    await service.saveApiKey(null);
    expect(await service.loadApiKey(), isNull);
  });

  test('all knowledge files exist and the library lists every drill', () {
    for (final file in coachKnowledgeFiles) {
      expect(File('docs/viden/$file').existsSync(), isTrue, reason: file);
    }
    final library = coachLibrary();
    for (final t in techniques) {
      expect(library, contains(t.name));
    }
    for (final d in drills) {
      expect(library, contains(d.name));
    }
  });
}
