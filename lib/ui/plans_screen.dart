import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../content/technique.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import 'labels.dart';
import 'plan_run_screen.dart';
import 'technique_screen.dart';
import 'widgets/common.dart';
import 'widgets/drill_picker.dart';

Future<void> openPlans(BuildContext context) =>
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const PlansScreen()));

Future<void> openPlanEditor(BuildContext context, {TrainingPlan? existing}) =>
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => PlanEditor(existing: existing),
      ),
    );

/// Træningsplaner: pas sat sammen af øvelser, som kan køres med timeren.
class PlansScreen extends StatelessWidget {
  const PlansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final plans = context.watch<AppState>().plans;
    return Scaffold(
      appBar: AppBar(title: Text(l.plansTitle)),
      floatingActionButton: FloatingActionButton(
        tooltip: l.newPlan,
        onPressed: () => openPlanEditor(context),
        child: const Icon(Icons.add),
      ),
      body: plans.isEmpty
          ? EmptyState(icon: Icons.list_alt, message: l.plansEmpty)
          : ContentWidth(
              child: ListView.separated(
                padding: const EdgeInsets.only(bottom: 88),
                itemCount: plans.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, i) {
                  final plan = plans[i];
                  return ListTile(
                    title: Text(plan.name),
                    subtitle: Text(
                      l.planSummary(plan.items.length, plan.totalMinutes),
                    ),
                    onTap: () => openPlanEditor(context, existing: plan),
                    trailing: IconButton.filledTonal(
                      tooltip: l.planStart,
                      icon: const Icon(Icons.play_arrow),
                      onPressed: plan.items.isEmpty
                          ? null
                          : () => openPlanRun(context, plan),
                    ),
                  );
                },
              ),
            ),
    );
  }
}

/// Opret eller ret en plan: navn og øvelser i rækkefølge med minutter.
class PlanEditor extends StatefulWidget {
  const PlanEditor({super.key, this.existing});

  final TrainingPlan? existing;

  @override
  State<PlanEditor> createState() => _PlanEditorState();
}

class _PlanEditorState extends State<PlanEditor> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final List<PlanItem> _items;
  var _showItemsError = false;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.existing?.name ?? '');
    _items = [...?widget.existing?.items];
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _add() async {
    final drill = await pickDrill(
      context,
      selected: {for (final i in _items) i.drillId},
    );
    if (drill == null) return;
    setState(() {
      _items.add(PlanItem(drillId: drill.id, minutes: drill.minutes));
      _showItemsError = false;
    });
  }

  void _setMinutes(int index, int minutes) {
    if (minutes < 1 || minutes > 180) return;
    setState(() => _items[index] = _items[index].copyWith(minutes: minutes));
  }

  Future<void> _save() async {
    final valid = _formKey.currentState!.validate();
    setState(() => _showItemsError = _items.isEmpty);
    if (!valid || _items.isEmpty) return;
    await context.read<AppState>().savePlan(
      TrainingPlan(
        id: widget.existing?.id ?? newId(),
        name: _name.text.trim(),
        createdAt: widget.existing?.createdAt ?? DateTime.now(),
        items: List.of(_items),
      ),
    );
    if (mounted) Navigator.pop(context);
  }

  Future<void> _delete() async {
    final l = context.l10n;
    final state = context.read<AppState>();
    if (await confirmDelete(context, l.deletePlanTitle)) {
      await state.deletePlan(widget.existing!.id);
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final total = _items.fold(0, (sum, i) => sum + i.minutes);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existing == null ? l.newPlan : l.editPlan),
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
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                sliver: SliverList.list(
                  children: [
                    TextFormField(
                      controller: _name,
                      decoration: InputDecoration(
                        labelText: l.planName,
                        border: const OutlineInputBorder(),
                      ),
                      textCapitalization: TextCapitalization.sentences,
                      validator: (v) =>
                          (v ?? '').trim().isEmpty ? l.planNameRequired : null,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l.planSummary(_items.length, total),
                      style: theme.textTheme.titleSmall,
                    ),
                    if (_items.length > 1)
                      Text(l.planReorderHint, style: theme.textTheme.bodySmall),
                  ],
                ),
              ),
              SliverReorderableList(
                itemCount: _items.length,
                onReorderItem: (from, to) =>
                    setState(() => _items.insert(to, _items.removeAt(from))),
                itemBuilder: (context, i) {
                  final item = _items[i];
                  final drill = drillById(item.drillId);
                  return ReorderableDelayedDragStartListener(
                    key: ObjectKey(item),
                    index: i,
                    child: Material(
                      child: ListTile(
                        leading: ReorderableDragStartListener(
                          index: i,
                          child: const Icon(Icons.drag_indicator),
                        ),
                        title: Text(drill?.name ?? item.drillId),
                        subtitle: Text(l.minutesShort(item.minutes)),
                        onTap: drill == null
                            ? null
                            : () => openDrill(context, drill),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              tooltip: l.planMinutesLess,
                              icon: const Icon(Icons.remove),
                              onPressed: () => _setMinutes(i, item.minutes - 1),
                            ),
                            IconButton(
                              tooltip: l.planMinutesMore,
                              icon: const Icon(Icons.add),
                              onPressed: () => _setMinutes(i, item.minutes + 1),
                            ),
                            IconButton(
                              tooltip: l.planRemoveDrill,
                              icon: const Icon(Icons.close),
                              onPressed: () =>
                                  setState(() => _items.removeAt(i)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                sliver: SliverList.list(
                  children: [
                    if (_showItemsError)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          l.planNoDrills,
                          style: TextStyle(color: theme.colorScheme.error),
                        ),
                      ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.add),
                        label: Text(l.planAddDrill),
                        onPressed: _add,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
