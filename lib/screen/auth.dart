import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ulist/screen/home.dart';

class Auth extends StatefulWidget {
  final bool isNew;

  Auth({Key key, this.isNew = false}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _AuthState();
  }
}

class _AuthState extends State<Auth> {
  void signup() {}

  @override
  Widget build(BuildContext context) {
    String isNew;
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    Widget submitButton;

    if (widget.isNew) {
      isNew = "Sign Up";
      submitButton = SignUpButton(
          email: emailController, password: passwordController);
    } else {
      isNew = "Sign In";
      submitButton = SignInButton(
          email: emailController, password: passwordController);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Authentication"),
      ),
      body: Center(
        child: Column(
          children: [
            Text(isNew),
            TextField(
              decoration: InputDecoration(labelText: "Email"),
              controller: emailController,
            ),
            TextField(
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
              controller: passwordController,
            ),
            submitButton,
          ],
        ),
      ),
    );
  }
}

class SignUpButton extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController email;
  final TextEditingController password;
  SignUpButton({this.email, this.password});

  Future<FirebaseUser> _handleSignUp() async {
    final FirebaseUser user = await _auth.createUserWithEmailAndPassword(
        email: email.text, password: password.text);

    assert(user != null);
    assert(await user.getIdToken() != null);

    return user;
  }

  void submit(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Home(user: _handleSignUp()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () {
        submit(context);
      },
      child: Text("Sign Up"),
    );
  }
}

class SignInButton extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController email;
  final TextEditingController password;
  SignInButton({this.email, this.password});

  Future<FirebaseUser> _handleSignIn() async {
    final FirebaseUser user = await _auth.signInWithEmailAndPassword(
        email: email.text, password: password.text);

    assert(user != null);
    assert(await user.getIdToken() != null);

    return user;
  }

  void submit(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Home(user: _handleSignIn()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () {
        submit(context);
      },
      child: Text("Sign In"),
    );
  }
}
