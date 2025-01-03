// signup_screen.dart
import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/features/auth/presentation/widgets/facebook_signin_button.dart';
import 'package:chupachap/features/auth/presentation/widgets/google_signin_button.dart';
import 'package:chupachap/features/home/presentation/widgets/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _firstNameController =
      TextEditingController(); // Added
  final TextEditingController _lastNameController =
      TextEditingController(); // Added
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _firstNameController.dispose(); // Added
    _lastNameController.dispose(); // Added
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is Authenticated) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const BottomNav()),
            );
          }
        },
        builder: (context, state) {
          final theme = Theme.of(context);
          final isDarkMode = theme.brightness == Brightness.dark;
          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only( left: 10, right: 10.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Create Account',
                          style: GoogleFonts.acme(
                            textStyle: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),

                        const SizedBox(height: 8),
                        Text('Sign up to get started',
                            style: GoogleFonts.acme(
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    color: isDarkMode
                                        ? AppColors.accentColorDark
                                        : AppColors.accentColor,
                                  )
                                  .copyWith(
                                    fontSize: 20,
                                  ),
                            )),
                        const SizedBox(height: 20),
                        // First Name Field
                        TextFormField(
                          controller: _firstNameController,
                          decoration: InputDecoration(
                            labelText: 'First Name',
                            prefixIcon: const Icon(Icons.person_outline),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Please enter your first name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        // Last Name Field
                        TextFormField(
                          controller: _lastNameController,
                          decoration: InputDecoration(
                            labelText: 'Last Name',
                            prefixIcon: const Icon(Icons.person_outline),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Please enter your last name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        // Email Field
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            prefixIcon: const Icon(Icons.email_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        // Password Field
                        TextFormField(
                          controller: _passwordController,
                          obscureText: !_isPasswordVisible,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        // Confirm Password Field
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: !_isConfirmPasswordVisible,
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isConfirmPasswordVisible
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isConfirmPasswordVisible =
                                      !_isConfirmPasswordVisible;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Please confirm your password';
                            }
                            if (value != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: state is AuthLoading
                              ? null
                              : () {
                                  if (_formKey.currentState?.validate() ??
                                      false) {
                                    context.read<AuthBloc>().add(
                                          SignupEvent(
                                            email: _emailController.text.trim(),
                                            password:
                                                _passwordController.text.trim(),
                                            firstName: _firstNameController.text
                                                .trim(), // Added
                                            lastName: _lastNameController.text
                                                .trim(), // Added
                                          ),
                                        );
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: state is AuthLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : const Text('Sign Up'),
                        ),
                     
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              const Expanded(
                                child: Divider(
                                  color: Colors.grey,
                                  thickness: 1,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Text(
                                  'Or Sign Up with',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: Colors.grey,
                                      ),
                                ),
                              ),
                              const Expanded(
                                child: Divider(
                                  color: Colors.grey,
                                  thickness: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GoogleSignInButton(),
                            const SizedBox(width: 30),
                            FacebookSignInButton(),
                          ],
                        ),
//                       SizedBox(height: 50,),

// Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             'Already have an account? ',
//                             style: GoogleFonts
//                                 .poppins(),
//                           ),
//                           TextButton(
//                             onPressed: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) =>
//                                       LoginScreen(),
//                                 ),
//                               );
//                             },
//                             child: Text(
//                               'Login',
//                               style: GoogleFonts.poppins(
//                                 color:
//                                     Colors.blue,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 17
//                               ),
//                             ),
//                           ),
//                         ],
//                       )
                        const SizedBox(height: 30),
                      ]),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
