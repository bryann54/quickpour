import 'package:chupachap/features/auth/data/repositories/auth_repository.dart';
import 'package:chupachap/features/user_data/domain/entities/user_data.dart';
import 'package:chupachap/features/user_data/domain/repositories/user_data_repository.dart';

class UserDataRepositoryImpl implements UserDataRepository {
  final AuthRepository _authRepository;

  UserDataRepositoryImpl({
    required AuthRepository authRepository,
  }) : _authRepository = authRepository;

  @override
  Future<UserData> getUserData() async {
    final user = await _authRepository.getCurrentUserDetails();

    if (user == null) {
      throw Exception('User not authenticated');
    }

    return UserData(
      id: _authRepository.getCurrentUserId() ?? '',
      name: user.firstName,
      location: 'Unknown', // You might want to add location to your User model
      email: user.email,
      photoUrl: user.profileImage,
    );
  }
}
