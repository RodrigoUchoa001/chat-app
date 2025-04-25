import 'dart:io';

import 'package:chatapp/core/localization/app_localization.dart';
import 'package:chatapp/core/localization/locale_provider.dart';
import 'package:chatapp/core/providers/firebase_auth_providers.dart';
import 'package:chatapp/core/widgets/media_player_widget.dart';
import 'package:chatapp/features/auth/presentation/widgets/auth_back_button.dart';
import 'package:chatapp/features/media/data/repositories/media_repository.dart';
import 'package:chatapp/features/users/data/repositories/user_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class ViewProfilePicScreen extends ConsumerStatefulWidget {
  final String userId;
  const ViewProfilePicScreen({required this.userId, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ViewProfilePicScreenState();
}

class _ViewProfilePicScreenState extends ConsumerState<ViewProfilePicScreen> {
  @override
  Widget build(BuildContext context) {
    final userRepo = ref.watch(userRepositoryProvider);
    final currentUser = ref.watch(currentUserProvider).asData?.value;

    return SafeArea(
      child: StreamBuilder(
        stream: userRepo.getUserDetails(widget.userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          final user = snapshot.data;

          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              leading: AuthBackButton(),
              title: Text(user!.name!),
              centerTitle: true,
              actions: [
                if (user.uid == currentUser!.uid)
                  IconButton(
                    onPressed: () {
                      _pickAndSendMedia(ref);
                    },
                    icon: const Icon(Icons.edit),
                  ),
                const SizedBox(width: 10),
                if (user.uid == currentUser.uid)
                  IconButton(
                    onPressed: () {
                      userRepo.removeUserProfilePic();
                      Fluttertoast.showToast(msg: 'Profile picture removed!');
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.delete),
                  ),
                const SizedBox(width: 10),
              ],
            ),
            body: Hero(
              tag: 'profilePic',
              child: MediaPlayerWidget(
                mediaUrl: user.photoURL!,
                isVideo: false,
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _pickAndSendMedia(WidgetRef ref) async {
    // TODO: DOENS'T WORK IN WEB, FIX
    if (kIsWeb) {
      Fluttertoast.showToast(msg: "Not supported in web for now");
      return;
    }

    final userRepo = ref.watch(userRepositoryProvider);
    final mediaRepo = ref.read(mediaRepositoryProvider);

    final picker = ImagePicker();
    final pickedFile = await picker.pickMedia();
    final pickedFileFormat = pickedFile?.path.split(".").last;

    final local = ref.watch(localeProvider);
    final localization = ref.watch(localizationProvider(local)).value;

    if (pickedFile != null && pickedFileFormat == "mp4" ||
        pickedFileFormat == "jpg" ||
        pickedFileFormat == "png" ||
        pickedFileFormat == "jpeg") {
      final mediaFile = File(pickedFile!.path);
      final mediaUrl = await mediaRepo.uploadMedia(mediaFile, isVideo: false);

      if (mediaUrl != null) {
        userRepo.updateUserProfilePic(photoURL: mediaUrl);
        context.pop();

        Fluttertoast.showToast(msg: localization!.translate("image-sent"));
      }
    } else if (pickedFileFormat == null) {
    } else {
      Fluttertoast.showToast(
          msg:
              "${localization!.translate("invalid-media-format")}: $pickedFileFormat");
    }
  }
}
