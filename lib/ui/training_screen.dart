import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

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
                    thisWeek.single.sessions, thisWeek.single.totalMinutes),
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
      if (session.notes.isNotEmpty) session.notes,
    ].join(' · ');
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: session.type.color.withValues(alpha: 0.15),
        foregroundColor: session.type.color,
        child: Icon(session.type.icon),
      ),
      title: Text(
          '${session.type.label(l)} · ${l.minutesShort(session.durationMinutes)}'),
      subtitle: Text(details, maxLines: 2, overflow: TextOverflow.ellipsis),
      onTap: () => openTrainingForm(context, existing: session),
    );
  }
}

Future<void> openTrainingForm(BuildContext context,
        {TrainingSession? existing}) =>
    Navigator.of(context).push(MaterialPageRoute(
      fullscreenDialog: true,
      builder: (_) => TrainingForm(existing: existing),
    ));

class TrainingForm extends StatefulWidget {
  const TrainingForm({super.key, this.existing});

  final TrainingSession? existing;

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

  @override
  void initState() {
    super.initState();
    final t = widget.existing;
    _date = t?.date ?? DateTime.now();
    _type = t?.type ?? TrainingType.technique;
    _intensity = t?.intensity ?? 3;
    _duration =
        TextEditingController(text: (t?.durationMinutes ?? 90).toString());
    _notes = TextEditingController(text: t?.notes ?? '');
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
    await state.saveTraining(TrainingSession(
      id: widget.existing?.id ?? newId(),
      playerId: widget.existing?.playerId ?? state.activePlayer!.id,
      date: _date,
      durationMinutes: int.parse(_duration.text),
      type: _type,
      intensity: _intensity,
      notes: _notes.text.trim(),
    ));
    if (mounted) Navigator.pop(context);
  }

  Future<void> _delete() async {
    final state = context.read<AppState>();
    if (await confirmDelete(context, context.l10n.deleteTrainingTitle)) {
      await state.deleteTraining(widget.existing!.id);
      if (mounted) Navigator.pop(context);
    }
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
              Text('${l.intensityLabel}: ${intensityLabel(l, _intensity)}',
                  style: theme.textTheme.titleSmall),
              Slider(
                value: _intensity.toDouble(),
                min: 1,
                max: 5,
                divisions: 4,
                label: intensityLabel(l, _intensity),
                onChanged: (v) => setState(() => _intensity = v.round()),
              ),
              const SizedBox(height: 16),
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
