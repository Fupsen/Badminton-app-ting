import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'web_download.dart';

/// Gemmer og åbner backup-filer. Et interface, så tests kan bruge en falsk
/// implementation uden rigtige fildialoger.
abstract class BackupFiles {
  /// Gemmer (computer) eller deler (mobil) filen. Returnerer false, hvis
  /// brugeren annullerede.
  Future<bool> save(String fileName, String contents,
      {Rect? sharePositionOrigin});

  /// Lader brugeren vælge en fil og returnerer indholdet, eller null hvis
  /// brugeren annullerede.
  Future<String?> pickAndRead();
}

class PlatformBackupFiles implements BackupFiles {
  const PlatformBackupFiles();

  static const _jsonType = XTypeGroup(
    label: 'JSON',
    extensions: ['json'],
    mimeTypes: ['application/json'],
    uniformTypeIdentifiers: ['public.json'],
  );

  bool get _isMobile => Platform.isAndroid || Platform.isIOS;

  @override
  Future<bool> save(String fileName, String contents,
      {Rect? sharePositionOrigin}) async {
    if (_isMobile) {
      // Mobil har ingen "Gem som"-dialog; brug delingsmenuen i stedet, så
      // brugeren kan gemme i Filer, sende på mail, lægge i Drev osv.
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}${Platform.pathSeparator}$fileName');
      await file.writeAsString(contents, flush: true);
      final result = await SharePlus.instance.share(ShareParams(
        files: [XFile(file.path, mimeType: 'application/json')],
        subject: fileName,
        sharePositionOrigin: sharePositionOrigin,
      ));
      return result.status != ShareResultStatus.dismissed;
    }
    final location = await getSaveLocation(
      suggestedName: fileName,
      acceptedTypeGroups: const [_jsonType],
    );
    if (location == null) return false;
    await File(location.path).writeAsString(contents, flush: true);
    return true;
  }

  @override
  Future<String?> pickAndRead() async {
    final file = await openFile(
      // Android kender ikke altid .json som type; vis alle filer dér.
      acceptedTypeGroups: Platform.isAndroid ? const [] : const [_jsonType],
    );
    return file?.readAsString();
  }
}

/// Backup i webudgaven: eksport som download, import via filvælgeren.
class WebBackupFiles implements BackupFiles {
  const WebBackupFiles();

  @override
  Future<bool> save(
    String fileName,
    String contents, {
    Rect? sharePositionOrigin,
  }) async {
    downloadTextFile(fileName, contents);
    return true;
  }

  @override
  Future<String?> pickAndRead() async {
    // Intet filter: iPhone kender ikke altid .json som filtype, og filen
    // valideres alligevel, når den læses.
    final file = await openFile();
    return file?.readAsString();
  }
}
