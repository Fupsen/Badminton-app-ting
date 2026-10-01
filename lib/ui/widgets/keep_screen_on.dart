import 'package:flutter/widgets.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

/// Holder skærmen tændt, så længe [child] vises, fx i kamptælleren og
/// timeren. Fejler det (fx en browser uden Wake Lock), sker der bare ingenting.
class KeepScreenOn extends StatefulWidget {
  const KeepScreenOn({super.key, required this.child});

  final Widget child;

  @override
  State<KeepScreenOn> createState() => _KeepScreenOnState();
}

class _KeepScreenOnState extends State<KeepScreenOn> {
  @override
  void initState() {
    super.initState();
    _set(true);
  }

  @override
  void dispose() {
    _set(false);
    super.dispose();
  }

  static void _set(bool on) {
    try {
      WakelockPlus.toggle(enable: on).catchError((Object _) {});
    } on Object {
      // Ikke understøttet her.
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
