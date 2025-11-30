import 'package:flutter/material.dart';
import 'package:to_do/l10n/app_localizations.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          l10n.termsOfService,
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
              l10n.tosAgreement,
              l10n.tosAgreementText,
            ),
            _buildSection(
              context,
              l10n.tosUseLicense,
              l10n.tosUseLicenseText,
            ),
            _buildSection(
              context,
              l10n.tosUserAccounts,
              l10n.tosUserAccountsText,
            ),
            _buildSection(
              context,
              l10n.tosAcceptableUse,
              l10n.tosAcceptableUseText,
            ),
            _buildSection(
              context,
              l10n.tosContentOwnership,
              l10n.tosContentOwnershipText,
            ),
            _buildSection(
              context,
              l10n.tosServiceAvailability,
              l10n.tosServiceAvailabilityText,
            ),
            _buildSection(
              context,
              l10n.tosDisclaimer,
              l10n.tosDisclaimerText,
            ),
            _buildSection(
              context,
              l10n.tosLimitation,
              l10n.tosLimitationText,
            ),
            _buildSection(
              context,
              l10n.tosDataBackup,
              l10n.tosDataBackupText,
            ),
            _buildSection(
              context,
              l10n.tosTermination,
              l10n.tosTerminationText,
            ),
            _buildSection(
              context,
              l10n.tosChangesToTerms,
              l10n.tosChangesToTermsText,
            ),
            _buildSection(
              context,
              l10n.tosGoverningLaw,
              l10n.tosGoverningLawText,
            ),
            _buildSection(
              context,
              l10n.tosContactInfo,
              l10n.tosContactInfoText,
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
