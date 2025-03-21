import 'package:chatapp/core/localization/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LanguageSwitch extends ConsumerStatefulWidget {
  const LanguageSwitch({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LanguageSwitchState();
}

class _LanguageSwitchState extends ConsumerState<LanguageSwitch> {
  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeProvider);
    bool isEnglish = locale.languageCode == "en";

    final localeNotifier = ref.read(localeProvider.notifier);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Container(
        height: 52,
        width: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Colors.white,
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              left: isEnglish ? 2 : 100,
              right: isEnglish ? 100 : 2,
              top: 2,
              bottom: 2,
              child: Container(
                width: 94,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLanguageButton(
                    text: "English",
                    isSelected: isEnglish,
                    onTap: () => localeNotifier.setLocale(AppLocale.en),
                  ),
                  _buildLanguageButton(
                    text: "Português",
                    isSelected: !isEnglish,
                    onTap: () => localeNotifier.setLocale(AppLocale.pt),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageButton({
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        minimumSize: const Size(100, 50),
        foregroundColor: isSelected ? Colors.white : Colors.black,
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: isSelected ? Colors.white : Colors.black,
            ),
      ),
    );
  }
}
