import 'package:flutter/material.dart';

import '../models/models.dart';
import 'labels.dart';

/// Dialog til navn, niveau og hånd. Returnerer den ændrede spiller, eller
/// null ved annullér.
Future<Player?> showPlayerEditor(BuildContext context, Player player) =>
    showDialog<Player>(
      context: context,
      builder: (_) => _PlayerEditor(player: player),
    );

class _PlayerEditor extends StatefulWidget {
  const _PlayerEditor({required this.player});

  final Player player;

  @override
  State<_PlayerEditor> createState() => _PlayerEditorState();
}

class _PlayerEditorState extends State<_PlayerEditor> {
  late final _name = TextEditingController(text: widget.player.name);
  late PlayerLevel? _level = widget.player.level;
  late bool _leftHanded = widget.player.leftHanded;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  void _save() {
    if (_name.text.trim().isEmpty) return;
    Navigator.pop(
      context,
      widget.player.copyWith(
        name: _name.text.trim(),
        level: () => _level,
        leftHanded: _leftHanded,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AlertDialog(
      title: Text(l.editPlayer),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _name,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(labelText: l.playerNameLabel),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<PlayerLevel?>(
              initialValue: _level,
              decoration: InputDecoration(labelText: l.playerLevel),
              items: [
                DropdownMenuItem(value: null, child: Text(l.playerLevelNone)),
                for (final level in PlayerLevel.values)
                  DropdownMenuItem(value: level, child: Text(level.label(l))),
              ],
              onChanged: (v) => setState(() => _level = v),
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l.playerLeftHanded),
              value: _leftHanded,
              onChanged: (v) => setState(() => _leftHanded = v),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l.cancel),
        ),
        FilledButton(onPressed: _save, child: Text(l.save)),
      ],
    );
  }
}
