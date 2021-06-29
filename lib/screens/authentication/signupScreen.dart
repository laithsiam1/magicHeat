import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:magic_heat/services/authentication.dart';
import 'package:magic_heat/utilities/showCustomDialog.dart';

class SignupScreen extends StatefulWidget {
  static const String routePath = '/signup';

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  GlobalKey<FormState> authForm;

  FocusNode usernameNode;
  FocusNode passwordNode;

  String username;
  String password;

  bool isSubmiting;

  @override
  void initState() {
    super.initState();

    authForm = GlobalKey<FormState>();

    usernameNode = FocusNode();
    passwordNode = FocusNode();

    isSubmiting = false;
  }

  void submitForm() async {
    if (isSubmiting) return;

    FocusScope.of(context).unfocus();

    bool isValid = authForm.currentState.validate();

    if (isValid) {
      if (mounted)
        setState(() {
          isSubmiting = true;
        });

      authForm.currentState.save();

      dynamic result =
          await Authentication.signInWithEmailAndPassword(username, password);

      if (mounted)
        setState(() {
          isSubmiting = false;
        });

      if (result != null) {
        showAuthDialog(result);
        return;
      }
    }
  }

  void showAuthDialog(dynamic error) {
    showCustomDialog(
      context,
      title: 'Something went wrong  😯',
      content: Text(error is FirebaseAuthException
          ? '${error.message}'
          : '${error.toString()}'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            height: size.height,
            width: size.width,
            child: Image.asset(
              'assets/images/appBackground.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 7,
                  sigmaY: 7,
                ),
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: kToolbarHeight),
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Magic Heat',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.balooTammudu(
                      fontSize: 50,
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      color: Colors.white.withOpacity(0.7),
                      child: Container(
                        width: size.width * 0.8,
                        constraints: BoxConstraints(maxWidth: 500),
                        padding: EdgeInsets.all(8.0),
                        child: Form(
                          key: authForm,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                decoration: InputDecoration(
                                  hintText: 'username',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 0,
                                  ),
                                ),
                                focusNode: usernameNode,
                                keyboardType: TextInputType.emailAddress,
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context)
                                      .requestFocus(passwordNode);
                                },
                                onSaved: (String value) {
                                  username = value;
                                },
                                validator: (String value) {
                                  if (value.trim().isEmpty)
                                    return 'please enter your username!';

                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                  hintText: 'password',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 0,
                                  ),
                                ),
                                focusNode: passwordNode,
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: true,
                                onFieldSubmitted: (_) => submitForm(),
                                onSaved: (String value) {
                                  password = value;
                                },
                                validator: (String value) {
                                  if (value.trim().isEmpty)
                                    return 'passwords can not be empty!';

                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton(
                                  onPressed: () => submitForm(),
                                  style: ElevatedButton.styleFrom(
                                    fixedSize: Size.fromWidth(100),
                                  ),
                                  child: Text('Sign In'),
                                ),
                              ),
                              if (isSubmiting) ...[
                                SizedBox(
                                  height: 8,
                                ),
                                CircularProgressIndicator(),
                              ]
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
