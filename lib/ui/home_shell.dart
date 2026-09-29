import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import 'dashboard_screen.dart';
import 'goals_screen.dart';
import 'labels.dart';
import 'matches_screen.dart';
import 'players_screen.dart';
import 'stats_screen.dart';
import 'training_screen.dart';

/// Bredde hvor layoutet skifter fra bundnavigation (mobil) til sidemenu
/// (tablet/computer).
const wideLayoutBreakpoint = 840.0;

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;
  Object? _shownSaveError;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    if (!state.loaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final player = state.activePlayer;
    if (player == null) return const WelcomeScreen();

    _maybeShowSaveError(state);

    final l = context.l10n;
    final destinations = [
      (Icons.dashboard_outlined, Icons.dashboard, l.navOverview),
      (Icons.sports_tennis_outlined, Icons.sports_tennis, l.navMatches),
      (Icons.fitness_center_outlined, Icons.fitness_center, l.navTraining),
      (Icons.flag_outlined, Icons.flag, l.navGoals),
      (Icons.insights_outlined, Icons.insights, l.navStats),
    ];
    final body = switch (_index) {
      0 => DashboardScreen(onNavigate: (i) => setState(() => _index = i)),
      1 => const MatchesScreen(),
      2 => const TrainingScreen(),
      3 => const GoalsScreen(),
      _ => const StatsScreen(),
    };
    final fab = switch (_index) {
      1 => FloatingActionButton(
          tooltip: l.newMatch,
          onPressed: () => openMatchForm(context),
          child: const Icon(Icons.add),
        ),
      2 => FloatingActionButton(
          tooltip: l.newTraining,
          onPressed: () => openTrainingForm(context),
          child: const Icon(Icons.add),
        ),
      3 => FloatingActionButton(
          tooltip: l.newGoal,
          onPressed: () => openGoalForm(context),
          child: const Icon(Icons.add),
        ),
      _ => null,
    };

    final wide = MediaQuery.sizeOf(context).width >= wideLayoutBreakpoint;
    final appBar = AppBar(
      title: Text(destinations[_index].$3),
      actions: const [PlayerSwitcher(), SizedBox(width: 8)],
    );

    if (wide) {
      return Scaffold(
        appBar: appBar,
        floatingActionButton: fab,
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: _index,
              onDestinationSelected: (i) => setState(() => _index = i),
              labelType: NavigationRailLabelType.all,
              destinations: [
                for (final d in destinations)
                  NavigationRailDestination(
                    icon: Icon(d.$1),
                    selectedIcon: Icon(d.$2),
                    label: Text(d.$3),
                  ),
              ],
            ),
            const VerticalDivider(width: 1),
            Expanded(child: body),
          ],
        ),
      );
    }
    return Scaffold(
      appBar: appBar,
      floatingActionButton: fab,
      body: body,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: [
          for (final d in destinations)
            NavigationDestination(
              icon: Icon(d.$1),
              selectedIcon: Icon(d.$2),
              label: d.$3,
            ),
        ],
      ),
    );
  }

  void _maybeShowSaveError(AppState state) {
    final error = state.saveError;
    if (error == null || identical(error, _shownSaveError)) return;
    _shownSaveError = error;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.saveFailed(error.toString()))),
      );
    });
  }
}

/// Knap i app-baren der viser den aktive spiller og lader brugeren skifte.
class PlayerSwitcher extends StatelessWidget {
  const PlayerSwitcher({super.key});

  static const _manage = '__manage__';

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final active = state.activePlayer!;
    final l = context.l10n;
    return PopupMenuButton<String>(
      tooltip: l.activePlayer,
      onSelected: (id) {
        if (id == _manage) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const PlayersScreen()),
          );
        } else {
          state.setActivePlayer(id);
        }
      },
      itemBuilder: (context) => [
        for (final p in state.players)
          CheckedPopupMenuItem(
            value: p.id,
            checked: p.id == active.id,
            child: Text(p.name),
          ),
        const PopupMenuDivider(),
        PopupMenuItem(
          value: _manage,
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.group_outlined),
            title: Text(l.managePlayers),
          ),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 14,
              child: Text(
                active.name.isEmpty ? '?' : active.name[0].toUpperCase(),
                style: const TextStyle(fontSize: 13),
              ),
            ),
            const SizedBox(width: 8),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 140),
              child: Text(active.name, overflow: TextOverflow.ellipsis),
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}

/// Vises første gang appen åbnes, før der findes en spiller.
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _start() {
    final name = _controller.text.trim();
    if (name.isEmpty) return;
    context.read<AppState>().addPlayer(name);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(Icons.sports_tennis,
                      size: 72, color: theme.colorScheme.primary),
                  const SizedBox(height: 24),
                  Text(l.welcomeTitle,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineSmall),
                  const SizedBox(height: 12),
                  Text(l.welcomeBody,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge),
                  const SizedBox(height: 32),
                  TextField(
                    controller: _controller,
                    autofocus: true,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      labelText: l.welcomeNameLabel,
                      border: const OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _start(),
                  ),
                  const SizedBox(height: 16),
                  ListenableBuilder(
                    listenable: _controller,
                    builder: (context, _) => FilledButton(
                      onPressed:
                          _controller.text.trim().isEmpty ? null : _start,
                      child: Text(l.welcomeStart),
                    ),
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
