class AuthService {
  Future<bool> login(String email, String password, String role) async {
    // Simulate a network/auth request delay
    await Future.delayed(const Duration(seconds: 1));
    return email.trim().isNotEmpty && password.isNotEmpty;
  }
}
