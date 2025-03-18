import 'package:chatapp/core/localization/app_localization.dart';
import 'package:chatapp/core/localization/locale_provider.dart';
import 'package:chatapp/features/auth/data/dto/user_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class UserDetails extends ConsumerStatefulWidget {
  final UserDTO user;
  const UserDetails({required this.user, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UserDetailsState();
}

class _UserDetailsState extends ConsumerState<UserDetails> {
  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeProvider);
    final localization = ref.watch(localizationProvider(locale)).value;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: ListView(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 41 - 15), // -15 for the top padding
          _buildUserDetail(
            localization?.translate("user-details-display-name") ?? "",
            widget.user.name,
          ),
          _buildUserDetail(
            localization?.translate("user-details-email-address") ?? "",
            widget.user.email,
          ),
          _buildUserDetail(
            localization?.translate("user-details-status-message") ?? "",
            widget.user.statusMessage,
          ),
          _buildUserDetail(
            localization?.translate("user-details-joined-at") ?? "",
            DateFormat('dd/MM/yyyy')
                .format(DateTime.parse(widget.user.createdAt!)),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildUserDetail(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontSize: 14,
                ),
          ),
          const SizedBox(height: 10),
          Text(
            value ?? "",
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 18,
                ),
          )
        ],
      ),
    );
  }
}
