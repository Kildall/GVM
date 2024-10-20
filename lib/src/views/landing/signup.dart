import 'package:flutter/material.dart';
import 'package:gvm_flutter/src/services/api/api_errors.dart';
import 'package:gvm_flutter/src/services/auth/auth_manager.dart';
import 'package:gvm_flutter/src/views/landing/landing_common.dart';
import 'package:gvm_flutter/src/views/landing/login.dart';

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
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: LandingCommon.textColor,
                        ),
                      ),
                      SizedBox(height: 40),
                      LandingCommon.buildTextField(
                          'Name', _nameController, false),
                      SizedBox(height: 20),
                      LandingCommon.buildTextField(
                          'Email', _emailController, false),
                      SizedBox(height: 20),
                      LandingCommon.buildTextField(
                          'Password', _passwordController, true),
                      SizedBox(height: 20),
                      LandingCommon.buildTextField(
                          'Confirm Password', _confirmPasswordController, true),
                      SizedBox(height: 40),
                      LandingCommon.buildButton('Sign Up',
                          _isLoading ? null : _submitForm, _isLoading),
                      SizedBox(height: 20),
                      TextButton(
                        onPressed: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginView()),
                        ),
                        child: Text('Already have an account?',
                            style: TextStyle(color: LandingCommon.accentColor)),
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
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });
    try {
      await AuthManager.instance.signup(
        _nameController.text,
        _emailController.text,
        _passwordController.text,
      );
    } on AuthException catch (e) {
      if (!mounted) return;
      switch (e.code) {
        case ErrorCode.USER_ALREADY_EXISTS:
          LandingCommon.showMessage(context, 'User already exists');
          break;
        default:
          LandingCommon.showMessage(context, 'An error occurred');
          break;
      }
    } catch (e) {
      if (!mounted) return;
      debugPrint(e.toString());
      LandingCommon.showMessage(context, 'An error occurred');
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
