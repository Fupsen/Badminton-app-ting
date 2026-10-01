import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../content/coach_da.dart';

/// Modeller brugeren kan vælge mellem. Opus er standard.
enum CoachModel {
  opus('claude-opus-5-5'),
  sonnet('claude-sonnet-5-5');

  const CoachModel(this.apiId);

  final String apiId;
}

enum CoachErrorKind {
  /// API-nøglen er forkert eller slettet.
  invalidKey,

  /// Der er ikke flere penge på kontoen.
  noCredit,

  /// For mange spørgsmål på kort tid.
  rateLimited,

  /// Anthropic har travlt eller har en fejl.
  overloaded,

  /// Ingen forbindelse eller timeout.
  network,

  /// AI'en ville ikke svare.
  refused,
  other,
}

class CoachException implements Exception {
  const CoachException(this.kind, [this.message = '']);

  final CoachErrorKind kind;
  final String message;

  @override
  String toString() => 'CoachException($kind, $message)';
}

class CoachMessage {
  const CoachMessage({required this.fromUser, required this.text});

  final bool fromUser;
  final String text;

  Map<String, dynamic> toJson() => {
    'role': fromUser ? 'user' : 'assistant',
    'content': text,
  };

  factory CoachMessage.fromJson(Map<String, dynamic> json) => CoachMessage(
    fromUser: json['role'] == 'user',
    text: json['content'] as String,
  );
}

/// En gemt samtale: beskederne og det spilleroverblik, der blev sendt med.
/// Overblikket gemmes også, så begyndelsen af forespørgslen er uændret, når
/// samtalen fortsættes, og cachen hos Anthropic kan genbruges.
class CoachChat {
  const CoachChat({required this.summary, required this.messages});

  final String summary;
  final List<CoachMessage> messages;
}

class CoachReply {
  const CoachReply({required this.text, required this.truncated});

  final String text;

  /// Svaret blev skåret af, fordi det ramte længdegrænsen.
  final bool truncated;
}

/// Taler med Claude API'et med brugerens egen API-nøgle.
///
/// Nøglen gemmes kun på enheden (SharedPreferences, i browseren
/// localStorage) og aldrig i backups. Kaldene går direkte fra appen til
/// Anthropic, også i webudgaven, så der er ingen server imellem.
class CoachService {
  CoachService({http.Client? client, AssetBundle? bundle})
    : _client = client ?? http.Client(),
      _bundle = bundle ?? rootBundle;

  static const _keyPref = 'coach_api_key';
  static const _modelPref = 'coach_model';
  static String _chatPref(String playerId) => 'coach_chat_$playerId';

  /// Så mange beskeder gemmes højst pr. spiller.
  static const maxSavedMessages = 40;
  static const _endpoint = 'https://api.anthropic.com/v1/messages';

  final http.Client _client;
  final AssetBundle _bundle;
  String? _knowledge;

