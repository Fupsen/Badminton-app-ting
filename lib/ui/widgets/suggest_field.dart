import 'package:flutter/material.dart';

/// Tekstfelt der foreslår tidligere brugte værdier (fx modstandere).
class SuggestField extends StatefulWidget {
  const SuggestField({
    super.key,
    required this.controller,
    required this.suggestions,
    required this.label,
    this.validator,
  });

  final TextEditingController controller;
  final List<String> suggestions;
  final String label;
  final FormFieldValidator<String>? validator;

  @override
  State<SuggestField> createState() => _SuggestFieldState();
}

class _SuggestFieldState extends State<SuggestField> {
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      textEditingController: widget.controller,
      focusNode: _focusNode,
      optionsBuilder: (value) {
        final query = value.text.trim().toLowerCase();
        if (query.isEmpty) return const [];
        return widget.suggestions.where((s) {
          final lower = s.toLowerCase();
          return lower.contains(query) && lower != query;
        });
      },
      fieldViewBuilder: (context, controller, focusNode, onSubmitted) =>
          TextFormField(
        controller: controller,
        focusNode: focusNode,
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(
          labelText: widget.label,
          border: const OutlineInputBorder(),
        ),
        validator: widget.validator,
        onFieldSubmitted: (_) => onSubmitted(),
      ),
    );
  }
}
