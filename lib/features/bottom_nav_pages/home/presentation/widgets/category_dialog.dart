import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:to_do/core/services/category_firestore_service.dart';
import 'package:to_do/core/style/colors/app_colors.dart';
import 'package:to_do/generated/assets.dart';
import 'package:to_do/l10n/app_localizations.dart';

import '../models/category.dart';

// Category Dialog
class ChooseCategoryDialog extends StatefulWidget {
  final String? initialCategory;

  const ChooseCategoryDialog({
    super.key,
    this.initialCategory,
  });

  @override
  State<ChooseCategoryDialog> createState() => _ChooseCategoryDialogState();
}

class _ChooseCategoryDialogState extends State<ChooseCategoryDialog> {
  String? selectedCategory;
  final CategoryFirestoreService _categoryService = CategoryFirestoreService();
  List<CategoryItem> categories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.initialCategory;
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    setState(() {
      isLoading = true;
    });

    // Always show predefined categories (keep English names for storage/matching)
    List<CategoryItem> predefinedCategories = [
      CategoryItem(
        name: 'Grocery',
        icon: Assets.svgsBread,
        color: const Color(0xFFCCFF80),
        isSvg: true,
      ),
      CategoryItem(
        name: 'Work',
        icon: Assets.svgsBriefcase,
        color: const Color(0xFFFF9680),
        isSvg: true,
      ),
      CategoryItem(
        name: 'Sport',
        icon: Assets.svgsSport,
        color: const Color(0xFF80FFFF),
        isSvg: true,
      ),
      CategoryItem(
        name: 'Design',
        icon: Assets.svgsXO,
        color: const Color(0xFF80FFD9),
        isSvg: true,
      ),
      CategoryItem(
        name: 'University',
        icon: Assets.svgsMortarboard,
        color: const Color(0xFF809CFF),
        isSvg: true,
      ),
      CategoryItem(
        name: 'Social',
        icon: Assets.svgsMegaphone,
        color: const Color(0xFFFF80EB),
        isSvg: true,
      ),
      CategoryItem(
        name: 'Music',
        icon: Assets.svgsMusic,
        color: const Color(0xFFFC80FF),
        isSvg: true,
      ),
      CategoryItem(
        name: 'Health',
        icon: Assets.svgsHeartbeat,
        color: const Color(0xFF80FFA3),
        isSvg: true,
      ),
      CategoryItem(
        name: 'Movie',
        icon: Assets.svgsCameraV,
        color: const Color(0xFF80D1FF),
        isSvg: true,
      ),
      CategoryItem(
        name: 'Home',
        icon: Assets.svgsHomeTag,
        color: const Color(0xFFFFCC80),
        isSvg: true,
      ),
    ];

