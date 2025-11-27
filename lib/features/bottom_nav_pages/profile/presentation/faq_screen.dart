import 'package:flutter/material.dart';
import 'package:to_do/l10n/app_localizations.dart';

class FAQItem {
  final String question;
  final String answer;
  final IconData icon;

  FAQItem({
    required this.question,
    required this.answer,
    required this.icon,
  });
}

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  int? _expandedIndex;

  List<FAQItem> _getFaqItems(AppLocalizations l10n) {
    return [
      FAQItem(
        question: l10n.faqQuestion1,
        answer: l10n.faqAnswer1,
        icon: Icons.add_task,
      ),
      FAQItem(
        question: l10n.faqQuestion2,
        answer: l10n.faqAnswer2,
        icon: Icons.flag_outlined,
      ),
      FAQItem(
        question: l10n.faqQuestion3,
        answer: l10n.faqAnswer3,
        icon: Icons.check_circle_outline,
      ),
      FAQItem(
        question: l10n.faqQuestion4,
        answer: l10n.faqAnswer4,
        icon: Icons.auto_delete_outlined,
      ),
      FAQItem(
        question: l10n.faqQuestion5,
        answer: l10n.faqAnswer5,
        icon: Icons.fingerprint,
      ),
      FAQItem(
        question: l10n.faqQuestion6,
        answer: l10n.faqAnswer6,
        icon: Icons.edit_outlined,
      ),
      FAQItem(
        question: l10n.faqQuestion7,
        answer: l10n.faqAnswer7,
        icon: Icons.category_outlined,
      ),
      FAQItem(
        question: l10n.faqQuestion8,
        answer: l10n.faqAnswer8,
        icon: Icons.security_outlined,
      ),
      FAQItem(
        question: l10n.faqQuestion9,
        answer: l10n.faqAnswer9,
        icon: Icons.cloud_off_outlined,
      ),
      FAQItem(
        question: l10n.faqQuestion10,
        answer: l10n.faqAnswer10,
        icon: Icons.logout_outlined,
      ),
      FAQItem(
        question: l10n.faqQuestion11,
        answer: l10n.faqAnswer11,
        icon: Icons.lock_reset_outlined,
      ),
      FAQItem(
        question: l10n.faqQuestion12,
        answer: l10n.faqAnswer12,
        icon: Icons.sync_outlined,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final faqItems = _getFaqItems(l10n);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          l10n.frequentlyAskedQuestions,
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
                    Icons.help_outline_rounded,
                    size: 48,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.howCanWeHelp,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.findAnswers,
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
              itemCount: faqItems.length,
              itemBuilder: (context, index) {
                return _buildFAQCard(context, index, faqItems);
              },
            ),
          ),


          Container(
            padding: const EdgeInsets.all(16),
            child: Card(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(
                      Icons.contact_support_outlined,
                      size: 32,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.stillNeedHelp,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${l10n.contactSupportAt}\nmohamedemad199912@gmail.com',
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQCard(BuildContext context, int index, List<FAQItem> faqItems) {
    final faq = faqItems[index];
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
                          faq.icon,
                          size: 24,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          faq.question,
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
                        faq.answer,
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
}