  Future<String?> loadApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    final key = prefs.getString(_keyPref);
    return key == null || key.trim().isEmpty ? null : key;
  }

  Future<void> saveApiKey(String? key) async {
    final prefs = await SharedPreferences.getInstance();
    if (key == null || key.trim().isEmpty) {
      await prefs.remove(_keyPref);
    } else {
      await prefs.setString(_keyPref, key.trim());
    }
  }

  Future<CoachModel> loadModel() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString(_modelPref);
    return CoachModel.values.firstWhere(
      (m) => m.name == name,
      orElse: () => CoachModel.opus,
    );
  }

  Future<void> saveModel(CoachModel model) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_modelPref, model.name);
  }

  Future<CoachChat?> loadChat(String playerId) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_chatPref(playerId));
    if (raw == null) return null;
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return CoachChat(
        summary: json['summary'] as String,
        messages: [
          for (final m in json['messages'] as List<dynamic>)
            CoachMessage.fromJson(m as Map<String, dynamic>),
        ],
      );
    } on Object {
      await prefs.remove(_chatPref(playerId));
      return null;
    }
  }

  /// Gemmer samtalen. Er den for lang, fjernes de ældste beskeder, så den
  /// stadig starter med et spørgsmål fra brugeren.
  Future<void> saveChat(String playerId, CoachChat chat) async {
    var messages = chat.messages;
    if (messages.length > maxSavedMessages) {
      messages = messages.sublist(messages.length - maxSavedMessages);
      while (messages.isNotEmpty && !messages.first.fromUser) {
        messages = messages.sublist(1);
      }
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _chatPref(playerId),
      jsonEncode({
        'summary': chat.summary,
        'messages': [for (final m in messages) m.toJson()],
      }),
    );
  }

  Future<void> clearChat(String playerId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_chatPref(playerId));
  }

  /// Instruktioner, appens bibliotek og vidensbanken. Teksten er den samme
  /// i alle samtaler, så den kan caches hos Anthropic.
  Future<String> knowledge() async {
    if (_knowledge != null) return _knowledge!;
    final b = StringBuffer(coachInstructions)
      ..writeln()
      ..writeln('# Appens slag, benarbejde og øvelser')
      ..writeln()
      ..writeln(coachLibrary())
      ..writeln('# Vidensbank (docs/viden/)');
    for (final file in coachKnowledgeFiles) {
      // Tjenesten husker selv teksten, så bundlens cache er ikke nødvendig.
      final text = await _bundle.loadString('docs/viden/$file', cache: false);
      b
        ..writeln()
        ..writeln('<fil navn="$file">')
        ..writeln(text.trim())
        ..writeln('</fil>');
    }
    return _knowledge = b.toString();
  }

  /// Sender samtalen og returnerer AI-trænerens svar.
  ///
  /// [playerSummary] skal være den samme i hele samtalen, så begyndelsen af
  /// forespørgslen er uændret, og cachen kan genbruges.
  Future<CoachReply> send({
    required String apiKey,
    required CoachModel model,
    required String playerSummary,
    required List<CoachMessage> messages,
  }) async {
    final body = {
      'model': model.apiId,
      'max_tokens': 16000,
      'output_config': {'effort': 'medium'},
      // Afviser modellen et spørgsmål, prøver API'et selv en anden model.
      'fallbacks': 'default',
      'system': [
        {
          'type': 'text',
          'text': await knowledge(),
          'cache_control': {'type': 'ephemeral'},
        },
        {'type': 'text', 'text': '# Spillerdata\n\n$playerSummary'},
      ],
      'messages': [for (final m in messages) m.toJson()],
    };

    final http.Response response;
    try {
      response = await _client
          .post(
            Uri.parse(_endpoint),
            headers: {
              'content-type': 'application/json',
              'x-api-key': apiKey,
              'anthropic-version': '2023-06-01',
              'anthropic-beta': 'server-side-fallback-2026-07-01',
              // Kræves for kald direkte fra en browser. Det er sikkert her,
              // fordi det er brugerens egen nøgle på brugerens egen enhed.
              'anthropic-dangerous-direct-browser-access': 'true',
            },
            body: jsonEncode(body),
          )
          .timeout(const Duration(minutes: 3));
    } on TimeoutException {
      throw const CoachException(CoachErrorKind.network);
    } on http.ClientException catch (e) {
      throw CoachException(CoachErrorKind.network, e.message);
    }

    final Map<String, dynamic> json;
    try {
      json =
          jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    } on FormatException {
      throw CoachException(
        response.statusCode >= 500
            ? CoachErrorKind.overloaded
            : CoachErrorKind.other,
        'HTTP ${response.statusCode}',
      );
    }

    if (response.statusCode != 200) throw _error(response.statusCode, json);

    if (json['stop_reason'] == 'refusal') {
      throw const CoachException(CoachErrorKind.refused);
    }
    final text = [
      for (final block in json['content'] as List<dynamic>)
        if (block is Map && block['type'] == 'text') block['text'] as String,
    ].join().trim();
    if (text.isEmpty) throw const CoachException(CoachErrorKind.other);
    return CoachReply(
      text: text,
      truncated: json['stop_reason'] == 'max_tokens',
    );
  }

  static CoachException _error(int status, Map<String, dynamic> json) {
    final error = json['error'] as Map<String, dynamic>? ?? const {};
    final type = error['type'] as String? ?? '';
    final message = error['message'] as String? ?? 'HTTP $status';
    if (status == 401 || type == 'authentication_error') {
      return CoachException(CoachErrorKind.invalidKey, message);
    }
    if (message.toLowerCase().contains('credit balance')) {
      return CoachException(CoachErrorKind.noCredit, message);
    }
    if (status == 429 || type == 'rate_limit_error') {
      return CoachException(CoachErrorKind.rateLimited, message);
    }
    if (status >= 500 || type == 'overloaded_error') {
      return CoachException(CoachErrorKind.overloaded, message);
    }
    return CoachException(CoachErrorKind.other, message);
  }
}
