/// Download af en tekstfil i browseren. På andre platforme findes funktionen
/// også, men den kaster en fejl, fordi den kun bruges i webudgaven.
library;

export 'web_download_stub.dart'
    if (dart.library.js_interop) 'web_download_web.dart';
