import 'package:flutter/material.dart';
import 'package:gvm_flutter/src/services/auth/auth_manager.dart';

class LandingView extends StatefulWidget {
  const LandingView({Key? key}) : super(key: key);

  @override
  _LandingViewState createState() => _LandingViewState();
}

class _LandingViewState extends State<LandingView> {
  final _loginFormKey = GlobalKey<FormState>();
  final _signupFormKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  bool remember = false;
  bool _isLoading = false;
  bool _isLoginView = true;
  bool _showAuthForm = false;

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
    final formKey = _isLoginView ? _loginFormKey : _signupFormKey;
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        if (_isLoginView) {
          await AuthManager.instance
              .login(_emailController.text, _passwordController.text, remember);
        } else {
          await AuthManager.instance.signup(_emailController.text,
              _passwordController.text, _nameController.text);
        }
        _showMessage(_isLoginView ? 'Login successful' : 'Signup successful');
        _toggleAuthForm(); // Go back to welcome screen after successful auth
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
      appBar: AppBar(title: Text('Welcome')),
      body: Center(
        child: _showAuthForm ? _buildAuthForm() : _buildWelcomeButtons(),
      ),
    );
  }

  Widget _buildWelcomeButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          child: Text('Login'),
          onPressed: () {
            setState(() {
              _isLoginView = true;
              _toggleAuthForm();
            });
          },
        ),
        SizedBox(height: 20),
        ElevatedButton(
          child: Text('Sign Up'),
          onPressed: () {
            setState(() {
              _isLoginView = false;
              _toggleAuthForm();
            });
          },
        ),
      ],
    );
  }

  Widget _buildAuthForm() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoginView ? _buildLoginForm() : _buildSignupForm(),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _loginFormKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Login',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          SizedBox(height: 24),
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(labelText: 'Email'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                  .hasMatch(value)) {
                return 'Please enter a valid email address';
              }
              return null;
            },
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Checkbox(
                value: remember,
                onChanged: (bool? value) {
                  setState(() {
                    remember = value ?? false;
                  });
                },
              ),
              Text('Remember me'),
            ],
          ),
          SizedBox(height: 24),
          _buildSubmitButton(),
          SizedBox(height: 16),
          _buildToggleAuthModeButton(),
          SizedBox(height: 16),
          _buildBackButton(),
        ],
      ),
    );
  }

  Widget _buildSignupForm() {
    return Form(
      key: _signupFormKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Sign Up',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          SizedBox(height: 24),
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Name'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(labelText: 'Email'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                  .hasMatch(value)) {
                return 'Please enter a valid email address';
              }
              return null;
            },
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a password';
              }
              if (value.length < 8) {
                return 'Password must be at least 8 characters long';
              }
              return null;
            },
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: _confirmPasswordController,
            decoration: InputDecoration(labelText: 'Confirm Password'),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please confirm your password';
              }
              if (value != _passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          SizedBox(height: 24),
          _buildSubmitButton(),
          SizedBox(height: 16),
          _buildToggleAuthModeButton(),
          SizedBox(height: 16),
          _buildBackButton(),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _submitForm,
      child: _isLoading
          ? CircularProgressIndicator()
          : Text(_isLoginView ? 'Login' : 'Sign Up'),
    );
  }

  Widget _buildToggleAuthModeButton() {
    return TextButton(
      onPressed: _toggleAuthMode,
      child: Text(_isLoginView
          ? 'Need an account? Sign Up'
          : 'Already have an account? Login'),
    );
  }

  Widget _buildBackButton() {
    return TextButton(
      onPressed: _toggleAuthForm,
      child: Text('Back to Welcome Screen'),
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
