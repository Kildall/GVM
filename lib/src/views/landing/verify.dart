import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gvm_flutter/src/views/landing/landing_common.dart';
import 'package:gvm_flutter/src/widgets/layout/landing_layout.dart';

class VerifyView extends StatelessWidget {
  const VerifyView({super.key});

  @override
  Widget build(BuildContext context) {
    return LandingLayout(
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
            AppLocalizations.of(context).verifyEmail,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: LandingCommon.textColor,
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              AppLocalizations.of(context).verifyEmailText,
              textAlign: TextAlign.center,
              style: TextStyle(color: LandingCommon.textColor),
            ),
          ),
          SizedBox(height: 40),
          ElevatedButton(
            onPressed: () =>
                Navigator.popUntil(context, (route) => route.isFirst),
            style: ElevatedButton.styleFrom(
              backgroundColor: LandingCommon.accentColor,
              foregroundColor: Colors.white,
              minimumSize: Size(250, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: Text(AppLocalizations.of(context).backToLogin),
          ),
        ],
      ),
    );
  }
}