import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../content/technique.dart';
import '../logic/stats.dart';
import '../logic/technique_stats.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import 'labels.dart';
import 'widgets/common.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  bool _includePractice = false;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final allMatches = state.activeMatches;
    final hasPractice = allMatches.any((m) => m.practice);
    final matches = _includePractice
        ? allMatches
        : competitiveOnly(allMatches).toList();
    final trainings = state.activeTrainings;
    final l = context.l10n;
    final overall = WinStats.of(matches);
    final byType = winStatsByType(matches);
    final streak = currentStreak(matches);
    final opponents = headToHead(matches).take(10).toList();

    return ContentWidth(
      child: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          if (hasPractice)
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: FilterChip(
                  label: Text(l.statsIncludePractice),
                  selected: _includePractice,
                  onSelected: (v) => setState(() => _includePractice = v),
                ),
              ),
            ),
          SectionCard(
            title: l.statsWinRateSection,
            child: matches.isEmpty
                ? Text(l.statsNoMatches)
                : ResponsiveGrid(
                    minItemWidth: 160,
                    children: [
                      _winTile(context, l.statsOverall, overall),
                      for (final t in MatchType.values)
                        _winTile(context, t.label(l), byType[t]!),
                    ],
                  ),
          ),
          SectionCard(
            title: l.statsTrainingSection,
            subtitle: l.statsTrainingHint,
            child: trainings.isEmpty
                ? Text(l.statsNoTraining)
                : TrainingChart(
                    weeks: weeklyTraining(trainings, now: DateTime.now()),
                  ),
          ),
          SectionCard(
            title: l.statsTechniqueSection,
            subtitle: l.statsTechniqueHint,
            child: trainings.any((t) => t.techniqueIds.isNotEmpty)
                ? TechniqueUsageList(trainings: trainings)
                : Text(l.statsTechniqueNone),
          ),
          if (matches.isNotEmpty)
            SectionCard(
              title: l.statsFormSection,
              subtitle: l.recentFormHint,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FormRow(results: recentForm(matches)),
                  const SizedBox(height: 12),
                  ResponsiveGrid(
                    minItemWidth: 160,
                    children: [
                      StatTile(
                        label: l.statCurrentStreak,
                        value: streak == null
                            ? l.noData
                            : streak.won
                            ? l.streakWins(streak.length)
                            : l.streakLosses(streak.length),
                      ),
                      StatTile(
                        label: l.statsLongestWinStreak,
                        value: l.streakWins(longestWinStreak(matches)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l.statsPointDiff,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 12),
                  PointDiffChart(values: pointDiffSeries(matches, last: 20)),
                ],
              ),
            ),
          if (opponents.isNotEmpty)
            SectionCard(
              title: l.statsOpponentsSection,
              child: Column(
                children: [
                  for (final o in opponents)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(o.name),
                      subtitle: Text(l.statsWonLost(o.stats.won, o.stats.lost)),
                      trailing: Text(
                        percent(o.stats.rate, l.noData),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _winTile(BuildContext context, String label, WinStats stats) {
    final l = context.l10n;
    return StatTile(
      label: label,
      value: percent(stats.rate, l.noData),
      detail: l.statsWonLost(stats.won, stats.lost),
    );
  }
}

/// Stablet søjlediagram med træningsminutter pr. uge fordelt på type.
class TrainingChart extends StatelessWidget {
  const TrainingChart({super.key, required this.weeks});

  final List<WeekTraining> weeks;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final maxMinutes = weeks.fold(
      0,
      (m, w) => w.totalMinutes > m ? w.totalMinutes : m,
    );
    final usedTypes = TrainingType.values
        .where((t) => weeks.any((w) => (w.minutesByType[t] ?? 0) > 0))
        .toList();
    final labelStyle = theme.textTheme.bodySmall;
    final axis = _niceAxis(maxMinutes, const [30, 60, 120, 180, 300, 600]);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 220,
          child: BarChart(
            BarChartData(
              maxY: axis.max,
              gridData: FlGridData(
                drawVerticalLine: false,
                horizontalInterval: axis.interval,
                getDrawingHorizontalLine: (_) => FlLine(
                  color: theme.colorScheme.outlineVariant,
                  strokeWidth: 1,
                ),
              ),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(),
                rightTitles: const AxisTitles(),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    interval: axis.interval,
                    getTitlesWidget: (value, meta) => SideTitleWidget(
                      meta: meta,
                      child: Text(meta.formattedValue, style: labelStyle),
                    ),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) => SideTitleWidget(
                      meta: meta,
                      child: Text(
                        '${isoWeekNumber(weeks[value.toInt()].weekStart)}',
                        style: labelStyle,
                      ),
                    ),
                  ),
                ),
              ),
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  getTooltipColor: (_) => theme.colorScheme.inverseSurface,
                  getTooltipItem: (group, _, rod, _) {
                    final week = weeks[group.x];
                    return BarTooltipItem(
                      '${l.statsWeekLabel(isoWeekNumber(week.weekStart))}\n'
                      '${l.minutesShort(week.totalMinutes)}',
                      TextStyle(color: theme.colorScheme.onInverseSurface),
                    );
                  },
                ),
              ),
              barGroups: [
                for (var i = 0; i < weeks.length; i++)
                  BarChartGroupData(x: i, barRods: [_rod(weeks[i])]),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 16,
          runSpacing: 4,
          children: [
            for (final t in usedTypes)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: t.color,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(t.label(l), style: labelStyle),
                ],
              ),
          ],
        ),
      ],
    );
  }

  BarChartRodData _rod(WeekTraining week) {
    var from = 0.0;
    final items = <BarChartRodStackItem>[];
    for (final t in TrainingType.values) {
      final minutes = (week.minutesByType[t] ?? 0).toDouble();
      if (minutes == 0) continue;
      items.add(BarChartRodStackItem(from, from + minutes, t.color));
      from += minutes;
    }
    return BarChartRodData(
      toY: from,
      width: 16,
      color: Colors.transparent,
      rodStackItems: items,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
    );
  }
}

