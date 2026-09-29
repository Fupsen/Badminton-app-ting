import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../content/technique.dart';
import '../logic/stats.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import 'labels.dart';
import 'widgets/common.dart';
import 'widgets/date_field.dart';

class TrainingScreen extends StatelessWidget {
  const TrainingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sessions = context.watch<AppState>().activeTrainings;
    final l = context.l10n;
    if (sessions.isEmpty) {
      return EmptyState(icon: Icons.fitness_center, message: l.noTrainings);
    }
    final thisWeek = weeklyTraining(sessions, weeks: 1, now: DateTime.now());
    return ContentWidth(
      child: ListView.separated(
        padding: const EdgeInsets.only(bottom: 88),
        itemCount: sessions.length + 1,
        separatorBuilder: (_, i) =>
            i == 0 ? const SizedBox.shrink() : const Divider(height: 1),
        itemBuilder: (context, i) {
          if (i == 0) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                l.thisWeekSummary(
                  thisWeek.single.sessions,
                  thisWeek.single.totalMinutes,
                ),
                style: Theme.of(context).textTheme.titleSmall,
              ),
            );
          }
          return TrainingTile(session: sessions[i - 1]);
        },
      ),
    );
  }
}

class TrainingTile extends StatelessWidget {
  const TrainingTile({super.key, required this.session});

  final TrainingSession session;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final details = [
      context.formatDate(session.date),
      l.intensityShort(session.intensity),
      if (session.techniqueIds.isNotEmpty)
        techniqueNames(session.techniqueIds).join(', '),
      if (session.notes.isNotEmpty) session.notes,
    ].join(' · ');
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: session.type.color.withValues(alpha: 0.15),
        foregroundColor: session.type.color,
        child: Icon(session.type.icon),
      ),
      title: Text(
        '${session.type.label(l)} · ${l.minutesShort(session.durationMinutes)}',
      ),
      subtitle: Text(details, maxLines: 2, overflow: TextOverflow.ellipsis),
      onTap: () => openTrainingForm(context, existing: session),
    );
  }
}

/// Forudfyldte værdier til en ny træning, fx fra en øvelse i Teknik-fanen.
class TrainingPrefill {
  const TrainingPrefill({
    this.techniqueIds = const [],
    this.drillIds = const [],
    this.type,
    this.minutes,
  });

  factory TrainingPrefill.forDrill(Drill drill) => TrainingPrefill(
    techniqueIds: drill.techniqueIds,
    drillIds: [drill.id],
    type: _typeFor(drill.techniqueIds),
    minutes: drill.minutes,
  );

  factory TrainingPrefill.forTechnique(Technique technique) => TrainingPrefill(
    techniqueIds: [technique.id],
    type: _typeFor([technique.id]),
  );

  final List<String> techniqueIds;
  final List<String> drillIds;
  final TrainingType? type;
  final int? minutes;

  /// Rent benarbejde logges som footwork, alt andet som teknik.
  static TrainingType _typeFor(List<String> ids) =>
      ids.every((id) => techniqueById(id)?.kind == TechniqueKind.footwork)
      ? TrainingType.footwork
      : TrainingType.technique;
}

Future<void> openTrainingForm(
  BuildContext context, {
  TrainingSession? existing,
  TrainingPrefill? prefill,
}) => Navigator.of(context).push(
  MaterialPageRoute(
    fullscreenDialog: true,
    builder: (_) => TrainingForm(existing: existing, prefill: prefill),
  ),
);

class TrainingForm extends StatefulWidget {
  const TrainingForm({super.key, this.existing, this.prefill});

  final TrainingSession? existing;

  /// Bruges kun når [existing] er null.
  final TrainingPrefill? prefill;

  @override
  State<TrainingForm> createState() => _TrainingFormState();
}

class _TrainingFormState extends State<TrainingForm> {
  static const _quickDurations = [30, 60, 90, 120];

  final _formKey = GlobalKey<FormState>();
  late DateTime _date;
  late TrainingType _type;
  late int _intensity;
  late final TextEditingController _duration;
  late final TextEditingController _notes;

  // Rækkefølgen bevares, så valgene vises i den rækkefølge de blev valgt.
  late final Set<String> _techniqueIds;
  late final Set<String> _drillIds;

  @override
  void initState() {
    super.initState();
    final t = widget.existing;
    final p = t == null ? widget.prefill : null;
    _date = t?.date ?? DateTime.now();
    _type = t?.type ?? p?.type ?? TrainingType.technique;
    _intensity = t?.intensity ?? 3;
    _duration = TextEditingController(
      text: (t?.durationMinutes ?? p?.minutes ?? 90).toString(),
    );
    _notes = TextEditingController(text: t?.notes ?? '');
    _techniqueIds = {...?t?.techniqueIds, ...?p?.techniqueIds};
    _drillIds = {...?t?.drillIds, ...?p?.drillIds};
  }

