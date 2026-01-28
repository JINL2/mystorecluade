import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/shared/themes/toss_border_radius.dart';
import 'package:myfinance_improved/shared/themes/toss_colors.dart';
import 'package:myfinance_improved/shared/themes/toss_spacing.dart';
import 'package:myfinance_improved/shared/themes/toss_text_styles.dart';
import 'package:myfinance_improved/shared/themes/toss_font_weight.dart';
import 'package:myfinance_improved/shared/themes/toss_opacity.dart';
import 'package:myfinance_improved/shared/themes/toss_dimensions.dart';

import '../../../../app/providers/auth_providers.dart';
import '../../../../app/providers/locale_provider.dart';
import '../../domain/entities/user_profile.dart';
import '../providers/my_page_notifier.dart';
import '../providers/user_profile_providers.dart';
import 'package:myfinance_improved/shared/widgets/index.dart';

class LanguageSettingsPage extends ConsumerStatefulWidget {
  const LanguageSettingsPage({super.key});

  @override
  ConsumerState<LanguageSettingsPage> createState() => _LanguageSettingsPageState();
}

class _LanguageSettingsPageState extends ConsumerState<LanguageSettingsPage> {
  String _selectedLanguageCode = 'en';
  String _savedLanguageCode = 'en';
  String? _selectedLanguageId;
  bool _isLoading = true;
  bool _hasUnsavedChanges = false;

  List<Language> _availableLanguages = [];

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

      // Load user profile if not already loaded
      final myPageState = ref.read(myPageNotifierProvider);
      UserProfile? userProfile = myPageState.userProfile;

      if (userProfile == null) {
        await ref.read(myPageNotifierProvider.notifier).loadUserData(authState.id);
        userProfile = ref.read(myPageNotifierProvider).userProfile;
      }

      if (userProfile != null && mounted) {
        setState(() {
          _availableLanguages = userProfile!.availableLanguages;

          // Get current language from profile
          if (userProfile.language != null) {
            _selectedLanguageCode = userProfile.language!.languageCode;
            _savedLanguageCode = userProfile.language!.languageCode;
            _selectedLanguageId = userProfile.language!.languageId;
          } else {
            _selectedLanguageCode = 'en';
            _savedLanguageCode = 'en';
          }
          _isLoading = false;
        });
      } else {
        if (mounted) {
          setState(() {
            _selectedLanguageCode = 'en';
            _savedLanguageCode = 'en';
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      debugPrint('Error loading language: $e');
      if (mounted) {
        setState(() {
          _selectedLanguageCode = 'en';
          _isLoading = false;
        });
      }
    }
  }

  // Select language in UI (doesn't save immediately)
  void _selectLanguage(String languageCode) {
    setState(() {
      _selectedLanguageCode = languageCode;
      _hasUnsavedChanges = (_selectedLanguageCode != _savedLanguageCode);
    });
  }

  // Get language name for display
  String _getLanguageName(String code) {
    switch (code) {
      case 'ko':
        return 'Korean';
      case 'en':
        return 'English';
      case 'vi':
        return 'Vietnamese';
      default:
        return 'English';
    }
  }

  // Get native language name
  String _getNativeName(String code) {
    switch (code) {
      case 'ko':
        return '한국어';
      case 'en':
        return 'English';
      case 'vi':
        return 'Tiếng Việt';
      default:
        return 'English';
    }
  }

  // Apply and save the selected language
  Future<void> _applyLanguageChange() async {
    try {
      // Find language_id for selected code
      final selectedLanguage = _availableLanguages.firstWhere(
        (lang) => lang.languageCode == _selectedLanguageCode,
        orElse: () => _availableLanguages.firstWhere(
          (lang) => lang.languageCode == 'en',
          orElse: () => _availableLanguages.first,
        ),
      );

      final languageId = selectedLanguage.languageId;
      final languageName = _getLanguageName(_selectedLanguageCode);

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
      await ref.read(localeProvider.notifier).setLocale(_selectedLanguageCode);

      // Reload user profile to get updated data
      await ref.read(myPageNotifierProvider.notifier).loadUserData(userId);

      // Update saved state
      setState(() {
        _savedLanguageCode = _selectedLanguageCode;
        _selectedLanguageId = languageId;
        _hasUnsavedChanges = false;
      });

      if (mounted) {
        TossToast.success(context, 'Language changed to $languageName');
      }
    } catch (e) {
      debugPrint('Error changing language: $e');

      // Revert UI on error
      setState(() {
        _selectedLanguageCode = _savedLanguageCode;
        _hasUnsavedChanges = false;
      });

      if (mounted) {
        TossToast.error(context, 'Failed to change language: ${e.toString()}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return TossScaffold(
      backgroundColor: TossColors.gray100,
      appBar: TossAppBar(
        title: 'Language',
        backgroundColor: TossColors.gray100,
        actions: _hasUnsavedChanges
            ? [
                TossButton.textButton(
                  text: 'Save',
                  onPressed: _applyLanguageChange,
                  textColor: TossColors.primary,
                  fontWeight: TossFontWeight.semibold,
                ),
              ]
            : null,
      ),
      body: _isLoading
          ? const TossLoadingView()
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
                    color: TossColors.gray900.withValues(alpha: TossOpacity.subtle),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  for (int i = 0; i < _availableLanguages.length; i++) ...[
                    _buildLanguageTile(_availableLanguages[i]),
                    if (i < _availableLanguages.length - 1)
                      Divider(
                        height: TossDimensions.dividerThickness,
                        thickness: TossDimensions.dividerThickness,
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
                  color: TossColors.info.withValues(alpha: TossOpacity.light),
                  borderRadius: BorderRadius.circular(TossBorderRadius.lg),
                  border: Border.all(
                    color: TossColors.info.withValues(alpha: TossOpacity.hover),
                    width: TossDimensions.dividerThickness,
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

  Widget _buildLanguageTile(Language language) {
    final isSelected = _selectedLanguageCode == language.languageCode;
    final languageCode = language.languageCode.toUpperCase();

    return InkWell(
      onTap: () => _selectLanguage(language.languageCode),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: TossSpacing.space4,
          vertical: TossSpacing.space3,
        ),
        child: Row(
          children: [
            // Language code badge
            Container(
              width: TossSpacing.space10,
              height: TossSpacing.space10,
              decoration: BoxDecoration(
                color: isSelected ? TossColors.primary : TossColors.gray100,
                borderRadius: BorderRadius.circular(TossBorderRadius.md),
              ),
              child: Center(
                child: Text(
                  languageCode,
                  style: TossTextStyles.caption.copyWith(
                    color: isSelected ? TossColors.white : TossColors.gray700,
                    fontWeight: TossFontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: TossSpacing.space3),
            // Title and subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _getLanguageName(language.languageCode),
                    style: TossTextStyles.body.copyWith(
                      color: isSelected ? TossColors.primary : TossColors.gray900,
                      fontWeight: isSelected ? TossFontWeight.semibold : TossFontWeight.medium,
                    ),
                  ),
                  const SizedBox(height: TossSpacing.space1),
                  Text(
                    _getNativeName(language.languageCode),
                    style: TossTextStyles.bodySmall.copyWith(
                      color: TossColors.gray500,
                    ),
                  ),
                ],
              ),
            ),
            // Check icon for selected
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: TossColors.primary,
                size: TossSpacing.iconMD,
              ),
          ],
        ),
      ),
    );
  }
}
