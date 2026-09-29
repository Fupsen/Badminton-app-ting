import 'package:flutter/material.dart';

import '../labels.dart';

/// Felt der viser en dato og åbner en datovælger ved tryk.
class DateField extends StatelessWidget {
  const DateField({super.key, required this.date, required this.onChanged});

  final DateTime date;
  final ValueChanged<DateTime> onChanged;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return InkWell(
      borderRadius: BorderRadius.circular(4),
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(2000),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (picked != null) {
          // Behold klokkeslættet, så rækkefølgen af flere kampe samme dag
          // bevares.
          onChanged(DateTime(picked.year, picked.month, picked.day,
              date.hour, date.minute, date.second));
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: l.dateLabel,
          border: const OutlineInputBorder(),
          suffixIcon: const Icon(Icons.calendar_today_outlined),
        ),
        child: Text(context.formatDate(date)),
      ),
    );
  }
}
