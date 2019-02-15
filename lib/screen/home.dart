import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  final Future<FirebaseUser> user;

  Home({Key key, this.user}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  int counter = 0;

  void _addItem() async {
    FirebaseUser user = await widget.user;
    Firestore.instance
        .collection('users')
        .document(user.uid)
        .collection('todos')
        .document()
        .setData({
      'created': Timestamp.now(),
      'done': false,
      'text': 'Test $counter',
    }).then((onValue) {
      counter++;
    });
  }

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
          RaisedButton(
            child: Text("Add"),
            onPressed: _addItem,
          ),
          FutureBuilder<FirebaseUser>(
              future: widget.user,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance
                        .collection('users')
                        .document(snapshot.data.uid)
                        .collection('todos')
                        .orderBy('created', descending: true)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError)
                        return new Text('Error: ${snapshot.error}');
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return new Text('Loading...');
                        default:
                          return new Flexible(
                              child: ListView(
                            children: snapshot.data.documents
                                .map((DocumentSnapshot document) {
                              return new ListTile(
                                title: new Text(document['text']),
                                subtitle:
                                    new Text(document['created'].toString()),
                              );
                            }).toList(),
                          ));
                      }
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
