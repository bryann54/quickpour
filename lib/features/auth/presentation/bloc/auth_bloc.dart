import 'package:bloc/bloc.dart';
import 'package:chupachap/features/auth/domain/usecases/auth_usecases.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthUseCases authUseCases;

  AuthBloc({required this.authUseCases}) : super(AuthInitial()) {
    on<LoginEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final email = await authUseCases.login(
            email: event.email, password: event.password);
        emit(Authenticated(email: email));
      } catch (e) {
        emit(AuthError(message: e.toString()));
      }
    });

    on<SignupEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final email = await authUseCases.register(
            email: event.email,
            password: event.password,
            firstName: event.firstName,
            lastName: event.lastName);
        emit(Authenticated(email: email));
      } catch (e) {
        emit(AuthError(message: e.toString()));
      }
    });

    on<LogoutEvent>((event, emit) async {
      emit(AuthLoading());
      await authUseCases.logout();
      emit(Unauthenticated());
    });
  }
}