/// Linjediagram over pointforskellen i hver kamp. Over 0 = vundet flere
/// point end modstanderen.
class PointDiffChart extends StatelessWidget {
  const PointDiffChart({super.key, required this.values});

  final List<int> values;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final labelStyle = theme.textTheme.bodySmall;
    final extreme = values.fold(0, (m, v) => v.abs() > m ? v.abs() : m);
    final axis = _niceAxis(extreme, const [5, 10, 20]);
    return SizedBox(
      height: 180,
      child: LineChart(
        LineChartData(
          minY: -axis.max,
          maxY: axis.max,
          minX: 0,
          maxX: values.length <= 1 ? 1 : (values.length - 1).toDouble(),
          borderData: FlBorderData(show: false),
          gridData: const FlGridData(show: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(),
            rightTitles: const AxisTitles(),
            bottomTitles: const AxisTitles(),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 36,
                interval: axis.interval,
                getTitlesWidget: (value, meta) => SideTitleWidget(
                  meta: meta,
                  child: Text(meta.formattedValue, style: labelStyle),
                ),
              ),
            ),
          ),
          extraLinesData: ExtraLinesData(
            horizontalLines: [
              HorizontalLine(
                y: 0,
                color: theme.colorScheme.outline,
                strokeWidth: 1,
                dashArray: [4, 4],
              ),
            ],
          ),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) => theme.colorScheme.inverseSurface,
              getTooltipItems: (spots) => [
                for (final s in spots)
                  LineTooltipItem(
                    s.y > 0 ? '+${s.y.toInt()}' : '${s.y.toInt()}',
                    TextStyle(color: theme.colorScheme.onInverseSurface),
                  ),
              ],
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: [
                for (var i = 0; i < values.length; i++)
                  FlSpot(i.toDouble(), values[i].toDouble()),
              ],
              color: theme.colorScheme.primary,
              barWidth: 2.5,
              dotData: FlDotData(
                getDotPainter: (spot, _, _, _) => FlDotCirclePainter(
                  radius: 4,
                  color: spot.y >= 0
                      ? ResultBadge.winColor
                      : ResultBadge.lossColor,
                  strokeWidth: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Vælger et rundt interval (højst 5 streger) og et loft over [max], så
/// akserne viser pæne tal i stedet for fx 465,7.
({double max, double interval}) _niceAxis(int max, List<int> intervals) {
  final interval = intervals.firstWhere(
    (i) => max / i <= 5,
    orElse: () => intervals.last,
  );
  final steps = (max / interval).floor() + 1;
  return (max: (steps * interval).toDouble(), interval: interval.toDouble());
}

/// Vandrette bjælker med antal træningspas pr. slag/benarbejde de seneste 12
/// uger, og hvad der ikke er trænet i over 30 dage.
class TechniqueUsageList extends StatelessWidget {
  const TechniqueUsageList({super.key, required this.trainings});

  final List<TrainingSession> trainings;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final usage = techniqueUsage(trainings, since: addDays(today, -7 * 12));
    final rows = [
      for (final t in techniques)
        if ((usage[t.id]?.sessions ?? 0) > 0) (t, usage[t.id]!.sessions),
    ]..sort((a, b) => b.$2.compareTo(a.$2));
    final max = rows.isEmpty ? 1 : rows.first.$2;
    final staleBefore = addDays(today, -30);
    final stale = [
      for (final t in techniques)
        if (usage[t.id]?.lastTrained?.isBefore(staleBefore) ?? true) t,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final (t, count) in rows)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                SizedBox(
                  width: 150,
                  child: Text(t.name, overflow: TextOverflow.ellipsis),
                ),
                Expanded(
                  child: LinearProgressIndicator(
                    value: count / max,
                    minHeight: 10,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                SizedBox(
                  width: 36,
                  child: Text('$count', textAlign: TextAlign.end),
                ),
              ],
            ),
          ),
        if (stale.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(l.statsNotTrained30, style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final t in stale)
                Chip(
                  avatar: Icon(t.kind.icon, size: 16),
                  label: Text(t.name),
                  visualDensity: VisualDensity.compact,
                ),
            ],
          ),
        ],
      ],
    );
  }
}
