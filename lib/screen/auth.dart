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

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text("Authentication"),
      ),
      body: Center(
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: "Email"),
              controller: emailController,
            ),
            TextField(
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
              controller: passwordController,
            ),
            AuthButton(email: emailController, password: passwordController, isNew: widget.isNew,),
          ],
        ),
      ),
    );
  }
}

class AuthButton extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController email;
  final TextEditingController password;
  final bool isNew;
  AuthButton({this.email, this.password, this.isNew = false});

  Future<FirebaseUser> _handleAuth() async {
    final FirebaseUser user = await (isNew ? _auth.createUserWithEmailAndPassword(
        email: email.text, password: password.text) : _auth.signInWithEmailAndPassword(
        email: email.text, password: password.text));

    assert(user != null);
    assert(await user.getIdToken() != null);

    return user;
  }

  void submit(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Home(user: _handleAuth()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String submitText = isNew ? "Sign Up" : "Sign In";

    return RaisedButton(
      onPressed: () {
        submit(context);
      },
      child: Text(submitText),
    );
  }
}
