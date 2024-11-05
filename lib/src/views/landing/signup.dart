import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gvm_flutter/src/services/api/api_errors.dart';
import 'package:gvm_flutter/src/services/auth/auth_manager.dart';
import 'package:gvm_flutter/src/views/landing/landing_common.dart';
import 'package:gvm_flutter/src/views/landing/login.dart';
import 'package:gvm_flutter/src/views/landing/verify.dart';
import 'package:gvm_flutter/src/widgets/layout/landing_layout.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  _SignupViewState createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  final _positionController = TextEditingController();
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
              AppLocalizations.of(context).register,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: LandingCommon.textColor,
              ),
            ),
            SizedBox(height: 40),
            LandingCommon.buildTextField(
                AppLocalizations.of(context).namePlaceholder,
                _nameController,
                false,
                context),
            SizedBox(height: 20),
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
            LandingCommon.buildTextField(
                AppLocalizations.of(context).confirmPassword,
                _confirmPasswordController,
                true,
                context),
            SizedBox(height: 20),
            LandingCommon.buildTextField(AppLocalizations.of(context).position,
                _positionController, false, context),
            SizedBox(height: 40),
            LandingCommon.buildButton(AppLocalizations.of(context).register,
                _isLoading ? null : _submitForm, _isLoading),
            SizedBox(height: 20),
            TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                backgroundColor: LandingCommon.backgroundColor.withOpacity(0.8),
              ),
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginView()),
              ),
              child: Text(AppLocalizations.of(context).alreadyHaveAccount,
                  style: TextStyle(color: LandingCommon.accentColor)),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });
    try {
      debugPrint('email ${_emailController.text}');
      await AuthManager.instance.signup(
        _emailController.text,
        _passwordController.text,
        _nameController.text,
        _positionController.text,
      );
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => VerifyView()),
        );
      }
    } on AuthException catch (e) {
      if (!mounted) return;
      switch (e.code) {
        case ErrorCode.USER_ALREADY_EXISTS:
          LandingCommon.showMessage(
              context, AppLocalizations.of(context).userAlreadyExists);
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
    _confirmPasswordController.dispose();
    _nameController.dispose();
    super.dispose();
  }
}
