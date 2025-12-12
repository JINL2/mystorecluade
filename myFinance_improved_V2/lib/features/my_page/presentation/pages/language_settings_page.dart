import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_app_bar_1.dart';
import 'package:myfinance_improved/shared/widgets/common/toss_scaffold.dart';
import 'package:myfinance_improved/shared/widgets/toss/toss_list_tile.dart';

import '../../../../app/providers/auth_providers.dart';
import '../../../../app/providers/locale_provider.dart';
import '../providers/user_profile_providers.dart';

class LanguageSettingsPage extends ConsumerStatefulWidget {
  const LanguageSettingsPage({super.key});

  @override
  ConsumerState<LanguageSettingsPage> createState() => _LanguageSettingsPageState();
}

class _LanguageSettingsPageState extends ConsumerState<LanguageSettingsPage> {
  String _selectedLanguage = 'English'; // Current selection in UI
  String _savedLanguage = 'English'; // Language saved in database
  String? _selectedLanguageId; // Language ID from database
  bool _isLoading = true;
  bool _hasUnsavedChanges = false;

  final List<Map<String, String>> _languages = [
    {'code': 'ko', 'name': 'Korean', 'native': '한국어'},
    {'code': 'en', 'name': 'English', 'native': 'English'},
    {'code': 'vi', 'name': 'Vietnamese', 'native': 'Tiếng Việt'},
  ];

  // Map to store language_id for each language code
  final Map<String, String> _languageIds = {};

