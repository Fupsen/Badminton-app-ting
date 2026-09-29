import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/backup.dart';
import '../data/backup_files.dart';
import '../l10n/app_localizations.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import 'labels.dart';
import 'widgets/common.dart';

Future<void> openBackupScreen(BuildContext context) => Navigator.of(context)
    .push(MaterialPageRoute(builder: (_) => const BackupScreen()));

class BackupScreen extends StatelessWidget {
  const BackupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final l = context.l10n;
    final theme = Theme.of(context);
    final last = state.lastBackupAt;

    return Scaffold(
      appBar: AppBar(title: Text(l.backupTitle)),
      body: ContentWidth(
        maxWidth: 700,
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 4, 4, 12),
              child: Text(l.backupIntro, style: theme.textTheme.bodyLarge),
            ),
            Card(
              child: ListTile(
                leading: Icon(
                  last == null ? Icons.cloud_off_outlined : Icons.history,
                  color: last == null
                      ? theme.colorScheme.error
                      : theme.colorScheme.primary,
                ),
                title: Text(last == null
                    ? l.backupNever
                    : l.backupLast(context.formatDate(last))),
              ),
            ),
            SectionCard(
              title: l.backupExport,
              subtitle: l.backupExportHint,
              child: Builder(
                // Egen context, så delingsmenuen på iPad kan placeres ved
                // knappen.
                builder: (buttonContext) => FilledButton.icon(
                  onPressed: () => _export(buttonContext),
                  icon: const Icon(Icons.upload_file),
                  label: Text(l.backupExport),
                ),
              ),
            ),
            SectionCard(
              title: l.backupImport,
              subtitle: l.backupImportHint,
              child: FilledButton.tonalIcon(
                onPressed: () => importBackupFlow(context),
                icon: const Icon(Icons.download),
                label: Text(l.backupImport),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _export(BuildContext context) async {
    final l = context.l10n;
    final state = context.read<AppState>();
    final files = context.read<BackupFiles>();
    final messenger = ScaffoldMessenger.of(context);
    final box = context.findRenderObject() as RenderBox?;
    final origin =
        box == null ? null : box.localToGlobal(Offset.zero) & box.size;

    final now = DateTime.now();
    try {
      final saved = await files.save(
        backupFileName(now),
        state.exportBackup(now),
        sharePositionOrigin: origin,
      );
      if (!saved) return;
      await state.markBackedUp(now);
      messenger.showSnackBar(SnackBar(content: Text(l.backupExportDone)));
    } catch (e) {
      messenger.showSnackBar(
          SnackBar(content: Text(l.backupExportFailed(e.toString()))));
    }
  }
}

/// Lader brugeren vælge en backup-fil og indlæser den. Er der ingen data i
/// forvejen (fx på en ny telefon), indlæses den direkte; ellers spørges der,
/// om den skal flettes ind eller erstatte alt.
Future<void> importBackupFlow(BuildContext context) async {
  final l = context.l10n;
  final state = context.read<AppState>();
  final files = context.read<BackupFiles>();
  final messenger = ScaffoldMessenger.of(context);
  void show(String text) =>
      messenger.showSnackBar(SnackBar(content: Text(text)));

  final String? text;
  try {
    text = await files.pickAndRead();
  } catch (e) {
    show(l.backupImportFailed(e.toString()));
    return;
  }
  if (text == null) return;

  final AppData incoming;
  try {
    incoming = decodeBackup(text);
  } on BackupFormatException catch (e) {
    show(e.tooNew ? l.backupTooNew : l.backupInvalidFile);
    return;
  }

  if (state.players.isEmpty) {
    await state.importBackup(incoming, replace: true);
    show(l.backupImportDone);
    return;
  }
  if (!context.mounted) return;

  final choice = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l.backupImportTitle),
      content: Text([
        l.backupImportContains(_summary(l, incoming)),
        l.backupImportMergeInfo,
        l.backupImportReplaceInfo,
      ].join('\n\n')),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l.cancel),
        ),
        TextButton(
          style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error),
          onPressed: () => Navigator.pop(context, true),
          child: Text(l.backupReplace),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(l.backupMerge),
        ),
      ],
    ),
  );
  if (choice == null || !context.mounted) return;

  final replace = choice;
  if (replace &&
      !await confirmDelete(context, l.backupReplaceConfirmTitle,
          body: l.backupReplaceConfirmBody, confirmLabel: l.backupReplace)) {
    return;
  }
  await state.importBackup(incoming, replace: replace);
  show(l.backupImportDone);
}

String _summary(AppLocalizations l, AppData data) => [
      l.countPlayers(data.players.length),
      l.countMatches(data.matches.length),
      l.countTrainings(data.trainings.length),
      l.countGoals(data.goals.length),
    ].join(', ');
