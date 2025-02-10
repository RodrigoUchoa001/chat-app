import 'package:chatapp/features/auth/data/repositories/auth_repository.dart';
import 'package:chatapp/features/auth/domain/repositories/auth_repository_interface.dart';
import 'package:riverpod/riverpod.dart';

final authControllerProvider = Provider<AuthController>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthController(authRepository);
});

class AuthController {
  final AuthRepositoryInterface _authRepository;

  AuthController(this._authRepository);

  Future<void> loginWithGoogle() async {
    await _authRepository.loginWithGoogle();
  }

  Future<void> loginWithEmailAndPassword(String email, String password) async {
    await _authRepository.loginWithEmailAndPassword(email, password);
  }

  Future<void> registerWithEmailAndPassword(
      String email, String password) async {
    await _authRepository.registerWithEmailAndPassword(email, password);
  }

  Future<void> logout() async {
    await _authRepository.logout();
  }
}
