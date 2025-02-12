abstract interface class AuthRepositoryInterface {
  Future<bool> loginWithGoogle();
  Future<bool> loginWithEmailAndPassword(String email, String password);
  Future<String?> registerWithEmailAndPassword(
      String name, String email, String password);
  Future<void> logout();
}
