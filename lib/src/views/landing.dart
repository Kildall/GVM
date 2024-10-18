import 'package:flutter/material.dart';
import 'package:gvm_flutter/src/services/auth/auth_manager.dart';

enum ViewState { landing, login, signup, verify, forgot }

class LandingView extends StatefulWidget {
  const LandingView({super.key});

  @override
  _LandingViewState createState() => _LandingViewState();
}

class _LandingViewState extends State<LandingView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isLoading = false;

  // Define the view states
  ViewState _currentState = ViewState.landing;

  // Define colors
  final Color _backgroundColor = Color(0xFFEEEAFF);
  final Color _accentColor = Color(0xFFB1A6FF);
  final Color _textColor = Color(0xFF1E1A33);

  void _changeState(ViewState newState) {
    setState(() {
      _currentState = newState;
      _clearControllers();
    });
  }

  void _clearControllers() {
    _emailController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
    _nameController.clear();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        if (_currentState == ViewState.login) {
          await AuthManager.instance
              .login(_emailController.text, _passwordController.text, false);
          _showMessage('Login successful');
        } else if (_currentState == ViewState.signup) {
          await AuthManager.instance.signup(_emailController.text,
              _passwordController.text, _nameController.text);
          _changeState(ViewState.verify);
        }
      } catch (e) {
        _showMessage('An error occurred: ${e.toString()}');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background with artifacts
          Container(
            decoration: BoxDecoration(
              color: _backgroundColor,
              image: DecorationImage(
                image: AssetImage('assets/images/background_pattern.png'),
                repeat: ImageRepeat.repeat,
              ),
            ),
          ),
          // Top-left triangle
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: _accentColor.withOpacity(0.1),
                borderRadius:
                    BorderRadius.only(bottomRight: Radius.circular(150)),
              ),
            ),
          ),
          // Bottom-right triangle
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: _accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(200)),
              ),
            ),
          ),
          // Main content
          SafeArea(
            child: Column(
              children: [
                // Back button
                if (_currentState != ViewState.landing)
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: IconButton(
                        icon: Icon(Icons.arrow_back, color: _textColor),
                        onPressed: () => _changeState(ViewState.landing),
                      ),
                    ),
                  ),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      child: _buildCurrentView(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentView() {
    switch (_currentState) {
      case ViewState.landing:
        return _buildLandingView();
      case ViewState.login:
        return _buildAuthForm(true);
      case ViewState.signup:
        return _buildAuthForm(false);
      case ViewState.verify:
        return _buildVerifyView();
      case ViewState.forgot:
        return _buildForgotView();
    }
  }

  Widget _buildLandingView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 40),
        Text(
          'Welcome',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: _textColor,
          ),
        ),
        SizedBox(height: 40),
        _buildButton('Login', () => _changeState(ViewState.login)),
        SizedBox(height: 20),
        _buildButton('Sign Up', () => _changeState(ViewState.signup)),
      ],
    );
  }

  Widget _buildAuthForm(bool isLogin) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 40),
            Text(
              isLogin ? 'Login' : 'Sign Up',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: _textColor,
              ),
            ),
            SizedBox(height: 40),
            if (!isLogin) _buildTextField('Name', _nameController, false),
            if (!isLogin) SizedBox(height: 20),
            _buildTextField('Email', _emailController, false),
            SizedBox(height: 20),
            _buildTextField('Password', _passwordController, true),
            if (!isLogin) SizedBox(height: 20),
            if (!isLogin)
              _buildTextField(
                  'Confirm Password', _confirmPasswordController, true),
            SizedBox(height: 40),
            _buildButton(isLogin ? 'Log In' : 'Sign Up',
                _isLoading ? null : _submitForm),
            SizedBox(height: 20),
            if (isLogin)
              TextButton(
                onPressed: () => _changeState(ViewState.forgot),
                child: Text('Forgot Password?',
                    style: TextStyle(color: _accentColor)),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    isLogin
                        ? "Don't have an account?"
                        : 'Already have an account?',
                    style: TextStyle(color: _textColor)),
                TextButton(
                  onPressed: () => _changeState(
                      isLogin ? ViewState.signup : ViewState.login),
                  child: Text(isLogin ? 'Create now' : 'Login',
                      style: TextStyle(color: _accentColor)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerifyView() {
    return Column(
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
            color: _textColor,
          ),
        ),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            'We\'ve sent a verification email to your inbox. Please check and follow the instructions to complete your registration.',
            textAlign: TextAlign.center,
            style: TextStyle(color: _textColor),
          ),
        ),
        SizedBox(height: 40),
        _buildButton('Back to Login', () => _changeState(ViewState.login)),
      ],
    );
  }

  Widget _buildForgotView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/forgot_password.png',
          height: 200,
          width: 200,
        ),
        SizedBox(height: 40),
        Text(
          'Forgot Password?',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: _textColor,
          ),
        ),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            'Please contact support@gvm.ar for assistance in resetting your password.',
            textAlign: TextAlign.center,
            style: TextStyle(color: _textColor),
          ),
        ),
        SizedBox(height: 40),
        _buildButton('Back to Login', () => _changeState(ViewState.login)),
      ],
    );
  }

  Widget _buildTextField(
      String label, TextEditingController controller, bool isPassword) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: label,
        labelStyle: TextStyle(color: _textColor),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: _accentColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: _accentColor, width: 2),
        ),
      ),
      obscureText: isPassword,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'This field is required';
        }
        if (label == 'Email' &&
            !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return 'Please enter a valid email address';
        }
        if (label == 'Confirm Password' && value != _passwordController.text) {
          return 'Passwords do not match';
        }
        return null;
      },
    );
  }

  Widget _buildButton(String text, VoidCallback? onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: _accentColor,
        foregroundColor: Colors.white,
        minimumSize: Size(250, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
      child: _isLoading && (text == 'Log In' || text == 'Sign Up')
          ? CircularProgressIndicator(color: Colors.white)
          : Text(text),
    );
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
