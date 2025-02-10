abstract interface class AuthRepositoryInterface {
  Future<bool> loginWithGoogle();
  Future<bool> loginWithEmailAndPassword(String email, String password);
  Future<bool> registerWithEmailAndPassword(String email, String password);
  Future<void> logout();
}
