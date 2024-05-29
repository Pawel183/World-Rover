import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  var _isLogin = true;

  void _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      if (_isLogin) {
        final userCredentials = await _firebase.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        print(userCredentials);
      } else {
        final userCredentials = await _firebase.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        print(userCredentials);
      }
    } on FirebaseAuthException catch (err) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(err.message ?? 'Authentication failed.'),
        ),
      );
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: Center(
        child: Column(
          children: [
            Container(
              height: 300,
              margin: const EdgeInsets.all(30),
              child: Image.asset(
                'assets/earth.png',
              ),
            ),
            Card(
              margin: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!_isLogin)
                          TextFormField(
                            controller: _usernameController,
                            autocorrect: false,
                            decoration: const InputDecoration(
                              label: Text("Username"),
                            ),
                            enableSuggestions: false,
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  value.trim().length < 4) {
                                return "Please enter at least 4 characters.";
                              }
                              return null;
                            },
                          ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _emailController,
                          autocorrect: false,
                          textCapitalization: TextCapitalization.none,
                          decoration: const InputDecoration(
                            label: Text("Email"),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty ||
                                value.trim().length < 6 ||
                                !value.contains("@")) {
                              return "Please enter a valid email address.";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _passwordController,
                          decoration: const InputDecoration(
                            labelText: "Password",
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.trim().length < 6) {
                              return "Password must be at least 6 characters long.";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: _submit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                              ),
                              child: Text(
                                _isLogin ? "Sign in" : "Sign up",
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _usernameController.clear();
                                  _emailController.clear();
                                  _passwordController.clear();
                                  _formKey.currentState?.reset();
                                  _isLogin = !_isLogin;
                                });
                              },
                              child: Text(
                                _isLogin
                                    ? "Create an account"
                                    : "I already have an account",
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
