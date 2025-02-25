import 'package:flutter/material.dart';
import 'social_button.dart';

class FacebookSignInButton extends StatelessWidget {
  const FacebookSignInButton({Key? key}) : super(key: key);

  Future<void> _handleFacebookSignIn(BuildContext context) async {
    try {
      // Implement Facebook Sign-In logic here

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Facebook Sign-In Successful')),
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
      text: 'Facebook',
      imagePath: 'assets/fb1.png',
      onPressed: () => _handleFacebookSignIn(context),
      buttonColor: const Color(0xFF1877F2),
      textColor: Colors.white,
    );
  }
}
