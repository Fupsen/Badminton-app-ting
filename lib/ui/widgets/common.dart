import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../labels.dart';

/// Begrænser indholdets bredde, så lister og formularer ikke bliver
/// ulæseligt brede på en computerskærm.
class ContentWidth extends StatelessWidget {
  const ContentWidth({super.key, required this.child, this.maxWidth = 900});

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) => Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: child,
        ),
      );
}

class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: theme.colorScheme.outline),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

/// Lille rund markering for vundet (V) eller tabt (T).
class ResultBadge extends StatelessWidget {
  const ResultBadge({super.key, required this.won, this.size = 36});

  final bool won;
  final double size;

  static const winColor = Color(0xFF2E9D57);
  static const lossColor = Color(0xFFD0453A);

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: won ? winColor : lossColor,
        shape: BoxShape.circle,
      ),
      child: Text(
        won ? l.resultWonShort : l.resultLostShort,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: size * 0.42,
        ),
      ),
    );
  }
}

/// Række af V/T-markeringer for de seneste kampe.
class FormRow extends StatelessWidget {
  const FormRow({super.key, required this.results});

  final List<bool> results;

  @override
  Widget build(BuildContext context) => Wrap(
        spacing: 6,
        runSpacing: 6,
        children: [for (final won in results) ResultBadge(won: won, size: 28)],
      );
}

/// Kort med en titel, brugt til at dele skærme op i sektioner.
class SectionCard extends StatelessWidget {
  const SectionCard({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.titleMedium),
            if (subtitle != null)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(subtitle!,
                    style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant)),
              ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

/// Nøgletal med stor værdi og lille label.
class StatTile extends StatelessWidget {
  const StatTile({
    super.key,
    required this.label,
    required this.value,
    this.detail,
    this.icon,
  });

  final String label;
  final String value;
  final String? detail;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 18, color: theme.colorScheme.primary),
                  const SizedBox(width: 6),
                ],
                Expanded(
                  child: Text(label,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(value, style: theme.textTheme.headlineMedium),
            if (detail != null)
              Text(detail!,
                  style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }
}

/// Lægger [children] i et gitter hvor antallet af kolonner afhænger af
/// den tilgængelige bredde.
class ResponsiveGrid extends StatelessWidget {
  const ResponsiveGrid({
    super.key,
    required this.children,
    this.minItemWidth = 180,
  });

  final List<Widget> children;
  final double minItemWidth;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          final columns =
              (constraints.maxWidth / minItemWidth).floor().clamp(1, 4);
          final itemWidth = constraints.maxWidth / columns;
          return Wrap(
            children: [
              for (final c in children) SizedBox(width: itemWidth, child: c),
            ],
          );
        },
      );
}

String percent(double? rate, String fallback) =>
    rate == null ? fallback : '${(rate * 100).round()} %';

/// Tip om at lægge webudgaven på hjemmeskærmen. Vises kun i browseren.
class WebInstallHint extends StatelessWidget {
  const WebInstallHint({super.key, this.force = false});

  /// Vis også uden for webudgaven. Bruges i tests.
  final bool force;

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb && !force) return const SizedBox.shrink();
    final colors = Theme.of(context).colorScheme;
    return Card(
      color: colors.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.add_to_home_screen, color: colors.onSecondaryContainer),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                context.l10n.webInstallHint,
                style: TextStyle(color: colors.onSecondaryContainer),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
