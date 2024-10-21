import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gvm_flutter/src/views/landing/landing_common.dart';
import 'package:gvm_flutter/src/views/landing/login.dart';
import 'package:gvm_flutter/src/views/landing/signup.dart';

class LandingView extends StatelessWidget {
  const LandingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: LandingCommon.backgroundColor,
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
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  AppLocalizations.of(context).landingTitle,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: LandingCommon.textColor,
                  ),
                ),
                SizedBox(height: 40),
                LandingCommon.buildButton(
                  AppLocalizations.of(context).login,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginView()),
                  ),
                  false,
                ),
                SizedBox(height: 20),
                LandingCommon.buildButton(
                  AppLocalizations.of(context).register,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignupView()),
                  ),
                  false,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
