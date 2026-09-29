/// Model for regel-sektionen i Teknik-fanen.
///
/// Indholdet ligger i `rules_da.dart` og skal stemme med
/// `docs/viden/regler.md`, som har kilderne.
library;

import 'rules_da.dart' as da;

class RuleSection {
  const RuleSection({
    required this.id,
    required this.title,
    required this.points,
    required this.source,
    this.intro,
  });

  final String id;
  final String title;

  /// Valgfri indledning før punkterne.
  final String? intro;
  final List<String> points;

  /// Kort kildehenvisning, fx "BWF Laws of Badminton §9".
  final String source;
}

/// Den vigtigste aktuelle regelnyhed, vist øverst.
const String rulesHighlight = da.highlight;

const List<RuleSection> ruleSections = da.sections;
