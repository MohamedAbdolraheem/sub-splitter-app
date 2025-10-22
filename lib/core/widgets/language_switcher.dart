import 'package:flutter/material.dart';
import 'package:subscription_splitter_app/core/widgets/localized_text.dart';
import '../extensions/translation_extension.dart';
import '../services/language_service.dart';

class LanguageSwitcher extends StatelessWidget {
  final String currentLanguage;
  final Function(String) onLanguageChanged;
  final bool showAsDialog;
  final bool showFlags;
  final bool showNames;

  const LanguageSwitcher({
    super.key,
    required this.currentLanguage,
    required this.onLanguageChanged,
    this.showAsDialog = false,
    this.showFlags = true,
    this.showNames = true,
  });

  @override
  Widget build(BuildContext context) {
    if (showAsDialog) {
      return _buildDialogButton(context);
    } else {
      return _buildDropdown(context);
    }
  }

  Widget _buildDialogButton(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.language, color: Colors.white),
      onPressed: () => _showLanguageDialog(context),
      tooltip: context.tr.language,
    );
  }

  Widget _buildDropdown(BuildContext context) {
    final currentOption = LanguageService.supportedLanguages.firstWhere(
      (lang) => lang.code == currentLanguage,
    );

    return DropdownButton<String>(
      value: currentLanguage,
      icon: const Icon(Icons.arrow_drop_down),
      underline: const SizedBox(),
      onChanged: (String? newValue) {
        if (newValue != null && newValue != currentLanguage) {
          onLanguageChanged(newValue);
        }
      },
      items:
          LanguageService.supportedLanguages.map((LanguageOption option) {
            return DropdownMenuItem<String>(
              value: option.code,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (showFlags) ...[
                    Text(option.flag, style: const TextStyle(fontSize: 20)),
                    const SizedBox(width: 8),
                  ],
                  if (showNames) ...[
                    Text(
                      context.isArabic ? option.name : option.englishName,
                      style: context.bodyStyle(fontSize: 14),
                    ),
                  ],
                ],
              ),
            );
          }).toList(),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: LocalizedHeading(context.tr.language, fontSize: 20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children:
                LanguageService.supportedLanguages.map((option) {
                  final isSelected = option.code == currentLanguage;

                  return ListTile(
                    leading: Text(
                      option.flag,
                      style: const TextStyle(fontSize: 24),
                    ),
                    title: LocalizedBodyText(
                      context.isArabic ? option.name : option.englishName,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    subtitle: LocalizedCaption(
                      context.isArabic ? option.englishName : option.name,
                      color: Colors.grey[600],
                    ),
                    trailing:
                        isSelected
                            ? Icon(
                              Icons.check,
                              color: Theme.of(context).primaryColor,
                            )
                            : null,
                    onTap: () {
                      if (option.code != currentLanguage) {
                        onLanguageChanged(option.code);
                      }
                      Navigator.of(context).pop();
                    },
                  );
                }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: LocalizedButtonText(context.tr.cancel),
            ),
          ],
        );
      },
    );
  }
}

/// A simple language toggle button that switches between Arabic and English
class LanguageToggleButton extends StatelessWidget {
  final String currentLanguage;
  final Function(String) onLanguageChanged;

  const LanguageToggleButton({
    super.key,
    required this.currentLanguage,
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isArabic = currentLanguage == 'ar';

    return GestureDetector(
      onTap: () {
        final newLanguage = isArabic ? 'en' : 'ar';
        onLanguageChanged(newLanguage);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isArabic ? '🇸🇦' : '🇺🇸',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(width: 4),
            LocalizedCaption(
              isArabic ? 'العربية' : 'English',
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
      ),
    );
  }
}
