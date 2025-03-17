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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 41),
          _buildUserDetail(
            "Display Name",
            widget.user.name,
          ),
          _buildUserDetail(
            "Email Address",
            widget.user.email,
          ),
          _buildUserDetail(
            "Status Message",
            widget.user.statusMessage,
          ),
          _buildUserDetail(
            "Joined At",
            DateFormat('dd/MM/yyyy')
                .format(DateTime.parse(widget.user.createdAt!)),
          ),
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
