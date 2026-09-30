import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/coach_client.dart';
import '../logic/coach_context.dart';
import '../state/app_state.dart';
import 'labels.dart';
import 'widgets/common.dart';

Future<void> openCoach(BuildContext context) =>
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const CoachScreen()));

/// Chat med AI-træneren. Samtalen gemmes ikke, når skærmen lukkes.
class CoachScreen extends StatefulWidget {
  const CoachScreen({super.key});

  @override
  State<CoachScreen> createState() => _CoachScreenState();
}

enum _Menu { newChat, opus, sonnet, changeKey, removeKey }

class _CoachScreenState extends State<CoachScreen> {
  final _input = TextEditingController();
  final _keyInput = TextEditingController();
  final _scroll = ScrollController();
  final _messages = <CoachMessage>[];

  bool _loading = true;
  bool _waiting = false;
  bool _editingKey = false;
  String? _apiKey;
  CoachModel _model = CoachModel.opus;
  String? _error;

  /// Spillerdata fastfrosset ved samtalens start (se [CoachService.send]).
  String? _summary;

  CoachService get _service => context.read<CoachService>();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final service = _service;
    final key = await service.loadApiKey();
    final model = await service.loadModel();
    if (!mounted) return;
    setState(() {
      _apiKey = key;
      _model = model;
      _loading = false;
    });
  }

  @override
  void dispose() {
    _input.dispose();
    _keyInput.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _saveKey() async {
    final key = _keyInput.text.trim();
    if (key.isEmpty) return;
    await _service.saveApiKey(key);
    if (!mounted) return;
    setState(() {
      _apiKey = key;
      _editingKey = false;
      _keyInput.clear();
    });
  }

  Future<void> _onMenu(_Menu item) async {
    switch (item) {
      case _Menu.newChat:
        setState(() {
          _messages.clear();
          _summary = null;
          _error = null;
        });
      case _Menu.opus || _Menu.sonnet:
        final model = item == _Menu.opus ? CoachModel.opus : CoachModel.sonnet;
        await _service.saveModel(model);
        setState(() => _model = model);
      case _Menu.changeKey:
        setState(() => _editingKey = true);
      case _Menu.removeKey:
        await _service.saveApiKey(null);
        setState(() => _apiKey = null);
    }
  }

  Future<void> _send(String text) async {
    final question = text.trim();
    final apiKey = _apiKey;
    if (question.isEmpty || _waiting || apiKey == null) return;
    final state = context.read<AppState>();
    final player = state.activePlayer;
    if (player == null) return;
    _summary ??= coachPlayerSummary(
      player: player,
      matches: state.activeMatches,
      trainings: state.activeTrainings,
      goals: state.activeGoals,
      now: DateTime.now(),
    );
    setState(() {
      _messages.add(CoachMessage(fromUser: true, text: question));
      _input.clear();
      _waiting = true;
      _error = null;
    });
    _scrollToEnd();
    try {
      final reply = await _service.send(
        apiKey: apiKey,
        model: _model,
        playerSummary: _summary!,
        messages: List.of(_messages),
      );
      if (!mounted) return;
      final l = context.l10n;
      setState(() {
        _messages.add(
          CoachMessage(
            fromUser: false,
            text: reply.truncated
                ? '${reply.text}\n\n${l.coachTruncated}'
                : reply.text,
          ),
        );
      });
    } on CoachException catch (e) {
      if (!mounted) return;
      // Spørgsmålet lægges tilbage i feltet, så det kan sendes igen.
      setState(() {
        _messages.removeLast();
        _input.text = question;
        _error = _errorText(e);
      });
    } finally {
      if (mounted) setState(() => _waiting = false);
    }
    _scrollToEnd();
  }

  String _errorText(CoachException e) {
    final l = context.l10n;
    return switch (e.kind) {
      CoachErrorKind.invalidKey => l.coachErrorInvalidKey,
      CoachErrorKind.noCredit => l.coachErrorNoCredit,
      CoachErrorKind.rateLimited => l.coachErrorRateLimited,
      CoachErrorKind.overloaded => l.coachErrorOverloaded,
      CoachErrorKind.network => l.coachErrorNetwork,
      CoachErrorKind.refused => l.coachErrorRefused,
      CoachErrorKind.other => l.coachErrorOther(e.message),
    };
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      _scroll.animateTo(
        _scroll.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final hasKey = _apiKey != null && !_editingKey;
    return Scaffold(
      appBar: AppBar(
        title: Text(l.coachTitle),
        actions: [
          if (hasKey)
            PopupMenuButton<_Menu>(
              onSelected: _onMenu,
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: _Menu.newChat,
                  child: Text(l.coachNewChat),
                ),
                const PopupMenuDivider(),
                CheckedPopupMenuItem(
                  value: _Menu.opus,
                  checked: _model == CoachModel.opus,
                  child: Text(l.coachModelOpus),
                ),
                CheckedPopupMenuItem(
                  value: _Menu.sonnet,
                  checked: _model == CoachModel.sonnet,
                  child: Text(l.coachModelSonnet),
                ),
                const PopupMenuDivider(),
                PopupMenuItem(
                  value: _Menu.changeKey,
                  child: Text(l.coachChangeKey),
                ),
                PopupMenuItem(
                  value: _Menu.removeKey,
                  child: Text(l.coachRemoveKey),
                ),
              ],
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ContentWidth(child: hasKey ? _chat(context) : _keySetup(context)),
    );
  }

  Widget _keySetup(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(l.coachSetupTitle, style: theme.textTheme.titleLarge),
        const SizedBox(height: 12),
        Text(l.coachSetupBody),
        const SizedBox(height: 12),
        Text(l.coachSetupKeyInfo),
        const SizedBox(height: 12),
        Text(
          l.coachSetupPrivacy,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _keyInput,
          obscureText: true,
          autocorrect: false,
          enableSuggestions: false,
          decoration: InputDecoration(
            labelText: l.coachKeyLabel,
            hintText: l.coachKeyHint,
            border: const OutlineInputBorder(),
          ),
          onSubmitted: (_) => _saveKey(),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (_editingKey)
              TextButton(
                onPressed: () => setState(() => _editingKey = false),
                child: Text(l.cancel),
              ),
            const SizedBox(width: 8),
            FilledButton(onPressed: _saveKey, child: Text(l.coachKeySave)),
          ],
        ),
      ],
    );
  }

  Widget _chat(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final quick = [
      (l.coachQuickPlan, l.coachQuickPlanPrompt),
      (l.coachQuickFocus, l.coachQuickFocusPrompt),
      (l.coachQuickForm, l.coachQuickFormPrompt),
      (l.coachQuickRules, l.coachQuickRulesPrompt),
    ];
    return Column(
      children: [
        Expanded(
          child: ListView(
            controller: _scroll,
            padding: const EdgeInsets.all(12),
            children: [
              if (_messages.isEmpty) ...[
                Text(l.coachIntro, style: theme.textTheme.bodyLarge),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final (label, prompt) in quick)
                      ActionChip(
                        avatar: const Icon(Icons.auto_awesome, size: 18),
                        label: Text(label),
                        onPressed: _waiting ? null : () => _send(prompt),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  l.coachDisclaimer,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
              for (final m in _messages) _Bubble(message: m),
              if (_waiting)
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      const SizedBox(width: 12),
                      Text(l.coachThinking),
                    ],
                  ),
                ),
            ],
          ),
        ),
        if (_error != null)
          Container(
            width: double.infinity,
            color: theme.colorScheme.errorContainer,
            padding: const EdgeInsets.all(12),
            child: Text(
              _error!,
              style: TextStyle(color: theme.colorScheme.onErrorContainer),
            ),
          ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _input,
                    minLines: 1,
                    maxLines: 5,
                    textInputAction: TextInputAction.send,
                    decoration: InputDecoration(
                      hintText: l.coachInputHint,
                      border: const OutlineInputBorder(),
                      isDense: true,
                    ),
                    onSubmitted: _send,
                  ),
                ),
                IconButton(
                  tooltip: l.coachSend,
                  onPressed: _waiting ? null : () => _send(_input.text),
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.message});

  final CoachMessage message;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final user = message.fromUser;
    return Align(
      alignment: user ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 560),
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: user ? scheme.primaryContainer : scheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(12),
        ),
        child: SelectableText(
          message.text,
          style: TextStyle(
            color: user ? scheme.onPrimaryContainer : scheme.onSurface,
          ),
        ),
      ),
    );
  }
}