  @override
  void initState() {
    super.initState();
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    try {
      setState(() => _isLoading = true);

      final authState = await ref.read(authStateProvider.future);
      if (authState == null) return;

      final userId = authState.id;
      final repository = ref.read(userProfileRepositoryProvider);

      // Step 1: Fetch all available languages from repository
      final languagesResponse = await repository.getLanguages();

      for (var lang in languagesResponse) {
        _languageIds[lang['language_code'] as String] = lang['language_id'] as String;
      }

      // Step 2: Fetch user's current language preference
      final userLanguageId = await repository.getUserLanguageId(userId);

      if (userLanguageId != null) {
        _selectedLanguageId = userLanguageId;

        // Find the language name from the ID
        final languageEntry = _languageIds.entries.firstWhere(
          (entry) => entry.value == userLanguageId,
          orElse: () => const MapEntry('en', ''),
        );

        final languageCode = languageEntry.key;
        final languageData = _languages.firstWhere(
          (lang) => lang['code'] == languageCode,
          orElse: () => _languages[1], // Default to English
        );

        if (mounted) {
          setState(() {
            _selectedLanguage = languageData['name']!;
            _savedLanguage = languageData['name']!;
            _isLoading = false;
          });
        }
      } else {
        // Default to English if no preference saved
        if (mounted) {
          setState(() {
            _selectedLanguage = 'English';
            _savedLanguage = 'English';
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      debugPrint('Error loading language: $e');
      if (mounted) {
        setState(() {
          _selectedLanguage = 'English';
          _isLoading = false;
        });
      }
    }
  }

  // Select language in UI (doesn't save immediately)
  void _selectLanguage(String languageCode, String languageName) {
    setState(() {
      _selectedLanguage = languageName;
      _hasUnsavedChanges = (_selectedLanguage != _savedLanguage);
    });
  }

  // Apply and save the selected language
  Future<void> _applyLanguageChange() async {
    // Find the selected language details
    final selectedLang = _languages.firstWhere(
      (lang) => lang['name'] == _selectedLanguage,
      orElse: () => _languages[1], // Default to English
    );

    final languageCode = selectedLang['code']!;
    final languageName = selectedLang['name']!;

    try {
      // Get language_id for the selected language code
      final languageId = _languageIds[languageCode];
      if (languageId == null) {
        throw Exception('Language ID not found for code: $languageCode');
      }

      // Get current user ID
      final authState = await ref.read(authStateProvider.future);
      if (authState == null) {
        throw Exception('User not authenticated');
      }
      final userId = authState.id;

      // Save to database via repository
      final repository = ref.read(userProfileRepositoryProvider);
      await repository.updateUserLanguage(
        userId: userId,
        languageId: languageId,
      );

      // Update app locale immediately
      await ref.read(localeProvider.notifier).setLocale(languageCode);

      // Update saved state
      setState(() {
        _savedLanguage = languageName;
        _selectedLanguageId = languageId;
        _hasUnsavedChanges = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Language changed to $languageName'),
            backgroundColor: TossColors.success,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error changing language: $e');

      // Revert UI on error
      setState(() {
        _selectedLanguage = _savedLanguage;
        _hasUnsavedChanges = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to change language: ${e.toString()}'),
            backgroundColor: TossColors.error,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return TossScaffold(
      backgroundColor: TossColors.gray100,
      appBar: TossAppBar1(
        title: 'Language',
        backgroundColor: TossColors.gray100,
        actions: _hasUnsavedChanges
            ? [
                TextButton(
                  onPressed: _applyLanguageChange,
                  child: Text(
                    'Save',
                    style: TossTextStyles.body.copyWith(
                      color: TossColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ]
            : null,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: TossColors.primary,
              ),
            )
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: TossSpacing.space2),

            // Language description
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: TossSpacing.space4,
                vertical: TossSpacing.space2,
              ),
              child: Text(
                'Select your preferred language',
                style: TossTextStyles.body.copyWith(
                  color: TossColors.gray600,
                ),
              ),
            ),

            const SizedBox(height: TossSpacing.space2),

            // Language list
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: TossSpacing.space4),
              decoration: BoxDecoration(
                color: TossColors.white,
                borderRadius: BorderRadius.circular(TossBorderRadius.xl),
                boxShadow: [
                  BoxShadow(
                    color: TossColors.gray900.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  for (int i = 0; i < _languages.length; i++) ...[
                    _buildLanguageTile(_languages[i]),
                    if (i < _languages.length - 1)
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: TossColors.gray100,
                        indent: TossSpacing.space16,
                      ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: TossSpacing.space4),

            // Note about app restart
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: TossSpacing.space4,
              ),
              child: Container(
                padding: const EdgeInsets.all(TossSpacing.space4),
                decoration: BoxDecoration(
                  color: TossColors.info.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                  border: Border.all(
                    color: TossColors.info.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: TossColors.info,
                      size: TossSpacing.iconSM,
                    ),
                    const SizedBox(width: TossSpacing.space3),
                    Expanded(
                      child: Text(
                        'App may need to restart to apply language changes',
                        style: TossTextStyles.bodySmall.copyWith(
                          color: TossColors.info,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: TossSpacing.space12),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageTile(Map<String, String> language) {
    final isSelected = _selectedLanguage == language['name'];
    final languageCode = language['code']!.toUpperCase();

    return TossListTile(
      title: language['name']!,
      subtitle: language['native']!,
      leading: Container(
        width: TossSpacing.space10,
        height: TossSpacing.space10,
        decoration: BoxDecoration(
          color: isSelected
              ? TossColors.primary
              : TossColors.gray100,
          borderRadius: BorderRadius.circular(TossBorderRadius.md),
        ),
        child: Center(
          child: Text(
            languageCode,
            style: TossTextStyles.caption.copyWith(
              color: isSelected ? TossColors.white : TossColors.gray700,
              fontWeight: FontWeight.w700,
              fontSize: 13,
              letterSpacing: -0.5,
            ),
          ),
        ),
      ),
      trailing: isSelected
          ? const Icon(
              Icons.check_circle,
              color: TossColors.primary,
              size: TossSpacing.iconMD,
            )
          : null, // No arrow - direct selection, not a submenu
      onTap: () => _selectLanguage(language['code']!, language['name']!),
    );
  }
}
