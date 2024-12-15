import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final String email;

  Authenticated({required this.email});

  @override
  List<Object?> get props => [email];
}

class AuthError extends AuthState {
  final String message;

  AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}

class Unauthenticated extends AuthState {}