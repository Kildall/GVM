import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LandingCommon {
  static final Color backgroundColor = Color(0xFFEEEAFF);
  static final Color accentColor = Color(0xFFB1A6FF);
  static final Color textColor = Color(0xFF1E1A33);

  static void showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  static Widget buildTextField(
    String label,
    TextEditingController controller,
    bool isPassword,
    BuildContext context,
  ) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: label,
        labelStyle: TextStyle(color: textColor),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: accentColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: accentColor, width: 2),
        ),
      ),
      style: TextStyle(color: textColor),
      obscureText: isPassword,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return AppLocalizations.of(context).fieldRequired;
        }
        if (label == 'Email' &&
            !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return AppLocalizations.of(context).invalidEmail;
        }
        if (label == 'Confirm Password' && value != controller.text) {
          return AppLocalizations.of(context).passwordsDoNotMatch;
        }
        return null;
      },
    );
  }

  static buildButton(String text, VoidCallback? onPressed, bool isLoading) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: accentColor,
        foregroundColor: textColor,
        minimumSize: Size(250, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
      child: isLoading
          ? CircularProgressIndicator(color: Colors.white)
          : Text(text),
    );
  }
}
