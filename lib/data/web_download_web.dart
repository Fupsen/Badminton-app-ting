import 'dart:js_interop';

import 'package:web/web.dart' as web;

/// Starter en download af [contents] som en fil. På iPhone havner filen i
/// Filer-appen under Overførsler.
void downloadTextFile(String fileName, String contents) {
  final blob = web.Blob(
    [contents.toJS].toJS,
    web.BlobPropertyBag(type: 'application/json'),
  );
  final url = web.URL.createObjectURL(blob);
  final anchor = web.HTMLAnchorElement()
    ..href = url
    ..download = fileName
    ..style.display = 'none';
  web.document.body!.append(anchor);
  anchor.click();
  anchor.remove();
  // Giv browseren tid til at starte downloaden, før adressen frigives.
  Future<void>.delayed(
    const Duration(seconds: 30),
    () => web.URL.revokeObjectURL(url),
  );
}
