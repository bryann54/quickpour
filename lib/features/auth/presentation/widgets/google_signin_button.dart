import 'package:flutter/material.dart';
import 'social_button.dart';

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({Key? key}) : super(key: key);

  Future<void> _handleGoogleSignIn(BuildContext context) async {
    try {
      // Implement Google Sign-In logic here

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Google Sign-In Successful')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SocialButton(
      text: ' Google',
      imagePath: 'assets/google.png',
      onPressed: () => _handleGoogleSignIn(context),
      buttonColor: Colors.white,
      textColor: Colors.black,
    );
  }
}
