import 'package:flutter/material.dart';
import 'package:subscription_splitter_app/core/extensions/translation_extension.dart';

/// A widget that demonstrates font switching between Arabic and English
class FontDemoWidget extends StatelessWidget {
  const FontDemoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: context.startCrossAxisAlignment,
          children: [
            Text(
              'Font Demo - ${context.isArabic ? "Arabic" : "English"}',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Show current font family
            Text(
              'Font Family: ${context.fontFamily}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontStyle: FontStyle.italic,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),

            // Arabic text example
            if (context.isArabic) ...[
              Text(
                'نص عربي بخط كايرو',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'هذا مثال على النص العربي باستخدام خط كايرو. الخط يبدو جميلاً ومقروءاً.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],

            // English text example
            if (context.isEnglish) ...[
              Text(
                'English Text with Lora Font',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'This is an example of English text using the Lora font. The font looks beautiful and readable.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],

            const SizedBox(height: 16),

            // Show different text styles
            Text(
              'Different Text Styles:',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            Text(
              'Display Large - ${context.isArabic ? "عرض كبير" : "Display Large"}',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            Text(
              'Headline Medium - ${context.isArabic ? "عنوان متوسط" : "Headline Medium"}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              'Body Large - ${context.isArabic ? "نص كبير" : "Body Large"}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              'Label Small - ${context.isArabic ? "تسمية صغيرة" : "Label Small"}',
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      ),
    );
  }
}
