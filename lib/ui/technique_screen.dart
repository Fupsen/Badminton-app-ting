import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../content/technique.dart';
import '../logic/stats.dart';
import '../logic/technique_stats.dart';
import '../state/app_state.dart';
import 'labels.dart';
import 'training_screen.dart';
import 'widgets/common.dart';

enum _Section { strokes, footwork, drills }

/// Teknik-fanen: bibliotek med slag, benarbejde og øvelser.
class TechniqueScreen extends StatefulWidget {
  const TechniqueScreen({super.key});

  @override
  State<TechniqueScreen> createState() => _TechniqueScreenState();
}

class _TechniqueScreenState extends State<TechniqueScreen> {
  _Section _section = _Section.strokes;
  DrillLevel? _level;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final state = context.watch<AppState>();
    final usage = techniqueUsage(state.activeTrainings);

    final List<Widget> items = switch (_section) {
      _Section.strokes => _techniqueList(TechniqueKind.stroke, usage),
      _Section.footwork => _techniqueList(TechniqueKind.footwork, usage),
      _Section.drills => _drillList(),
    };

    return ContentWidth(
      child: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: SegmentedButton<_Section>(
              segments: [
                ButtonSegment(
                  value: _Section.strokes,
                  label: Text(l.techniqueStrokes),
                ),
                ButtonSegment(
                  value: _Section.footwork,
                  label: Text(l.techniqueFootwork),
                ),
                ButtonSegment(
                  value: _Section.drills,
                  label: Text(l.techniqueDrills),
                ),
              ],
              selected: {_section},
              showSelectedIcon: false,
              onSelectionChanged: (s) => setState(() => _section = s.first),
            ),
          ),
          ...items,
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Text(
              l.techniqueDisclaimer,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _techniqueList(
    TechniqueKind kind,
    Map<String, TechniqueUsage> usage,
  ) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final result = <Widget>[];
    String? category;
    for (final t in techniquesOfKind(kind)) {
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
    return [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Wrap(
          spacing: 8,
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
      for (final d in drills)
        if (_level == null || d.level == _level)
          ListTile(
            title: Text(d.name),
            subtitle: Text(_drillFacts(context, d)),
            trailing: const Icon(Icons.chevron_right),
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
      appBar: AppBar(title: Text(d.name)),
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
