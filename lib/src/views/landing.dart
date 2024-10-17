import 'package:flutter/material.dart';
import 'package:gvm_flutter/src/services/auth/auth_manager.dart';

class LandingView extends StatefulWidget {
  const LandingView({Key? key}) : super(key: key);

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
  bool _showAuthForm = false;
  bool _isLoginView = true;

  // Define colors
  final Color _backgroundColor =
      Color(0xFFEEEAFF); // Light cool purple background
  final Color _accentColor = Color(0xFFB1A6FF); // Deep purple-blue accent color
  final Color _textColor = Color(0xFF1E1A33); // Very dark purple-blue for text

  void _toggleAuthForm() {
    setState(() {
      _showAuthForm = !_showAuthForm;
      if (!_showAuthForm) {
        _clearControllers();
      }
    });
  }

  void _toggleAuthMode() {
    setState(() {
      _isLoginView = !_isLoginView;
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
        if (_isLoginView) {
          await AuthManager.instance
              .login(_emailController.text, _passwordController.text, false);
          _showMessage('Login successful');
        } else {
          await AuthManager.instance.signup(_emailController.text,
              _passwordController.text, _nameController.text);
          _showMessage('Sign up successful');
        }
        _toggleAuthForm();
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
                if (_showAuthForm)
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: IconButton(
                        icon: Icon(Icons.arrow_back, color: _textColor),
                        onPressed: _toggleAuthForm,
                      ),
                    ),
                  ),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      child: _showAuthForm
                          ? _buildAuthForm()
                          : _buildWelcomeButtons(),
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

  Widget _buildWelcomeButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Add logo here
        // Image.asset('assets/logo.png', height: 100),
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
        _buildButton('Login', () {
          setState(() {
            _isLoginView = true;
            _toggleAuthForm();
          });
        }),
        SizedBox(height: 20),
        _buildButton('Sign Up', () {
          setState(() {
            _isLoginView = false;
            _toggleAuthForm();
          });
        }),
      ],
    );
  }

  Widget _buildAuthForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 40),
            Text(
              _isLoginView ? 'Login' : 'Sign Up',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: _textColor,
              ),
            ),
            SizedBox(height: 40),
            if (!_isLoginView) _buildTextField('Name', _nameController, false),
            if (!_isLoginView) SizedBox(height: 20),
            _buildTextField('Email', _emailController, false),
            SizedBox(height: 20),
            _buildTextField('Password', _passwordController, true),
            if (!_isLoginView) SizedBox(height: 20),
            if (!_isLoginView)
              _buildTextField(
                  'Confirm Password', _confirmPasswordController, true),
            SizedBox(height: 40),
            _buildButton(_isLoginView ? 'Log In' : 'Sign Up',
                _isLoading ? null : _submitForm),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    _isLoginView
                        ? "Don't have an account?"
                        : "Already have an account?",
                    style: TextStyle(color: _textColor)),
                TextButton(
                  onPressed: _toggleAuthMode,
                  child: Text(_isLoginView ? 'Create now' : 'Login',
                      style: TextStyle(color: _accentColor)),
                ),
              ],
            ),
          ],
        ),
      ),
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
        suffixIcon: isPassword && _isLoginView
            ? TextButton(
                onPressed: () {
                  // Handle forgot password
                },
                child: Text('Forgot?', style: TextStyle(color: _accentColor)),
              )
            : null,
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
