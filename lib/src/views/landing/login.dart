import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gvm_flutter/src/services/api/api_errors.dart';
import 'package:gvm_flutter/src/services/auth/auth_manager.dart';
import 'package:gvm_flutter/src/views/landing/forgot_password.dart';
import 'package:gvm_flutter/src/views/landing/landing_common.dart';
import 'package:gvm_flutter/src/views/landing/signup.dart';
import 'package:gvm_flutter/src/widgets/layout/landing_layout.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return LandingLayout(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              AppLocalizations.of(context).login,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: LandingCommon.textColor,
              ),
            ),
            SizedBox(height: 40),
            LandingCommon.buildTextField(
                AppLocalizations.of(context).emailPlaceholder,
                _emailController,
                false,
                context),
            SizedBox(height: 20),
            LandingCommon.buildTextField(
                AppLocalizations.of(context).passwordPlaceholder,
                _passwordController,
                true,
                context),
            SizedBox(height: 20),
            Row(
              children: [
                Checkbox(
                  value: _rememberMe,
                  onChanged: (value) {
                    setState(() {
                      _rememberMe = value!;
                    });
                  },
                  activeColor: LandingCommon.accentColor,
                  side: BorderSide(color: LandingCommon.textColor),
                ),
                Text(
                  AppLocalizations.of(context).rememberMe,
                  style: TextStyle(color: LandingCommon.textColor),
                ),
              ],
            ),
            SizedBox(height: 40),
            LandingCommon.buildButton(AppLocalizations.of(context).login,
                _isLoading ? null : _submitForm, _isLoading),
            SizedBox(height: 20),
            LayoutBuilder(
              builder: (context, constraints) {
                // Get text scale factor for accessibility
                final textScaleFactor = MediaQuery.textScalerOf(context)
                    .scale(Theme.of(context).textTheme.bodySmall!.fontSize!);

                // Create the buttons first so we can measure them
                final buttonStyle = TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  backgroundColor:
                      LandingCommon.backgroundColor.withOpacity(0.8),
                );

                final forgotPasswordButton = TextButton(
                  style: buttonStyle,
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ForgotPasswordView()),
                  ),
                  child: Text(
                    AppLocalizations.of(context).forgotPassword,
                    style: TextStyle(color: LandingCommon.accentColor),
                  ),
                );

                final signupButton = TextButton(
                  style: buttonStyle,
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => SignupView()),
                  ),
                  child: Text(
                    AppLocalizations.of(context).dontHaveAccount,
                    style: TextStyle(color: LandingCommon.accentColor),
                  ),
                );

                // Calculate minimum width needed for each button
                final forgotPasswordText =
                    AppLocalizations.of(context).forgotPassword;
                final signupText = AppLocalizations.of(context).dontHaveAccount;

                // Use TextPainter to get accurate measurements
                final textPainter = TextPainter(
                  textDirection: TextDirection.ltr,
                  textScaleFactor: textScaleFactor,
                );

                textPainter.text = TextSpan(
                  text: forgotPasswordText,
                  style: TextStyle(color: LandingCommon.accentColor),
                );
                textPainter.layout();
                final forgotPasswordWidth = textPainter.width;

                textPainter.text = TextSpan(
                  text: signupText,
                  style: TextStyle(color: LandingCommon.accentColor),
                );
                textPainter.layout();
                final signupWidth = textPainter.width;

                // Calculate total width needed including padding and spacing
                final totalWidthNeeded = (forgotPasswordWidth + signupWidth) *
                        1.4 + // Button padding
                    (32 * 2 * 2) + // Horizontal padding for both buttons
                    20; // Space between buttons

                // Determine layout based on available width
                if (constraints.maxWidth >= totalWidthNeeded) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      forgotPasswordButton,
                      const SizedBox(width: 20),
                      signupButton,
                    ],
                  );
                } else {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      forgotPasswordButton,
                      const SizedBox(height: 20),
                      signupButton,
                    ],
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }

  void _submitForm() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await AuthManager.instance.login(
        _emailController.text,
        _passwordController.text,
        _rememberMe,
      );
      if (!mounted) return;

      Navigator.of(context).pop();
    } on APIException catch (e) {
      if (!mounted) return;
      switch (e.code) {
        case ErrorCode.INCORRECT_PASSWORD:
          LandingCommon.showMessage(
              context, AppLocalizations.of(context).incorrectPassword);
          break;
        case ErrorCode.USER_NOT_FOUND:
          LandingCommon.showMessage(
              context, AppLocalizations.of(context).userNotFound);
          break;
        default:
          LandingCommon.showMessage(
              context, AppLocalizations.of(context).anErrorOccurred);
          break;
      }
    } catch (e) {
      if (!mounted) return;
      debugPrint(e.toString());
      LandingCommon.showMessage(
          context, AppLocalizations.of(context).anErrorOccurred);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
