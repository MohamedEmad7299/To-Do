
import 'package:flutter/material.dart';
import 'package:to_do/l10n/app_localizations.dart';

class PrivacyPolicyScreen extends StatelessWidget {

  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          l10n.privacyPolicy,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.lastUpdated(DateTime.now().year.toString()),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.color
                        ?.withValues(alpha: 0.6),
                  ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              context,
              l10n.ppIntroduction,
              l10n.ppIntroductionText,
            ),
            _buildSection(
              context,
              l10n.ppInformationWeCollect,
              l10n.ppInformationWeCollectText,
            ),
            _buildSection(
              context,
              l10n.ppHowWeUse,
              l10n.ppHowWeUseText,
            ),
            _buildSection(
              context,
              l10n.ppDataStorage,
              l10n.ppDataStorageText,
            ),
            _buildSection(
              context,
              l10n.ppDataSharing,
              l10n.ppDataSharingText,
            ),
            _buildSection(
              context,
              l10n.ppYourRights,
              l10n.ppYourRightsText,
            ),
            _buildSection(
              context,
              l10n.ppChildrensPrivacy,
              l10n.ppChildrensPrivacyText,
            ),
            _buildSection(
              context,
              l10n.ppChanges,
              l10n.ppChangesText,
            ),
            _buildSection(
              context,
              l10n.ppContact,
              l10n.ppContactText,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.6,
                  color: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.color
                      ?.withValues(alpha: 0.9),
                ),
          ),
        ],
      ),
    );
  }
}
