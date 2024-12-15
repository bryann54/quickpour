
import 'package:chupachap/features/auth/data/repositories/auth_repository.dart';

class AuthUseCases {
  final AuthRepository authRepository;

  AuthUseCases({required this.authRepository});

  Future<String> login(String email, String password) async {
    return await authRepository.login(email, password);
  }

  Future<String> register(String email, String password) async {
    return await authRepository.register(email, password);
  }

  Future<void> logout() async {
    await authRepository.logout();
  }
}


