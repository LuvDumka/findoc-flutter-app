import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:google_fonts/google_fonts.dart';
import '../blocs/login/login_bloc.dart';
import '../blocs/login/login_event.dart';
import '../blocs/login/login_state.dart';
import '../services/api_service.dart';
import '../utils/validators.dart';
import 'home_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocProvider(
        create: (context) => LoginBloc(authService: AuthService()),
        child: const LoginForm(),
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.status == FormzSubmissionStatus.success) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const HomeScreen()),
          );
        } else if (state.status == FormzSubmissionStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Login failed'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Logo/Title Section
            Container(
              margin: const EdgeInsets.only(bottom: 48.0),
              child: Column(
                children: [
                  Icon(
                    Icons.photo_library_outlined,
                    size: 80,
                    color: Colors.blue.shade600,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Findoc',
                    style: GoogleFonts.montserrat(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Welcome back! Please sign in.',
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            
            // Email Field
            const EmailInput(),
            const SizedBox(height: 16),
            
            // Password Field
            const PasswordInput(),
            const SizedBox(height: 32),
            
            // Submit Button
            const SubmitButton(),
          ],
        ),
      ),
    );
  }
}

class EmailInput extends StatelessWidget {
  const EmailInput({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextFormField(
          onChanged: (email) => context.read<LoginBloc>().add(EmailChanged(email)),
          decoration: InputDecoration(
            labelText: 'Email',
            prefixIcon: const Icon(Icons.email_outlined),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            errorText: state.email.displayError != null
                ? _getEmailErrorText(state.email.displayError!)
                : null,
          ),
          keyboardType: TextInputType.emailAddress,
          style: GoogleFonts.montserrat(),
        );
      },
    );
  }

  String _getEmailErrorText(EmailValidationError error) {
    switch (error) {
      case EmailValidationError.empty:
        return 'Please enter your email';
      case EmailValidationError.invalid:
        return 'That doesn\'t look like a valid email';
    }
  }
}

class PasswordInput extends StatefulWidget {
  const PasswordInput({super.key});

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextFormField(
          onChanged: (password) => 
              context.read<LoginBloc>().add(PasswordChanged(password)),
          obscureText: _isObscured,
          decoration: InputDecoration(
            labelText: 'Password',
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(_isObscured ? Icons.visibility : Icons.visibility_off),
              onPressed: () => setState(() => _isObscured = !_isObscured),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            errorText: state.password.displayError != null
                ? _getPasswordErrorText(state.password.displayError!)
                : null,
          ),
          style: GoogleFonts.montserrat(),
        );
      },
    );
  }

  String _getPasswordErrorText(PasswordValidationError error) {
    switch (error) {
      case PasswordValidationError.empty:
        return 'Password cannot be empty';
      case PasswordValidationError.tooWeak:
        return 'Password needs 8+ chars with uppercase, lowercase, number & symbol';
    }
  }
}

class SubmitButton extends StatelessWidget {
  const SubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return ElevatedButton(
          onPressed: state.isValid
              ? () => context.read<LoginBloc>().add(const LoginFormSubmitted())
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade600,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
          ),
          child: state.status == FormzSubmissionStatus.inProgress
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(
                  'Sign In',
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        );
      },
    );
  }
}