    try {
      // Load custom categories from Firestore
      final customCategories = await _categoryService.getUserCategoriesFuture();

      // Convert to CategoryItem
      final customItems = customCategories.map((cat) {
        return CategoryItem(
          id: cat.id, // Include Firestore document ID
          name: cat.name,
          icon: cat.icon,
          color: cat.color,
          isSvg: false,
        );
      }).toList();

      setState(() {
        categories = [...predefinedCategories, ...customItems];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        categories = predefinedCategories;
        isLoading = false;
      });
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.usingDefaultCategoriesPrefix + e.toString()),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  String _translateCategoryName(String categoryName, AppLocalizations l10n) {
    switch (categoryName) {
      case 'Grocery':
        return l10n.categoryGrocery;
      case 'Work':
        return l10n.categoryWork;
      case 'Sport':
        return l10n.categorySport;
      case 'Design':
        return l10n.categoryDesign;
      case 'University':
        return l10n.categoryUniversity;
      case 'Social':
        return l10n.categorySocial;
      case 'Music':
        return l10n.categoryMusic;
      case 'Health':
        return l10n.categoryHealth;
      case 'Movie':
        return l10n.categoryMovie;
      case 'Home':
        return l10n.categoryHome;
      default:
        return categoryName; // Return as-is for custom categories
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Dialog(
      backgroundColor: const Color(0xFF363636),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Text(
              l10n.chooseCategory,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            // Instructions
            Text(
              l10n.longPressToDelete,
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 20),

            // Loading or Categories Grid
            if (isLoading)
              const Padding(
                padding: EdgeInsets.all(40.0),
                child: CircularProgressIndicator(
                  color: AppColors.lavenderPurple,
                ),
              )
            else
              SizedBox(
                height: 400,
                child: SingleChildScrollView(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      // Calculate number of columns based on width
                      final crossAxisCount = constraints.maxWidth > 400 ? 4 : 3;
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 16,
                          childAspectRatio: 0.9,
                        ),
                        itemCount: categories.length + 1, // +1 for "Create New"
                        itemBuilder: (context, index) {
                          // "Create New" button - NOW FIRST!
                          if (index == 0) {
                            return GestureDetector(
                              onTap: () {
                                _showCreateNewDialog();
                              },
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  return SizedBox(
                                    width: constraints.maxWidth,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Color(0xFF80FFD1),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          height: 50,
                                          width: 50,
                                          child: Icon(
                                            Icons.add,
                                            color: Colors.white,
                                            size: 32,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Flexible(
                                          child: SizedBox(
                                            width: constraints.maxWidth,
                                            child: Text(
                                              l10n.createNew,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              textAlign: TextAlign.center,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            );
                          }

                          // Regular category - adjust index since "Create New" is now first
                          final category = categories[index - 1];
                          final isSelected = selectedCategory == category.name;
                          final isCustom = !category.isSvg; // Custom categories are not SVG

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedCategory = category.name;
                              });
                            },
                            onLongPress: isCustom
                                ? () {
                              _confirmDeleteCategory(category);
                            }
                                : null,
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                return SizedBox(
                                  width: constraints.maxWidth,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: category.color,
                                          borderRadius: BorderRadius.circular(8),
                                          border: isSelected
                                              ? Border.all(
                                            color: Colors.white,
                                            width: 3,
                                          )
                                              : null,
                                        ),
                                        width: 50,
                                        height: 50,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            if (category.isSvg)
                                              SvgPicture.asset(
                                                category.icon,
                                                height: 32,
                                                width: 32,
                                              )
                                            else
                                              Icon(
                                                 IconData(
                                                  int.tryParse(category.icon) ??
                                                      Icons.category.codePoint,
                                                  fontFamily: 'MaterialIcons',
                                                ),
                                                color: Colors.white,
                                                size: 28,
                                              ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Flexible(
                                        child: SizedBox(
                                          width: constraints.maxWidth,
                                          child: Text(
                                            _translateCategoryName(category.name, l10n),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            const SizedBox(height: 20),

            // Add Category Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: selectedCategory != null
                    ? () {
                  if (context.mounted) {
                    Navigator.of(context).pop(selectedCategory);
                  }
                }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  disabledBackgroundColor:
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  l10n.addCategory,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDeleteCategory(CategoryItem category) async {
    final l10n = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF363636),
        title: Text(
          l10n.deleteCategory,
          style: const TextStyle(color: Colors.white),
        ),
        content: Text(
          l10n.deleteCategoryConfirmPrefix + category.name + l10n.deleteCategoryConfirmSuffix,
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              l10n.cancel,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              l10n.delete,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && category.id != null) {
      await _deleteCategory(category);
    }
  }

  Future<void> _deleteCategory(CategoryItem category) async {
    final l10n = AppLocalizations.of(context)!;

    try {
      // Delete from Firestore
      await _categoryService.deleteCategory(category.id!);

      // Remove from local list
      setState(() {
        categories.removeWhere((cat) => cat.id == category.id);
        // If the deleted category was selected, clear selection
        if (selectedCategory == category.name) {
          selectedCategory = null;
        }
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.categoryDeletedSuccessPrefix + category.name + l10n.categoryDeletedSuccessSuffix),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      print('Error deleting category: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.categoryDeleteFailedPrefix + e.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showCreateNewDialog() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => const CreateNewCategoryDialog(),
    );

    if (result != null) {
      // Show loading indicator
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: CircularProgressIndicator(
              color: AppColors.lavenderPurple,
            ),
          ),
        );
      }

      try {
        print('Creating new category with data: $result');
        print('  - Name: ${result['name']}');
        print('  - Icon: ${result['icon']}');
        print('  - Color: ${result['color']}');

        // Save to Firestore FIRST - this is critical!
        final categoryModel = CategoryModel(
          userId: _categoryService.currentUserId!,
          name: result['name'],
          icon: result['icon'],
          colorValue: result['color'],
        );

        print('Saving category to Firestore: ${categoryModel.toMap()}');
        await _categoryService.addCategory(categoryModel);
        print('Category saved successfully to Firestore!');

        // Close loading dialog
        if (mounted) {
          Navigator.of(context).pop();
        }

        // Now add to local list and select it
        final newCategoryItem = CategoryItem(
          name: result['name'],
          icon: result['icon'],
          color: Color(result['color']),
          isSvg: false,
        );

        setState(() {
          categories.add(newCategoryItem);
          selectedCategory = result['name'];
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.categoryCreatedSuccess),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        print('Error creating category: $e');

        // Close loading dialog
        if (mounted) {
          Navigator.of(context).pop();
        }

        // If Firestore save failed, reload to get accurate state
        await _loadCategories();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.categoryCreateFailedPrefix + e.toString()),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}

// Helper class for category items
class CategoryItem {
  final String? id; // Firestore document ID for custom categories
  final String name;
  final String icon;
  final Color color;
  final bool isSvg;

  CategoryItem({
    this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.isSvg,
  });
}

// Create New Category Dialog (same as before)
class CreateNewCategoryDialog extends StatefulWidget {
  const CreateNewCategoryDialog({super.key});

  @override
  State<CreateNewCategoryDialog> createState() =>
      _CreateNewCategoryDialogState();
}

class _CreateNewCategoryDialogState extends State<CreateNewCategoryDialog> {
  final TextEditingController _nameController = TextEditingController();
  Color? selectedColor;
  IconData? selectedIcon;
  bool _hasNameText = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_onNameTextChanged);
  }

  void _onNameTextChanged() {
    final hasText = _nameController.text.isNotEmpty;
    if (hasText != _hasNameText) {
      setState(() => _hasNameText = hasText);
    }
  }

  final List<Color> availableColors = [
    const Color(0xFFCCFF80),
    const Color(0xFFFF9680),
    const Color(0xFF80FFFF),
    const Color(0xFF80FFD9),
    const Color(0xFF809CFF),
    const Color(0xFFFF80EB),
    const Color(0xFFFC80FF),
    const Color(0xFF80FFA3),
    const Color(0xFF80D1FF),
    const Color(0xFFFFCC80),
  ];

  final List<IconData> availableIcons = [
    Icons.add_call,
    Icons.star,
    Icons.favorite,
    Icons.edit,
    Icons.account_balance,
    Icons.add_a_photo,
    Icons.cable,
    Icons.cached,
    Icons.delete,
    Icons.computer,
    Icons.book,
    Icons.sports_basketball,
    Icons.restaurant,
    Icons.shopping_cart,
    Icons.fitness_center,
  ];

  @override
  void dispose() {
    _nameController.removeListener(_onNameTextChanged);
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Dialog(
      backgroundColor: const Color(0xFF363636),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.createNewCategory,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),

              // Category Name Input
              TextField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: l10n.categoryName,
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  filled: true,
                  fillColor: const Color(0xFF2D2D2D),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: _hasNameText
                      ? IconButton(
                          icon: const Icon(Icons.highlight_remove, color: Colors.white70),
                          onPressed: () => _nameController.clear(),
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 20),

              // Color Selection
              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Text(
                      l10n.chooseColor,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '*',
                      style: TextStyle(
                        color: selectedColor == null ? Colors.red : Colors.green,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: availableColors.map((color) {
                  final isSelected = selectedColor == color;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedColor = color;
                      });
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(color: Colors.white, width: 3)
                            : null,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // Icon Selection
              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Text(
                      l10n.chooseIcon,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '*',
                      style: TextStyle(
                        color: selectedIcon == null ? Colors.red : Colors.green,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 150,
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: availableIcons.map((icon) {
                      final isSelected = selectedIcon == icon;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIcon = icon;
                          });
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: isSelected && selectedColor != null
                                ? selectedColor
                                : isSelected
                                ? Theme.of(context).colorScheme.primary
                                : const Color(0xFF2D2D2D),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            icon,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Create Button
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        l10n.cancel,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Validate all fields
                        if (_nameController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l10n.pleaseEnterCategoryName),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        if (selectedColor == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l10n.pleaseSelectColor),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        if (selectedIcon == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l10n.pleaseSelectIcon),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        // All validations passed, return the data
                        if (context.mounted) {
                          Navigator.of(context).pop({
                            'name': _nameController.text.trim(),
                            'icon': selectedIcon!.codePoint.toString(),
                            'color': selectedColor!.toARGB32(),
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        l10n.create,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Usage Example
Future<void> showCategoryDialog(BuildContext context) async {
  final result = await showDialog<String>(
    context: context,
    builder: (context) => const ChooseCategoryDialog(),
  );

  if (result != null) {
    print('Selected category: $result');
    // Use the selected category
  }
}