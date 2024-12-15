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
        final email = await authUseCases.login(event.email, event.password);
        emit(Authenticated(email: email));
      } catch (e) {
        emit(AuthError(message: e.toString()));
      }
    });

on<SignupEvent>((event, emit) async {
      emit(AuthLoading()); // Emit loading state before the sign-up process

      try {
        // Call your use case to register the user
        final email = await authUseCases.register(event.email, event.password);

        // Emit Authenticated state with the email (or user data if needed)
        emit(Authenticated(email: email));
      } catch (e) {
        // Handle errors by emitting AuthError with the error message
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
