import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/userFriends.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'userFriends.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget{

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: Man(),
    );
  }
}

class Man extends StatefulWidget {
  @override
  _ManState createState() => _ManState();
}

class _ManState extends State<Man> {

  GoogleSignIn googleSignIn = GoogleSignIn();

  var data;

  @override
  void initState(){
    super.initState();
    googleSignIn.signOut();
  }

//  final _auth = FirebaseAuth.instance;
//  final googleSignIn = GoogleSignIn();

  userGoogleSignIn() async{



    try {
      await googleSignIn.signIn().then((data){
        this.data = data;
        print(data.email);
        print(data.runtimeType);
//          assert();
        if(data.email != null){
          userData(data.id, data.displayName, data.email);


          availableUser(data.id);
        }
        print(data);
      });
    } catch (error) {
      print(error);
    }

//    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
//    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
//
//    final AuthCredential credential = GoogleAuthProvider.getCredential(
//      accessToken: googleSignInAuthentication.accessToken,
//      idToken: googleSignInAuthentication.idToken,
//    );
//
//    final AuthResult authResult = await _auth.signInWithCredential(credential);
//    final FirebaseUser user = authResult.user;
//
//    assert(!user.isAnonymous);
//
//    assert(await user.getIdToken() != null);
//
//    final FirebaseUser currentUser = await _auth.currentUser();
//    assert(user.uid == currentUser.uid);
//
//    return 'SignInWithGoogle succeeded: $user';
  }

  userData(id, name,email) async{
    await Firestore.instance.collection("users").document(id).setData({
      "userId" : id,
      "name": name,
      "emailId" : email,
    });
  }

  availableUser(id) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserFriends(id)));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
//          color: Colors.black12,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 10,
              child: GestureDetector(

                onTap: () {
                  userGoogleSignIn();
//                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserFriends(data.id)));

                },
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 40.0),
                    ),
                    Image.asset("assets/google.png", height: 50, width: 50,),
                    Text("SIGN IN WITH GOOGLE"),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
