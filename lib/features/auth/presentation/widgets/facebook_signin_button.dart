import 'package:flutter/material.dart';
import 'social_button.dart';

class FacebookSignInButton extends StatelessWidget {


  const FacebookSignInButton({Key? key, })
      : super(key: key);

  Future<void> _handleFacebookSignIn(BuildContext context) async {
    try {
      // Implement Facebook Sign-In logic using authUseCases
      // final result = await authUseCases.signInWithFacebook();

      // if (result != null) {
      //   // Navigate to home or perform any post-sign-in actions
      //   // Example: Navigator.of(context).pushReplacement(...)
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text('Facebook Sign-In Successful')),
      //   );
      // } else {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text('Facebook Sign-In Failed')),
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
      imagePath: 'assets/fb1.png',
      onPressed: () => _handleFacebookSignIn(context),
    );
  }
}
