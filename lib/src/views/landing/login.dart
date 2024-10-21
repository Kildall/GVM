import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gvm_flutter/src/services/api/api_errors.dart';
import 'package:gvm_flutter/src/services/auth/auth_manager.dart';
import 'package:gvm_flutter/src/views/landing/forgot_password.dart';
import 'package:gvm_flutter/src/views/landing/landing_common.dart';
import 'package:gvm_flutter/src/views/landing/signup.dart';

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: LandingCommon.textColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
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
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
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
                          ),
                          Text(
                            AppLocalizations.of(context).rememberMe,
                            style: TextStyle(color: LandingCommon.textColor),
                          ),
                        ],
                      ),
                      SizedBox(height: 40),
                      LandingCommon.buildButton(
                          AppLocalizations.of(context).login,
                          _isLoading ? null : _submitForm,
                          _isLoading),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ForgotPasswordView()),
                            ),
                            child: Text(
                                AppLocalizations.of(context).forgotPassword,
                                style: TextStyle(
                                    color: LandingCommon.accentColor)),
                          ),
                          SizedBox(width: 20),
                          TextButton(
                            onPressed: () => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignupView()),
                            ),
                            child: Text(
                                AppLocalizations.of(context).alreadyHaveAccount,
                                style: TextStyle(
                                    color: LandingCommon.accentColor)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
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
    } on AuthException catch (e) {
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
