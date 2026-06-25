import 'package:flutter/material.dart';

class CourseIndexTreeView extends StatelessWidget {
  final List<dynamic> modules;
  final bool useCardStyling;
  final bool showCheckboxes;
  final bool Function(dynamic) isSelected;
  final void Function(dynamic) onToggleSelection;

  const CourseIndexTreeView({
    super.key,
    required this.modules,
    this.useCardStyling = false,
    this.showCheckboxes = false,
    required this.isSelected,
    required this.onToggleSelection,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: modules.length,
      itemBuilder: (context, index) {
        final module = modules[index];
        return _buildModuleItem(module, 0);
      },
    );
  }

  Widget _buildModuleItem(dynamic module, int level) {
    final hasChildren =
        module['list'] != null && (module['list'] as List).isNotEmpty;
    final selected = isSelected(module);

    return Padding(
      padding: EdgeInsets.only(left: level * 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (useCardStyling)
            Card(
              margin: const EdgeInsets.symmetric(vertical: 4),
              child: ListTile(
                leading: showCheckboxes
                    ? Checkbox(
                        value: selected,
                        onChanged: (_) => onToggleSelection(module),
                      )
                    : null,
                title: Text(module['title']?.toString() ?? 'No Title'),
                trailing: hasChildren ? const Icon(Icons.expand_more) : null,
                onTap: hasChildren ? () {} : null,
              ),
            )
          else
            ListTile(
              leading: showCheckboxes
                  ? Checkbox(
                      value: selected,
                      onChanged: (_) => onToggleSelection(module),
                    )
                  : null,
              title: Text(module['title']?.toString() ?? 'No Title'),
              trailing: hasChildren ? const Icon(Icons.expand_more) : null,
              onTap: hasChildren ? () {} : null,
            ),
          if (hasChildren)
            ...((module['list'] as List)
                .map((child) => _buildModuleItem(child, level + 1))),
        ],
      ),
    );
  }
}
