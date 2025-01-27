import 'package:equatable/equatable.dart';

class UserData extends Equatable {
  final String id;
  final String name;
  final String location;
  final String email;
  final String? photoUrl;

  const UserData({
    required this.id,
    required this.name,
    required this.location,
    required this.email,
    this.photoUrl,
  });

  @override
  List<Object?> get props => [id, name, location, email, photoUrl];
}
