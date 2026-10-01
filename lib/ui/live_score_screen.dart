import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../data/live_match_store.dart';
import '../l10n/app_localizations.dart';
import '../logic/live_score.dart';
import '../logic/scoring.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import 'labels.dart';
import 'matches_screen.dart';

Future<void> openLiveScore(BuildContext context) =>
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const LiveScoreScreen()));

/// Kamptæller: tæl point under kampen og gem kampen bagefter. En
/// igangværende kamp gemmes efter hvert point (se [LiveMatchStore]).
class LiveScoreScreen extends StatefulWidget {
  const LiveScoreScreen({super.key});

  @override
  State<LiveScoreScreen> createState() => _LiveScoreScreenState();
}

enum _Menu { saveNow, abort }

class _LiveScoreScreenState extends State<LiveScoreScreen> {
  final _store = const LiveMatchStore();
  late final String _playerId;
  bool _loading = true;
  LiveMatch? _match;

  ScoringSystem _system = ScoringSystem.to15;
  MatchType _type = MatchType.single;
  Side _firstServer = Side.us;

  @override
  void initState() {
    super.initState();
    _playerId = context.read<AppState>().activePlayer!.id;
    _load();
  }

  Future<void> _load() async {
    final match = await _store.load(_playerId);
    if (!mounted) return;
    setState(() {
      _match = match;
      _loading = false;
    });
  }

  void _update(LiveMatch match) {
    setState(() => _match = match);
    _store.save(_playerId, match);
  }

  void _point(Side side) {
    final match = _match;
    if (match == null || match.isFinished) return;
    HapticFeedback.selectionClick();
    _update(match.pointTo(side));
  }

  Future<void> _save() async {
    final match = _match!;
    final saved = await openMatchForm(
      context,
      initialGames: match.gamesForSaving,
      initialType: match.type,
    );
    if (!saved || !mounted) return;
    await _store.clear(_playerId);
    if (mounted) Navigator.pop(context);
  }

  Future<void> _onMenu(_Menu item) async {
    final l = context.l10n;
    switch (item) {
      case _Menu.saveNow:
        await _save();
      case _Menu.abort:
        final ok = await confirmDelete(
          context,
          l.liveScoreAbortTitle,
          body: l.liveScoreAbortBody,
          confirmLabel: l.liveScoreAbortConfirm,
        );
        if (!ok) return;
        await _store.clear(_playerId);
        setState(() => _match = null);
    }
  }

