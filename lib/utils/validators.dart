import 'package:formz/formz.dart';

// Email validation errors
enum EmailValidationError { empty, invalid }

class Email extends FormzInput<String, EmailValidationError> {
  const Email.pure() : super.pure('');
  const Email.dirty([super.value = '']) : super.dirty();

  // Email regex - took this from a stackoverflow answer
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  @override
  EmailValidationError? validator(String value) {
    if (value.isEmpty) return EmailValidationError.empty;
    if (!_emailRegExp.hasMatch(value)) return EmailValidationError.invalid;
    return null;
  }
}

// Password validation with specific requirements from assignment
enum PasswordValidationError { empty, tooWeak }

class Password extends FormzInput<String, PasswordValidationError> {
  const Password.pure() : super.pure('');
  const Password.dirty([super.value = '']) : super.dirty();

  // Password requirements: 8+ chars, uppercase, lowercase, number, special char
  static final RegExp _passwordRegExp = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
  );
  
  @override
  PasswordValidationError? validator(String value) {
    if (value.isEmpty) return PasswordValidationError.empty;
    if (!_passwordRegExp.hasMatch(value)) return PasswordValidationError.tooWeak;
    return null;
  }
}