import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../logic/scoring.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import 'labels.dart';
import 'widgets/common.dart';
import 'widgets/date_field.dart';
import 'widgets/suggest_field.dart';

class MatchesScreen extends StatelessWidget {
  const MatchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final matches = context.watch<AppState>().activeMatches;
    final l = context.l10n;
    if (matches.isEmpty) {
      return EmptyState(icon: Icons.sports_tennis, message: l.noMatches);
    }
    return ContentWidth(
      child: ListView.separated(
        padding: const EdgeInsets.only(top: 8, bottom: 88),
        itemCount: matches.length,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (context, i) => MatchTile(match: matches[i]),
      ),
    );
  }
}

class MatchTile extends StatelessWidget {
  const MatchTile({super.key, required this.match});

  final MatchRecord match;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final opponents = match.opponents.isEmpty
        ? l.unknownOpponent
        : match.opponents;
    final details = [
      context.formatDate(match.date),
      match.type.label(l),
      if (match.partner.isNotEmpty) l.matchWithPartner(match.partner),
      if (match.practice) l.practiceMatch,
    ].join(' · ');
    return ListTile(
      // Træningskampe vises dæmpet, fordi de ikke tæller i statistikken.
      leading: Opacity(
        opacity: match.practice ? 0.45 : 1,
        child: ResultBadge(won: match.won),
      ),
      title: Text(l.matchVs(opponents)),
      subtitle: Text(details),
      trailing: Text(
        formatScore(match.games),
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      onTap: () => openMatchForm(context, existing: match),
    );
  }
}

Future<void> openMatchForm(BuildContext context, {MatchRecord? existing}) =>
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => MatchForm(existing: existing),
      ),
    );

class MatchForm extends StatefulWidget {
  const MatchForm({super.key, this.existing});

  final MatchRecord? existing;

  @override
  State<MatchForm> createState() => _MatchFormState();
}

class _MatchFormState extends State<MatchForm> {
  final _formKey = GlobalKey<FormState>();
  late DateTime _date;
  late MatchType _type;
  late bool _practice;
  late final TextEditingController _opponents;
  late final TextEditingController _partner;
  late final TextEditingController _notes;
  late final List<(TextEditingController, TextEditingController)> _scores;
  String? _scoreError;

  @override
  void initState() {
    super.initState();
    final m = widget.existing;
    _date = m?.date ?? DateTime.now();
    _type = m?.type ?? MatchType.single;
    _practice = m?.practice ?? false;
    _opponents = TextEditingController(text: m?.opponents ?? '');
    _partner = TextEditingController(text: m?.partner ?? '');
    _notes = TextEditingController(text: m?.notes ?? '');
    _scores = List.generate(3, (i) {
      final game = m != null && i < m.games.length ? m.games[i] : null;
      return (
        TextEditingController(text: game?.own.toString() ?? ''),
        TextEditingController(text: game?.opponent.toString() ?? ''),
      );
    });
  }

  @override
  void dispose() {
    for (final c in [_opponents, _partner, _notes]) {
      c.dispose();
    }
    for (final (own, opp) in _scores) {
      own.dispose();
      opp.dispose();
    }
    super.dispose();
  }

  List<GameScore> _games() => [
    for (final (own, opp) in _scores)
      if (own.text.isNotEmpty && opp.text.isNotEmpty)
        GameScore(int.parse(own.text), int.parse(opp.text)),
  ];

