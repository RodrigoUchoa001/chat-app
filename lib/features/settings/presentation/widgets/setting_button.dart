import 'package:chatapp/gen/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class SettingButton extends ConsumerWidget {
  final String? iconPath;
  final String? imagePath;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final Function()? onTap;
  const SettingButton(
      {this.iconPath,
      this.imagePath,
      required this.title,
      required this.subtitle,
      required this.onTap,
      this.trailing,
      super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
          child: Row(
            children: [
              if (iconPath != null || imagePath != null)
                Container(
                  height: 44,
                  width: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1D2525),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: iconPath != null
                      ? Padding(
                          padding: const EdgeInsets.all(10),
                          child: SvgPicture.asset(
                            iconPath!,
                            colorFilter: ColorFilter.mode(
                              Color(0xFF797C7B),
                              BlendMode.srcIn,
                            ),
                          ),
                        )
                      : CircleAvatar(
                          backgroundImage: NetworkImage(imagePath!),
                        ),
                ),
              if (iconPath != null || imagePath != null)
                const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: FontFamily.caros,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      fontFamily: FontFamily.circular,
                      color: Color(0xFF797C7B),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              if (trailing != null) trailing!,
            ],
          ),
        ),
      ),
    );
  }
}
