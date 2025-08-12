import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import '../../services/api_service.dart';
import '../../utils/validators.dart';
import 'login_event.dart';
import 'login_state.dart';

// Login BLoC to handle authentication logic
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthService _authService;

  LoginBloc({required AuthService authService})
      : _authService = authService,
        super(const LoginState()) {
    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<LoginFormSubmitted>(_onLoginFormSubmitted);
  }

  // Handle email input changes
  void _onEmailChanged(EmailChanged event, Emitter<LoginState> emit) {
    final email = Email.dirty(event.email);
    emit(
      state.copyWith(
        email: email,
        isValid: Formz.validate([email, state.password]),
        status: FormzSubmissionStatus.initial,
        errorMessage: null,
      ),
    );
  }

  // Handle password input changes
  void _onPasswordChanged(PasswordChanged event, Emitter<LoginState> emit) {
    final password = Password.dirty(event.password);
    emit(
      state.copyWith(
        password: password,
        isValid: Formz.validate([state.email, password]),
        status: FormzSubmissionStatus.initial,
        errorMessage: null,
      ),
    );
  }

  // Handle form submission
  Future<void> _onLoginFormSubmitted(
    LoginFormSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    if (state.isValid) {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
      
      try {
        final success = await _authService.login(
          state.email.value,
          state.password.value,
        );
        
        if (success) {
          emit(state.copyWith(status: FormzSubmissionStatus.success));
        } else {
          emit(
            state.copyWith(
              status: FormzSubmissionStatus.failure,
              errorMessage: 'Login failed. Check your credentials.',
            ),
          );
        }
      } catch (error) {
        emit(
          state.copyWith(
            status: FormzSubmissionStatus.failure,
            errorMessage: 'Something went wrong. Please try again.',
          ),
        );
      }
    }
  }
}