  Future<void> _pickDrill() async {
    final l = context.l10n;
    final drill = await showModalBottomSheet<Drill>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        maxChildSize: 0.95,
        builder: (context, controller) => ListView(
          controller: controller,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Text(
                l.chooseDrill,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            for (final d in drills)
              ListTile(
                title: Text(d.name),
                subtitle: Text(techniqueNames(d.techniqueIds).join(', ')),
                trailing: _drillIds.contains(d.id)
                    ? const Icon(Icons.check)
                    : null,
                onTap: () => Navigator.pop(context, d),
              ),
          ],
        ),
      ),
    );
    if (drill == null) return;
    setState(() {
      _drillIds.add(drill.id);
      _techniqueIds.addAll(drill.techniqueIds);
    });
  }

  @override
  void dispose() {
    _duration.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final state = context.read<AppState>();
    if (!_formKey.currentState!.validate()) return;
    await state.saveTraining(
      TrainingSession(
        id: widget.existing?.id ?? newId(),
        playerId: widget.existing?.playerId ?? state.activePlayer!.id,
        date: _date,
        durationMinutes: int.parse(_duration.text),
        type: _type,
        intensity: _intensity,
        notes: _notes.text.trim(),
        techniqueIds: _techniqueIds.toList(),
        drillIds: _drillIds.toList(),
      ),
    );
    if (mounted) Navigator.pop(context);
  }

  Future<void> _delete() async {
    final state = context.read<AppState>();
    if (await confirmDelete(context, context.l10n.deleteTrainingTitle)) {
      await state.deleteTraining(widget.existing!.id);
      if (mounted) Navigator.pop(context);
    }
  }

  /// "Hvad trænede du?": slag, benarbejde og øvelser fra teknik-biblioteket.
  List<Widget> _focusSection() {
    final l = context.l10n;
    final theme = Theme.of(context);
    Widget label(String text) => Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 6),
      child: Text(text, style: theme.textTheme.labelLarge),
    );
    Widget chips(TechniqueKind kind) => Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        for (final t in techniquesOfKind(kind))
          FilterChip(
            label: Text(t.name),
            selected: _techniqueIds.contains(t.id),
            onSelected: (on) => setState(
              () => on ? _techniqueIds.add(t.id) : _techniqueIds.remove(t.id),
            ),
          ),
      ],
    );
    return [
      Text(l.trainingFocusTitle, style: theme.textTheme.titleSmall),
      label(l.techniqueStrokes),
      chips(TechniqueKind.stroke),
      label(l.techniqueFootwork),
      chips(TechniqueKind.footwork),
      label(l.techniqueDrills),
      Wrap(
        spacing: 6,
        runSpacing: 6,
        children: [
          for (final id in _drillIds)
            if (drillById(id) case final d?)
              InputChip(
                label: Text(d.name),
                onDeleted: () => setState(() => _drillIds.remove(id)),
              ),
          ActionChip(
            avatar: const Icon(Icons.add, size: 18),
            label: Text(l.addDrill),
            onPressed: _pickDrill,
          ),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existing == null ? l.newTraining : l.editTraining),
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
              TextFormField(
                controller: _duration,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(3),
                ],
                decoration: InputDecoration(
                  labelText: l.durationLabel,
                  border: const OutlineInputBorder(),
                ),
                validator: (v) {
                  final n = int.tryParse(v ?? '');
                  return n == null || n <= 0 ? l.invalidNumber : null;
                },
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  for (final minutes in _quickDurations)
                    ChoiceChip(
                      label: Text(l.minutesShort(minutes)),
                      selected: _duration.text == '$minutes',
                      onSelected: (_) =>
                          setState(() => _duration.text = '$minutes'),
                    ),
                ],
              ),
              const SizedBox(height: 24),
              Text(l.trainingTypeLabel, style: theme.textTheme.titleSmall),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final t in TrainingType.values)
                    ChoiceChip(
                      avatar: Icon(t.icon, size: 18),
                      label: Text(t.label(l)),
                      selected: _type == t,
                      onSelected: (_) => setState(() => _type = t),
                    ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                '${l.intensityLabel}: ${intensityLabel(l, _intensity)}',
                style: theme.textTheme.titleSmall,
              ),
              Slider(
                value: _intensity.toDouble(),
                min: 1,
                max: 5,
                divisions: 4,
                label: intensityLabel(l, _intensity),
                onChanged: (v) => setState(() => _intensity = v.round()),
              ),
              const SizedBox(height: 16),
              ..._focusSection(),
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
}