  Future<void> _save() async {
    final l = context.l10n;
    final state = context.read<AppState>();
    if (!_formKey.currentState!.validate()) return;

    final games = _games();
    final check = checkMatch(games);
    setState(() {
      _scoreError = check.errors.isEmpty
          ? null
          : check.errors
                .map(
                  (e) => switch (e) {
                    ScoreError.noGames => l.scoreErrorNoGames,
                    ScoreError.tiedGame => l.scoreErrorTiedGame,
                    ScoreError.noWinner => l.scoreErrorNoWinner,
                  },
                )
                .join('\n');
    });
    if (!check.canSave) return;

    // Træningskampe spilles ofte til fx 15, så advar kun ved rigtige kampe.
    if (!_practice && check.warnings.isNotEmpty) {
      final proceed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l.scoreWarningTitle),
          content: Text(
            [
              if (check.warnings.contains(ScoreWarning.nonStandardGame))
                l.scoreWarningGame,
              if (check.warnings.contains(ScoreWarning.nonStandardGameCount))
                l.scoreWarningGameCount,
              l.scoreWarningFooter,
            ].join('\n\n'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(l.saveAnyway),
            ),
          ],
        ),
      );
      if (proceed != true) return;
    }

    await state.saveMatch(
      MatchRecord(
        id: widget.existing?.id ?? newId(),
        playerId: widget.existing?.playerId ?? state.activePlayer!.id,
        date: _date,
        type: _type,
        opponents: _opponents.text.trim(),
        partner: _type == MatchType.single ? '' : _partner.text.trim(),
        games: games,
        notes: _notes.text.trim(),
        practice: _practice,
      ),
    );
    if (mounted) Navigator.pop(context);
  }

  Future<void> _delete() async {
    final l = context.l10n;
    final state = context.read<AppState>();
    if (await confirmDelete(context, l.deleteMatchTitle)) {
      await state.deleteMatch(widget.existing!.id);
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final state = context.watch<AppState>();
    final previous = state.activeMatches;
    List<String> distinct(Iterable<String> values) => {
      for (final v in values)
        if (v.trim().isNotEmpty) v.trim(),
    }.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existing == null ? l.newMatch : l.editMatch),
        actions: [
          if (widget.existing != null)
            IconButton(
              tooltip: l.delete,
              icon: const Icon(Icons.delete_outline),
              onPressed: _delete,
            ),
          TextButton(onPressed: _save, child: Text(l.save)),
          const SizedBox(width: 8),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ContentWidth(
          maxWidth: 600,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              DateField(
                date: _date,
                onChanged: (d) => setState(() => _date = d),
              ),
              const SizedBox(height: 16),
              SegmentedButton<MatchType>(
                segments: [
                  for (final t in MatchType.values)
                    ButtonSegment(value: t, label: Text(t.label(l))),
                ],
                selected: {_type},
                onSelectionChanged: (s) => setState(() => _type = s.first),
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l.practiceMatch),
                subtitle: Text(l.practiceMatchHint),
                value: _practice,
                onChanged: (v) => setState(() => _practice = v),
              ),
              const SizedBox(height: 16),
              SuggestField(
                controller: _opponents,
                label: l.opponentsLabel,
                suggestions: distinct(previous.map((m) => m.opponents)),
              ),
              if (_type != MatchType.single) ...[
                const SizedBox(height: 16),
                SuggestField(
                  controller: _partner,
                  label: l.partnerLabel,
                  suggestions: distinct(previous.map((m) => m.partner)),
                ),
              ],
              const SizedBox(height: 24),
              for (var i = 0; i < _scores.length; i++) _scoreRow(i),
              Text(
                l.optionalThirdGame,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              if (_scoreError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    _scoreError!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _notes,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: l.notesLabel,
                  border: const OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _scoreRow(int i) {
    final l = context.l10n;
    final (own, opp) = _scores[i];
    String? validator(String? value, TextEditingController other) {
      if ((value ?? '').isEmpty && other.text.isNotEmpty) {
        return l.fieldRequired;
      }
      return null;
    }

    InputDecoration decoration(String label) => InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
      isDense: true,
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 64,
            child: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(l.gameLabel(i + 1)),
            ),
          ),
          Expanded(
            child: TextFormField(
              controller: own,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(2),
              ],
              decoration: decoration(l.ownPoints),
              validator: (v) => validator(v, opp),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(8, 12, 8, 0),
            child: Text('–'),
          ),
          Expanded(
            child: TextFormField(
              controller: opp,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(2),
              ],
              decoration: decoration(l.opponentPoints),
              validator: (v) => validator(v, own),
            ),
          ),
        ],
      ),
    );
  }
}
