import 'package:flutter/material.dart';
import 'package:gvm_flutter/src/views/landing/landing_common.dart';

class LandingLayout extends StatelessWidget {
  final Widget child;
  final String? title;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final CrossAxisAlignment? crossAxisAlignment;
  final MainAxisAlignment? mainAxisAlignment;
  final EdgeInsetsGeometry contentPadding;

  const LandingLayout({
    super.key,
    required this.child,
    this.title,
    this.actions,
    this.showBackButton = true,
    this.onBackPressed,
    this.crossAxisAlignment,
    this.mainAxisAlignment,
    this.contentPadding = const EdgeInsets.all(16.0),
  });

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
          child: Column(
            children: [
              // Custom AppBar
              Container(
                height: kToolbarHeight,
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  children: [
                    if (showBackButton)
                      IconButton(
                        icon: Icon(Icons.arrow_back,
                            color: LandingCommon.textColor),
                        onPressed:
                            onBackPressed ?? () => Navigator.pop(context),
                      ),
                    if (title != null)
                      Expanded(
                        child: Text(
                          title!,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: LandingCommon.textColor,
                          ),
                        ),
                      ),
                    if (actions != null) ...actions!,
                  ],
                ),
              ),
              // Main content
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: contentPadding,
                      child: Column(
                        crossAxisAlignment:
                            crossAxisAlignment ?? CrossAxisAlignment.center,
                        mainAxisAlignment:
                            mainAxisAlignment ?? MainAxisAlignment.start,
                        children: [child],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
