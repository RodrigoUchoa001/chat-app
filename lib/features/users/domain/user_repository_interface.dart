import 'package:chatapp/features/auth/data/dto/user_dto.dart';

abstract interface class UserRepositoryInterface {
  Stream<UserDTO?> getUserDetails(String userId);
  Stream<List<UserDTO>> searchUsers(String query);
}
