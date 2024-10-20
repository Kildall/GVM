import 'package:flutter/material.dart';

class VerifyView extends StatelessWidget {
  const VerifyView({super.key});

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = Color(0xFFEEEAFF);
    final Color accentColor = Color(0xFFB1A6FF);
    final Color textColor = Color(0xFF1E1A33);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () =>
              Navigator.popUntil(context, (route) => route.isFirst),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          image: DecorationImage(
            image: AssetImage('assets/images/background_pattern.png'),
            repeat: ImageRepeat.repeat,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/verify_email.png',
                  height: 200,
                  width: 200,
                ),
                SizedBox(height: 40),
                Text(
                  'Verify Your Email',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    'We\'ve sent a verification email to your inbox. Please check and follow the instructions to complete your registration.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: textColor),
                  ),
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () =>
                      Navigator.popUntil(context, (route) => route.isFirst),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    foregroundColor: Colors.white,
                    minimumSize: Size(250, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text('Back to Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