  (String, String) _sideLabels(AppLocalizations l, MatchType type) =>
      type == MatchType.single
      ? (l.liveScoreMe, l.liveScoreOpponent)
      : (l.liveScoreUs, l.liveScoreThem);

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final match = _match;
    return Scaffold(
      appBar: AppBar(
        title: Text(l.liveScoreTitle),
        actions: [
          if (match != null) ...[
            IconButton(
              tooltip: l.liveScoreUndo,
              icon: const Icon(Icons.undo),
              onPressed: match.canUndo ? () => _update(match.undo()) : null,
            ),
            PopupMenuButton<_Menu>(
              onSelected: _onMenu,
              itemBuilder: (context) => [
                if (match.gamesForSaving.isNotEmpty && !match.isFinished)
                  PopupMenuItem(
                    value: _Menu.saveNow,
                    child: Text(l.liveScoreSaveNow),
                  ),
                PopupMenuItem(
                  value: _Menu.abort,
                  child: Text(l.liveScoreAbort),
                ),
              ],
            ),
          ],
        ],
      ),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : match == null
            ? _setup(context)
            : _scoreboard(context, match),
      ),
    );
  }

  Widget _setup(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final (us, them) = _sideLabels(l, _type);
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(l.liveScoreIntro, style: theme.textTheme.bodyLarge),
            const SizedBox(height: 24),
            Text(l.liveScoreSystem, style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            SegmentedButton<ScoringSystem>(
              segments: [
                ButtonSegment(
                  value: ScoringSystem.to15,
                  label: Text(l.liveScoreSystem15),
                ),
                ButtonSegment(
                  value: ScoringSystem.to21,
                  label: Text(l.liveScoreSystem21),
                ),
              ],
              selected: {_system},
              onSelectionChanged: (v) => setState(() => _system = v.first),
            ),
            const SizedBox(height: 20),
            Text(l.liveScoreType, style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            SegmentedButton<MatchType>(
              segments: [
                for (final t in MatchType.values)
                  ButtonSegment(value: t, label: Text(t.label(l))),
              ],
              selected: {_type},
              onSelectionChanged: (v) => setState(() => _type = v.first),
            ),
            const SizedBox(height: 20),
            Text(l.liveScoreFirstServer, style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            SegmentedButton<Side>(
              segments: [
                ButtonSegment(value: Side.us, label: Text(us)),
                ButtonSegment(value: Side.them, label: Text(them)),
              ],
              selected: {_firstServer},
              onSelectionChanged: (v) => setState(() => _firstServer = v.first),
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              icon: const Icon(Icons.play_arrow),
              label: Text(l.liveScoreBegin),
              onPressed: () => _update(
                LiveMatch(
                  system: _system,
                  type: _type,
                  firstServer: _firstServer,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _scoreboard(BuildContext context, LiveMatch match) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final (us, them) = _sideLabels(l, match.type);
    final games = match.games;
    final won = games.where((g) => g.won).length;
    final event = match.lastEvent;
    final eventText = switch (event) {
      LiveEvent.interval => l.liveScoreInterval,
      LiveEvent.intervalAndChangeEnds => l.liveScoreIntervalChangeEnds,
      LiveEvent.gameEnded => l.liveScoreGameEnded,
      LiveEvent.matchEnded =>
        match.winner == Side.us
            ? l.liveScoreWon(formatScore(games))
            : l.liveScoreLost(formatScore(games)),
      null => null,
    };

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Row(
            children: [
              if (!match.isFinished)
                Text(
                  l.liveScoreGameNumber(games.length + 1),
                  style: theme.textTheme.titleMedium,
                ),
              const Spacer(),
              Text(
                [
                  l.liveScoreGamesWon(won, games.length - won),
                  if (games.isNotEmpty) formatScore(games),
                ].join(' · '),
                style: theme.textTheme.titleMedium,
              ),
            ],
          ),
        ),
        if (eventText != null)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.tertiaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              eventText,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onTertiaryContainer,
              ),
            ),
          ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final side in Side.values)
                  Expanded(
                    child: _SidePanel(
                      label: side == Side.us ? us : them,
                      points: side == Side.us
                          ? match.ourPoints
                          : match.theirPoints,
                      serving: !match.isFinished && match.server == side,
                      courtLabel: match.serviceCourt == Court.right
                          ? l.liveScoreServesRight
                          : l.liveScoreServesLeft,
                      highlight: side == Side.us,
                      onTap: match.isFinished ? null : () => _point(side),
                    ),
                  ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: match.isFinished
              ? FilledButton.icon(
                  icon: const Icon(Icons.save),
                  label: Text(l.liveScoreSave),
                  onPressed: _save,
                )
              : Text(
                  l.liveScoreTapHint,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
        ),
      ],
    );
  }
}

class _SidePanel extends StatelessWidget {
  const _SidePanel({
    required this.label,
    required this.points,
    required this.serving,
    required this.courtLabel,
    required this.highlight,
    required this.onTap,
  });

  final String label;
  final int points;
  final bool serving;
  final String courtLabel;
  final bool highlight;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final background = highlight
        ? scheme.primaryContainer
        : scheme.secondaryContainer;
    final foreground = highlight
        ? scheme.onPrimaryContainer
        : scheme.onSecondaryContainer;
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Material(
        color: background,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Semantics(
            button: true,
            label: '$label $points',
            // Skærmlæseren skal læse "Mig 8", ikke hver tekst for sig.
            excludeSemantics: true,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge
                        ?.copyWith(color: foreground),
                  ),
                  Expanded(
                    child: FittedBox(
                      child: Text(
                        '$points',
                        style: TextStyle(
                          fontSize: 120,
                          fontWeight: FontWeight.bold,
                          color: foreground,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 48,
                    child: serving
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.sports_tennis, color: foreground),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  courtLabel,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: foreground,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : null,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
