import 'package:flutter/material.dart';

import '../models/category.dart';

class CategoryFilter extends StatelessWidget {
  const CategoryFilter({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.onSelected,
  });

  final List<Category> categories;
  final int? selectedCategoryId;
  final ValueChanged<int?> onSelected;

  @override
  Widget build(BuildContext context) {
    final chips = <Widget>[
      _buildChip(
        context,
        label: 'Tất cả',
        isSelected: selectedCategoryId == null,
        onTap: () => onSelected(null),
      ),
      ...categories.map(
        (category) => _buildChip(
          context,
          label: category.name,
          isSelected: selectedCategoryId == category.id,
          onTap: () => onSelected(category.id),
        ),
      ),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final chip in chips) ...[chip, const SizedBox(width: 8)],
        ],
      ),
    );
  }

  Widget _buildChip(
    BuildContext context, {
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      selectedColor: Theme.of(
        context,
      ).colorScheme.primary.withValues(alpha: 0.2),
      labelStyle: TextStyle(
        color: isSelected
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.onSurface,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
      ),
    );
  }
}
