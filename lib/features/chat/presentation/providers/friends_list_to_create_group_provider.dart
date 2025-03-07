import 'package:chatapp/features/auth/data/dto/user_dto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final friendsListToCreateGroupProvider =
    StateProvider<List<UserDTO>>((ref) => []);
