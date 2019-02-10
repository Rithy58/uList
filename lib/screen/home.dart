import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Home extends StatefulWidget {
  final Future<FirebaseUser> user;

  Home({Key key, this.user}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Center(
          child: Column(
        children: <Widget>[
          FutureBuilder<FirebaseUser>(
              future: widget.user,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text("Hello, " + snapshot.data.uid);
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return CircularProgressIndicator();
              }),
          FutureBuilder<FirebaseUser>(
              future: widget.user,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return RaisedButton(
                    child: Text("Delete"),
                    onPressed: () {
                      snapshot.data.delete().then((_) {
                        Navigator.pop(context);
                      });
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return Container();
              }),
        ],
      )),
    );
  }
}
