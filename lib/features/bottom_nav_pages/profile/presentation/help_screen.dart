
import 'package:flutter/material.dart';
import 'package:to_do/l10n/app_localizations.dart';

class HelpItem {
  final String title;
  final String description;
  final IconData icon;

  HelpItem({
    required this.title,
    required this.description,
    required this.icon,
  });
}

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  int? _expandedIndex;

  List<HelpItem> _getHelpItems(AppLocalizations l10n) {
    return [
      HelpItem(
        title: l10n.helpGettingStarted,
        description: l10n.helpGettingStartedDesc,
        icon: Icons.rocket_launch_outlined,
      ),
      HelpItem(
        title: l10n.helpManagingTasks,
        description: l10n.helpManagingTasksDesc,
        icon: Icons.task_alt_outlined,
      ),
      HelpItem(
        title: l10n.helpAccountProfile,
        description: l10n.helpAccountProfileDesc,
        icon: Icons.person_outline,
      ),
      HelpItem(
        title: l10n.helpSecurityPrivacy,
        description: l10n.helpSecurityPrivacyDesc,
        icon: Icons.security_outlined,
      ),
      HelpItem(
        title: l10n.helpTroubleshooting,
        description: l10n.helpTroubleshootingDesc,
        icon: Icons.build_outlined,
      ),
      HelpItem(
        title: l10n.helpTipsBestPractices,
        description: l10n.helpTipsBestPracticesDesc,
        icon: Icons.lightbulb_outline,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final helpItems = _getHelpItems(l10n);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          l10n.helpAndFeedback,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.support_agent_outlined,
                    size: 48,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.wereHereToHelp,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.browseHelpTopics,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.color
                            ?.withValues(alpha: 0.7),
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),


          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: helpItems.length,
              itemBuilder: (context, index) {
                return _buildHelpCard(context, index, helpItems);
              },
            ),
          ),


          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [

                Card(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  child: InkWell(
                    onTap: () {
                      _showFeedbackDialog(context);
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Icon(
                            Icons.feedback_outlined,
                            size: 32,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.sendUsYourFeedback,
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  l10n.weLoveToHear,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                Card(
                  color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Icon(
                          Icons.email_outlined,
                          size: 32,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          l10n.contactSupport,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'mohamedemad199912@gmail.com',
                          style: Theme.of(context).textTheme.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpCard(BuildContext context, int index, List<HelpItem> helpItems) {
    final help = helpItems[index];
    final isExpanded = _expandedIndex == index;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: isExpanded ? 4 : 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isExpanded
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).dividerColor,
            width: isExpanded ? 2 : 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    _expandedIndex = isExpanded ? null : index;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          help.icon,
                          size: 24,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          help.title,
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      AnimatedRotation(
                        turns: isExpanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 300),
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              AnimatedCrossFade(
                firstChild: const SizedBox.shrink(),
                secondChild: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(
                        height: 1,
                        color: Theme.of(context).dividerColor,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        help.description,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.color
                                  ?.withValues(alpha: 0.8),
                              height: 1.5,
                            ),
                      ),
                    ],
                  ),
                ),
                crossFadeState: isExpanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 300),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFeedbackDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final TextEditingController feedbackController = TextEditingController();
    String selectedType = l10n.generalFeedback;
    bool hasFeedbackText = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.feedback_outlined,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 12),
              Text(l10n.sendFeedback),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.feedbackType,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: selectedType,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  items: [l10n.generalFeedback, l10n.bugReport, l10n.featureRequest, l10n.suggestion]
                      .map((type) => DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedType = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.yourFeedback,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: feedbackController,
                  maxLines: 5,
                  onChanged: (value) {
                    setState(() {
                      hasFeedbackText = value.isNotEmpty;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: l10n.tellUsWhatYouThink,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.all(12),
                    suffixIcon: hasFeedbackText
                        ? IconButton(
                            icon: Icon(
                              Icons.highlight_remove,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            onPressed: () {
                              feedbackController.clear();
                              setState(() {
                                hasFeedbackText = false;
                              });
                            },
                          )
                        : null,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                if (feedbackController.text.trim().isNotEmpty) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.thankYouForFeedback),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              child: Text(l10n.send),
            ),
          ],
        ),
      ),
    );
  }
}