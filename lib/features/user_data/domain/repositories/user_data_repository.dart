import 'package:chupachap/features/user_data/domain/entities/user_data.dart';

abstract class UserDataRepository {
  Future<UserData> getUserData();
}
