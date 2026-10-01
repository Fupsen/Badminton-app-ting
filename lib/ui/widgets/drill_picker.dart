import 'package:flutter/material.dart';

import '../../content/technique.dart';
import '../labels.dart';

/// Lader brugeren vælge en øvelse i et ark med søgning. Øvelser i
/// [selected] får et flueben. Returnerer null, hvis arket lukkes.
Future<Drill?> pickDrill(
  BuildContext context, {
  Set<String> selected = const {},
}) => showModalBottomSheet<Drill>(
  context: context,
  isScrollControlled: true,
  showDragHandle: true,
  builder: (context) => _DrillPicker(selected: selected),
);

class _DrillPicker extends StatefulWidget {
  const _DrillPicker({required this.selected});

  final Set<String> selected;

  @override
  State<_DrillPicker> createState() => _DrillPickerState();
}

class _DrillPickerState extends State<_DrillPicker> {
  var _query = '';

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final found = filterDrills(query: _query);
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      maxChildSize: 0.95,
      builder: (context, controller) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l.chooseDrill,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                TextField(
                  decoration: InputDecoration(
                    hintText: l.searchHint,
                    prefixIcon: const Icon(Icons.search),
                    isDense: true,
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (v) => setState(() => _query = v),
                ),
              ],
            ),
          ),
          Expanded(
            child: found.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(l.searchNoResults),
                  )
                : ListView(
                    controller: controller,
                    children: [
                      for (final d in found)
                        ListTile(
                          title: Text(d.name),
                          subtitle: Text(
                            techniqueNames(d.techniqueIds).join(', '),
                          ),
                          trailing: widget.selected.contains(d.id)
                              ? const Icon(Icons.check)
                              : null,
                          onTap: () => Navigator.pop(context, d),
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
