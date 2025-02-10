import 'package:async/async.dart';
import 'package:chatapp/features/auth/data/dto/user_dto.dart';
import 'package:chatapp/features/friends/data/repositories/friends_repository.dart';
import 'package:chatapp/features/users/data/repositories/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final friendsListProvider = StreamProvider<List<UserDTO?>>((ref) {
  final friendsRepo = ref.watch(friendsRepositoryProvider);
  final userRepo = ref.watch(userRepositoryProvider);

  return friendsRepo.getFriends().asyncMap((friendUids) async {
    final friendsStreams = friendUids!.map(userRepo.getUserDetails).toList();

    return StreamZip(friendsStreams).first;
  });
});

final friendRequestsProvider = StreamProvider<List<UserDTO?>>((ref) {
  final friendsRepo = ref.watch(friendsRepositoryProvider);
  final userRepo = ref.watch(userRepositoryProvider);

  return friendsRepo.getFriendsRequests().asyncMap((requestUids) async {
    final requestStreams = requestUids!.map(userRepo.getUserDetails).toList();

    return StreamZip(requestStreams).first;
  });
});
