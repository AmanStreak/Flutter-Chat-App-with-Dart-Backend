import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/userChat.dart';
class UserFriends extends StatefulWidget {

  final String primaryId;

  UserFriends(this.primaryId);
  @override
  _UserFriendsState createState() => _UserFriendsState(primaryId);
}

class _UserFriendsState extends State<UserFriends> {

  final String primaryId;
  String secondaryId, name;

  _UserFriendsState(this.primaryId);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("CHATS"),
        ),
        body: Container(
//          height: 400,
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
//                height: 800,
                  child: StreamBuilder(
                    stream: Firestore.instance.collection("users").snapshots(),
                    builder: (context, snap){
                      if(snap.connectionState == ConnectionState.active){
                        return ListView.builder(
                            itemCount: snap.data.documents.length,
                            itemBuilder: (context, i){
                              DocumentSnapshot ds = snap.data.documents[i];
                              print("pri $primaryId");
                              print("second ${ds["userId"]}");
                              if(primaryId != ds["userId"]){

                                return ListTile(
                                  onTap: (){
                                    secondaryId = ds["userId"];
                                    name = ds["name"];
                                    Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => UserChat(primaryId,secondaryId, name)
                                    ));
                                  },
                                  title: Text(ds.data["name"]),
//                              title: snap.data.documents.data["email"],
//                              subtitle: Text("${snap.data.documents[i].documentId}"),

                                );
                              }
                              return Text("");
                            }
                        );
                      }
                      return Text("A");
                    },
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
