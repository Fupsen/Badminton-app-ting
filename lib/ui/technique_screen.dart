import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../content/rules.dart';
import '../content/technique.dart';
import '../logic/stats.dart';
import '../logic/technique_stats.dart';
import '../state/app_state.dart';
import 'labels.dart';
import 'timer_screen.dart';
import 'training_screen.dart';
import 'widgets/common.dart';

enum _Section { strokes, footwork, drills, rules }

/// Teknik-fanen: bibliotek med slag, benarbejde, øvelser og regler.
class TechniqueScreen extends StatefulWidget {
  const TechniqueScreen({super.key});

  @override
  State<TechniqueScreen> createState() => _TechniqueScreenState();
}

class _TechniqueScreenState extends State<TechniqueScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs = TabController(
    length: _Section.values.length,
    vsync: this,
  )..addListener(() => setState(() {}));
  DrillLevel? _level;
  bool _levelFromProfile = false;
  DrillGroup? _group;
  bool _short = false;
  final _search = TextEditingController();
  String _query = '';

  _Section get _section => _Section.values[_tabs.index];

  @override
  void dispose() {
    _tabs.dispose();
    _search.dispose();
    super.dispose();
  }

  Widget _searchField() {
    final l = context.l10n;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
      child: TextField(
        controller: _search,
        decoration: InputDecoration(
          hintText: l.searchHint,
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _query.isEmpty
              ? null
              : IconButton(
                  tooltip: l.cancel,
                  icon: const Icon(Icons.clear),
                  onPressed: () => setState(() {
                    _search.clear();
                    _query = '';
                  }),
                ),
          border: const OutlineInputBorder(),
          isDense: true,
        ),
        onChanged: (v) => setState(() => _query = v),
      ),
    );
  }

  Widget _noResults() => Padding(
    padding: const EdgeInsets.all(24),
    child: Text(context.l10n.searchNoResults, textAlign: TextAlign.center),
  );

  Widget _leftHandedNote() {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.fromLTRB(12, 4, 12, 4),
      color: theme.colorScheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(
              Icons.swap_horiz,
              color: theme.colorScheme.onSecondaryContainer,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                context.l10n.leftHandedNote,
                style: TextStyle(color: theme.colorScheme.onSecondaryContainer),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final state = context.watch<AppState>();
    final usage = techniqueUsage(state.activeTrainings);
    final player = state.activePlayer;
    // Øvelserne starter på spillerens niveau, hvis det er valgt.
    if (!_levelFromProfile) {
      _levelFromProfile = true;
      _level = player?.level?.drillLevel;
    }
    final leftHanded = player?.leftHanded ?? false;

    final List<Widget> items = switch (_section) {
      _Section.strokes => [
        if (leftHanded) _leftHandedNote(),
        _searchField(),
        ..._techniqueList(TechniqueKind.stroke, usage),
      ],
      _Section.footwork => [
        if (leftHanded) _leftHandedNote(),
        _searchField(),
        ..._techniqueList(TechniqueKind.footwork, usage),
      ],
      _Section.drills => [_searchField(), ..._drillList()],
      _Section.rules => _ruleList(),
    };
    final theme = Theme.of(context);

    return ContentWidth(
      child: Column(
        children: [
          TabBar(
            controller: _tabs,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: [
              Tab(text: l.techniqueStrokes),
              Tab(text: l.techniqueFootwork),
              Tab(text: l.techniqueDrills),
              Tab(text: l.techniqueRules),
            ],
          ),
          Expanded(
            child: ListView(
              key: PageStorageKey(_section),
              padding: const EdgeInsets.only(top: 8, bottom: 24),
              children: [
                ...items,
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Text(
                    _section == _Section.rules
                        ? l.rulesDisclaimer
                        : l.techniqueDisclaimer,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _ruleList() {
    final l = context.l10n;
    final theme = Theme.of(context);
    return [
      Card(
        margin: const EdgeInsets.fromLTRB(12, 4, 12, 8),
        color: theme.colorScheme.primaryContainer,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.campaign_outlined,
                color: theme.colorScheme.onPrimaryContainer,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  rulesHighlight,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      for (final (i, r) in ruleSections.indexed)
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          clipBehavior: Clip.antiAlias,
          child: ExpansionTile(
            // Egen nøgle, så åben/lukket gemmes pr. sektion og ikke blandes
            // sammen med listens scroll-position.
            key: PageStorageKey('rule_${r.id}'),
            // Pointsystemet er det vigtigste, så det er foldet ud fra start.
            initiallyExpanded: i == 0,
            shape: const Border(),
            title: Text(r.title, style: theme.textTheme.titleMedium),
            childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (r.intro != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(r.intro!),
                ),
              _Bullets(r.points),
              Text(
                l.rulesSource(r.source),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
    ];
  }

  List<Widget> _techniqueList(
    TechniqueKind kind,
    Map<String, TechniqueUsage> usage,
  ) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final result = <Widget>[];
    String? category;
    final list = [
      for (final t in techniquesOfKind(kind))
        if (techniqueMatches(t, _query)) t,
    ];
    if (list.isEmpty) return [_noResults()];
    for (final t in list) {
      if (t.category != category) {
        category = t.category;
        result.add(
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Text(
              category,
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ),
        );
      }
      final last = usage[t.id]?.lastTrained;
      result.add(
        ListTile(
          title: Text(t.name),
          subtitle: Text(
            last == null
                ? l.neverTrained
                : l.lastTrained(context.formatDate(last)),
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => openTechnique(context, t),
        ),
      );
    }
    return result;
  }

  List<Widget> _drillList() {
    final l = context.l10n;
    final list = filterDrills(
      query: _query,
      level: _level,
      group: _group,
      maxMinutes: _short ? 10 : null,
    );
    return [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Wrap(
          spacing: 8,
          runSpacing: 4,
          children: [
            ChoiceChip(
              label: Text(l.drillAllLevels),
              selected: _level == null,
              onSelected: (_) => setState(() => _level = null),
            ),
            for (final level in DrillLevel.values)
              ChoiceChip(
                label: Text(level.label(l)),
                selected: _level == level,
                onSelected: (_) => setState(() => _level = level),
              ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
        child: Wrap(
          spacing: 8,
          runSpacing: 4,
          children: [
            for (final (group, label) in [
              (DrillGroup.solo, l.drillFilterSolo),
              (DrillGroup.pair, l.drillFilterPair),
              (DrillGroup.group, l.drillFilterGroup),
            ])
              FilterChip(
                label: Text(label),
                selected: _group == group,
                onSelected: (on) => setState(() => _group = on ? group : null),
              ),
            FilterChip(
              avatar: const Icon(Icons.timer_outlined, size: 18),
              label: Text(l.drillFilterShort),
              selected: _short,
              onSelected: (on) => setState(() => _short = on),
            ),
          ],
        ),
      ),
      if (list.isEmpty) _noResults(),
      for (final d in list)
        ListTile(
          title: Text(d.name),
          subtitle: Text(_drillFacts(context, d)),
          trailing: d.timer == null
              ? const Icon(Icons.chevron_right)
              : const Icon(Icons.timer_outlined),
          onTap: () => openDrill(context, d),
        ),
    ];
  }
}

String _drillFacts(BuildContext context, Drill d) {
  final l = context.l10n;
  return [
    d.level.label(l),
    l.drillPlayers(d.minPlayers),
    l.minutesShort(d.minutes),
  ].join(' · ');
}

Future<void> openTechnique(BuildContext context, Technique t) => Navigator.of(
  context,
).push(MaterialPageRoute(builder: (_) => TechniqueDetailScreen(technique: t)));

Future<void> openDrill(BuildContext context, Drill d) =>
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => DrillDetailScreen(drill: d)));

/// Punktopstilling af tekster.
class _Bullets extends StatelessWidget {
  const _Bullets(this.items, {this.numbered = false});

  final List<String> items;
  final bool numbered;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodyMedium;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < items.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 24,
                  child: Text(numbered ? '${i + 1}.' : '•', style: style),
                ),
                Expanded(child: Text(items[i], style: style)),
              ],
            ),
          ),
      ],
    );
  }
}

class TechniqueDetailScreen extends StatelessWidget {
  const TechniqueDetailScreen({super.key, required this.technique});

  final Technique technique;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final state = context.watch<AppState>();
    final now = DateTime.now();
    final since = addDays(DateTime(now.year, now.month, now.day), -7 * 12);
    final usage = techniqueUsage(
      state.activeTrainings,
      since: since,
    )[technique.id];
    final related = drillsFor(technique.id);
    final t = technique;

    return Scaffold(
      appBar: AppBar(title: Text(t.name)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () =>
            openTrainingForm(context, prefill: TrainingPrefill.forTechnique(t)),
        icon: const Icon(Icons.add),
        label: Text(l.logTraining),
      ),
      body: ContentWidth(
        maxWidth: 760,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 88),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 0, 4, 12),
              child: Text(t.summary, style: theme.textTheme.bodyLarge),
            ),
            SectionCard(
              title: l.techniqueYourTraining,
              child: Text(
                usage?.lastTrained == null
                    ? l.neverTrained
                    : [
                        l.techniqueSessions12w(usage!.sessions),
                        l.lastTrained(context.formatDate(usage.lastTrained!)),
                      ].join('\n'),
              ),
            ),
            SectionCard(title: l.techniqueWhenToUse, child: Text(t.whenToUse)),
            SectionCard(
              title: l.techniqueKeyPoints,
              child: _Bullets(t.keyPoints),
            ),
            SectionCard(
              title: l.techniqueMistakes,
              child: _Bullets(t.commonMistakes),
            ),
            if (related.isNotEmpty)
              SectionCard(
                title: l.techniqueDrills,
                child: Column(
                  children: [
                    for (final d in related)
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(d.name),
                        subtitle: Text(_drillFacts(context, d)),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => openDrill(context, d),
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

class DrillDetailScreen extends StatelessWidget {
  const DrillDetailScreen({super.key, required this.drill});

  final Drill drill;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final d = drill;

    return Scaffold(
      appBar: AppBar(
        title: Text(d.name),
        actions: [
          if (d.timer != null)
            TextButton.icon(
              icon: const Icon(Icons.timer_outlined),
              label: Text(l.timerStart),
              onPressed: () => openTimer(context, d),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () =>
            openTrainingForm(context, prefill: TrainingPrefill.forDrill(d)),
        icon: const Icon(Icons.add),
        label: Text(l.logThisDrill),
      ),
      body: ContentWidth(
        maxWidth: 760,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 88),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
              child: Text(d.purpose, style: theme.textTheme.bodyLarge),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 0, 4, 12),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Chip(
                    avatar: const Icon(Icons.signal_cellular_alt, size: 18),
                    label: Text(d.level.label(l)),
                  ),
                  Chip(
                    avatar: const Icon(Icons.group_outlined, size: 18),
                    label: Text(l.drillPlayers(d.minPlayers)),
                  ),
                  Chip(
                    avatar: const Icon(Icons.timer_outlined, size: 18),
                    label: Text(l.minutesShort(d.minutes)),
                  ),
                  if (d.timer case final t?)
                    ActionChip(
                      avatar: const Icon(Icons.play_arrow, size: 18),
                      label: Text(
                        l.timerPlan(t.workSeconds, t.restSeconds, t.rounds),
                      ),
                      onPressed: () => openTimer(context, d),
                    ),
                ],
              ),
            ),
            SectionCard(
              title: l.drillSteps,
              child: _Bullets(d.steps, numbered: true),
            ),
            SectionCard(title: l.drillTips, child: _Bullets(d.tips)),
            SectionCard(
              title: l.drillTrains,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final id in d.techniqueIds)
                    if (techniqueById(id) case final t?)
                      ActionChip(
                        avatar: Icon(t.kind.icon, size: 18),
                        label: Text(t.name),
                        onPressed: () => openTechnique(context, t),
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
