import 'package:flutter/material.dart';
import 'social_button.dart';

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({
    Key? key,
  }) : super(key: key);

  Future<void> _handleGoogleSignIn(BuildContext context) async {
    try {
      // // Implement Google Sign-In logic using authUseCases
      // final result = await authUseCases.signInWithGoogle();

      // if (result != null) {
      //   // Navigate to home or perform any post-sign-in actions
      //   // Example: Navigator.of(context).pushReplacement(...)
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text('Google Sign-In Successful')),
      //   );
      // } else {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text('Google Sign-In Failed')),
      //   );
      // }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SocialButton(
      imagePath: 'assets/google.png',
      onPressed: () => _handleGoogleSignIn(context),
    );
  }
}
