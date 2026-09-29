import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../logic/stats.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import 'labels.dart';
import 'widgets/common.dart';

class PlayersScreen extends StatelessWidget {
  const PlayersScreen({super.key});

  Future<String?> _askName(BuildContext context, String title,
      {String initial = ''}) {
    final controller = TextEditingController(text: initial);
    final l = context.l10n;
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(labelText: l.playerNameLabel),
          onSubmitted: (v) => Navigator.pop(context, v),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: Text(l.save),
          ),
        ],
      ),
    ).whenComplete(controller.dispose);
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final l = context.l10n;
    final active = state.activePlayer;

    return Scaffold(
      appBar: AppBar(
        title: Text(l.playersTitle),
        actions: [
          if (state.players.length > 1)
            TextButton.icon(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const CompareScreen()),
              ),
              icon: const Icon(Icons.compare_arrows),
              label: Text(l.comparePlayers),
            ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final name = await _askName(context, l.addPlayer);
          if (name != null && name.trim().isNotEmpty) {
            await state.addPlayer(name);
          }
        },
        icon: const Icon(Icons.person_add_alt),
        label: Text(l.addPlayer),
      ),
      body: ContentWidth(
        maxWidth: 700,
        child: ListView(
          padding: const EdgeInsets.only(bottom: 88),
          children: [
            for (final p in state.players)
              ListTile(
                leading: Icon(p.id == active?.id
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked),
                title: Text(p.name),
                subtitle: p.id == active?.id ? Text(l.activePlayer) : null,
                onTap: () => state.setActivePlayer(p.id),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      tooltip: l.renamePlayer,
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: () async {
                        final name = await _askName(context, l.renamePlayer,
                            initial: p.name);
                        if (name != null && name.trim().isNotEmpty) {
                          await state.renamePlayer(p.id, name);
                        }
                      },
                    ),
                    IconButton(
                      tooltip: l.delete,
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () async {
                        final ok = await confirmDelete(
                          context,
                          l.deletePlayerTitle(p.name),
                          body: l.deletePlayerBody,
                        );
                        if (ok) await state.deletePlayer(p.id);
                      },
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Tabel der sammenligner alle spillere, fx til en træner.
class CompareScreen extends StatelessWidget {
  const CompareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final l = context.l10n;
    final now = DateTime.now();

    final rows = [
      for (final p in state.players)
        _Row.of(p, state.matchesFor(p.id), state.trainingsFor(p.id), now),
    ]..sort((a, b) => (b.stats.rate ?? -1).compareTo(a.stats.rate ?? -1));

    return Scaffold(
      appBar: AppBar(title: Text(l.compareTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: [
              DataColumn(label: Text(l.compareColPlayer)),
              DataColumn(label: Text(l.compareColMatches), numeric: true),
              DataColumn(label: Text(l.compareColWinRate), numeric: true),
              DataColumn(label: Text(l.compareColTraining4w), numeric: true),
              DataColumn(label: Text(l.compareColSessions4w), numeric: true),
              DataColumn(label: Text(l.compareColForm)),
            ],
            rows: [
              for (final r in rows)
                DataRow(cells: [
                  DataCell(Text(r.player.name)),
                  DataCell(Text('${r.stats.played}')),
                  DataCell(Text(percent(r.stats.rate, l.noData))),
                  DataCell(Text(l.minutesShort(r.minutes4w))),
                  DataCell(Text('${r.sessions4w}')),
                  DataCell(r.form.isEmpty
                      ? Text(l.noData)
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            for (final won in r.form)
                              Padding(
                                padding: const EdgeInsets.only(right: 4),
                                child: ResultBadge(won: won, size: 22),
                              ),
                          ],
                        )),
                ]),
            ],
          ),
        ),
      ),
    );
  }
}

class _Row {
  _Row(this.player, this.stats, this.minutes4w, this.sessions4w, this.form);

  factory _Row.of(Player player, List<MatchRecord> matches,
      List<TrainingSession> trainings, DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    final from = addDays(today, -27);
    final recent = trainings.where((t) => !t.date.isBefore(from));
    return _Row(
      player,
      WinStats.of(matches),
      trainingMinutesSince(trainings, days: 28, now: now),
      recent.length,
      recentForm(matches, count: 5),
    );
  }

  final Player player;
  final WinStats stats;
  final int minutes4w;
  final int sessions4w;
  final List<bool> form;
}
