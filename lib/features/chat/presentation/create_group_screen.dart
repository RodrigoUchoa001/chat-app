import 'package:chatapp/core/providers/firebase_auth_providers.dart';
import 'package:chatapp/core/widgets/chat_text_button.dart';
import 'package:chatapp/features/auth/presentation/widgets/auth_back_button.dart';
import 'package:chatapp/features/chat/presentation/widgets/chat_profile_pic.dart';
import 'package:chatapp/features/users/data/repositories/user_repository.dart';
import 'package:chatapp/gen/fonts.gen.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateGroupScreen extends ConsumerStatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateGroupScreenState();
}

class _CreateGroupScreenState extends ConsumerState<CreateGroupScreen> {
  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider).asData?.value;
    final userRepo = ref.watch(userRepositoryProvider);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF121414),
        appBar: AppBar(
          toolbarHeight: 124,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: AuthBackButton(),
          centerTitle: true,
          title: const Text(
            'Create Group',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: FontFamily.caros,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Group Name',
                      style: TextStyle(
                        color: Color(0xFF797C7B),
                        fontSize: 16,
                        fontFamily: FontFamily.caros,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontFamily: FontFamily.caros,
                      ),
                      maxLines: 1,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Type the Group Name',
                        hintStyle: const TextStyle(
                          color: Color(0xFF797C7B),
                          fontSize: 40,
                          fontFamily: FontFamily.caros,
                        ),
                      ),
                      autofocus: true,
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Group Admin',
                      style: TextStyle(
                        color: Color(0xFF797C7B),
                        fontSize: 16,
                        fontFamily: FontFamily.caros,
                      ),
                    ),
                    const SizedBox(height: 20),
                    StreamBuilder(
                      stream: userRepo.getUserDetails(currentUser!.uid),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }

                        final user = snapshot.data!;
                        final isPhotoValid = user.photoURL != null &&
                            user.photoURL!.isNotEmpty &&
                            user.photoURL != 'null';

                        return Row(
                          children: [
                            isPhotoValid
                                ? ChatProfilePic(
                                    chatPhotoURL: user.photoURL,
                                    isOnline: false,
                                  )
                                : ChatProfilePic(
                                    isOnline: false,
                                  ),
                            const SizedBox(width: 12),
                            Text(
                              user.name ?? '',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: FontFamily.caros,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Invited Members',
                      style: TextStyle(
                        color: Color(0xFF797C7B),
                        fontSize: 16,
                        fontFamily: FontFamily.caros,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // TODO: Make the button work
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(50),
                        onTap: () {},
                        child: DottedBorder(
                          dashPattern: [8, 4],
                          borderType: BorderType.Circle,
                          color: Color(0xFF323C37),
                          child: SizedBox(
                            height: 70,
                            width: 70,
                            child: Icon(
                              Icons.add,
                              size: 24,
                              color: Color(0xFF323C37),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ChatTextButton(
                onTap: () {},
                text: "Create",
                buttonColor: Color(0xFF24786D),
                textColor: Colors.white,
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
