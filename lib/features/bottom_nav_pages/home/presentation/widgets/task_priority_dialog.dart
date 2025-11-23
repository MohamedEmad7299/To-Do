
import 'package:flutter/material.dart';
import 'package:to_do/l10n/app_localizations.dart';

class TaskPriorityDialog extends StatefulWidget {
  final int? initialPriority;

  const TaskPriorityDialog({
    super.key,
    this.initialPriority,
  });

  @override
  State<TaskPriorityDialog> createState() => _TaskPriorityDialogState();
}

class _TaskPriorityDialogState extends State<TaskPriorityDialog> {
  int? selectedPriority;

  @override
  void initState() {
    super.initState();
    selectedPriority = widget.initialPriority ?? 1; // Default to priority 1
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Dialog(
      backgroundColor: const Color(0xFF2D2D2D),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Theme.of(context).colorScheme.primary,
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            Text(
              l10n.taskPriority,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),


            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1,
              ),
              itemCount: 12,
              itemBuilder: (context, index) {
                final priority = index + 1;
                final isSelected = selectedPriority == priority;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedPriority = priority;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : const Color(0xFF3D3D3D),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.flag_outlined,
                          color: Colors.white,
                          size: 24,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          priority.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),


            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      l10n.cancel,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(selectedPriority);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      l10n.save,
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
    );
  }
}


void showTaskPriorityDialog(BuildContext context, {int? currentPriority}) async {
  final result = await showDialog<int>(
    context: context,
    builder: (context) => TaskPriorityDialog(
      initialPriority: currentPriority,
    ),
  );

  if (result != null) {
    print('Selected priority: $result');
  }
}
