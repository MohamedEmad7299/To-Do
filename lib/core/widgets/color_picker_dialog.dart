import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

class ColorPickerDialog extends StatefulWidget {
  final Color currentColor;

  const ColorPickerDialog({
    super.key,
    required this.currentColor,
  });

  @override
  State<ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<ColorPickerDialog> {

  late Color selectedColor;

  static final List<Color> colorOptions = [
    const Color(0xFF8875FF),
    const Color(0xFFFF6B9D),
    const Color(0xFFFF5C5C),
    const Color(0xFFFF8B3D),
    const Color(0xFFFFCA3A),
    const Color(0xFF4CAF50),
    const Color(0xFF00BCD4),
    const Color(0xFF2196F3),
    const Color(0xFF3F51B5),
    const Color(0xFF9C27B0),
    const Color(0xFFE91E63),
    const Color(0xFFF44336),
    const Color(0xFFFF9800),
    const Color(0xFFFFC107),
    const Color(0xFF8BC34A),
    const Color(0xFF009688),
    const Color(0xFF03A9F4),
    const Color(0xFF673AB7),
    const Color(0xFF795548),
    const Color(0xFF607D8B),
  ];

  @override
  void initState() {
    super.initState();
    selectedColor = widget.currentColor;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).cardColor,
      title: Text(
        AppLocalizations.of(context)!.chooseThemeColor,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: colorOptions.length,
          itemBuilder: (context, index) {
            final color = colorOptions[index];
            final isSelected = color.toARGB32() == selectedColor.toARGB32();

            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedColor = color;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? Colors.white
                        : Colors.transparent,
                    width: 3,
                  ),
                  boxShadow: [
                    if (isSelected)
                      BoxShadow(
                        color: color.withValues(alpha: 0.5),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                  ],
                ),
                child: isSelected
                    ? const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 24,
                      )
                    : null,
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            AppLocalizations.of(context)!.cancel,
            style: TextStyle(
              color: Colors.white70,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(selectedColor);
          },
          child: Text(
            AppLocalizations.of(context)!.apply,
            style: TextStyle(
              color: selectedColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
