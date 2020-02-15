import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'databaseHelper.dart';
class UserChat extends StatefulWidget{

  final String primaryId,secondaryId, name;

  UserChat(this.primaryId ,this.secondaryId, this.name);
  @override
  UserChatState createState() => UserChatState(primaryId, secondaryId, name);
}

class UserChatState extends State<UserChat>{

  double userMsg;

  String chatDocument;

  bool recMsg = false;

  int i = 0;

  List msg = [];

  String message;

  TextEditingController textControl = TextEditingController();

  final key = GlobalKey<FormState>();

  final String primaryId,secondaryId, name;
  UserChatState(this.primaryId, this.secondaryId, this.name);

  saveData(){
    if(key.currentState.validate()){
      key.currentState.save();
      textControl.clear();
      sendChats();
    }
  }

  @override
  void initState(){
    super.initState();
    oldChats();
  }

  oldChats() async{
    if(double.parse(primaryId) > double.parse(secondaryId)) {
      setState(() {
        chatDocument = primaryId + secondaryId;
      });
    }
    else{
      chatDocument = secondaryId + primaryId;
    }
    await Firestore.instance.collection("chats").document(chatDocument).get().then((data){
//      msg = data["msg"];
      i = int.parse(data["msgLength"]);
      print("INIT $i");
      setState((){
        recMsg = true;
      });
    }).catchError((e){
      print(e);
      print("ERROR");
    });
  }

  sendChats() async{
    DatabaseHelper db = DatabaseHelper(message, primaryId);
    if(double.parse(primaryId) > double.parse(secondaryId)){
      setState((){
        chatDocument = primaryId + secondaryId;
      });
      await Firestore.instance.collection("chats").document(chatDocument).get().then((data){

          msg = data["msg"];
          msg.add(db.toMap());
          updateData(chatDocument);

      }).catchError((e) {
        msg.add(db.toMap());
        sendData(chatDocument);
      });
    }
    else{
      setState(() {
        chatDocument = secondaryId + primaryId;
      });
      await Firestore.instance.collection("chats").document(chatDocument).get().then((data){

          msg = data["msg"];
          print("GETDATA");

          i = int.parse(data["msgLength"]);
          msg.add(db.toMap());
          updateData(chatDocument);

      }).catchError((e){
        print(e);
        print("PUSHDATA");
        msg.add(db.toMap());
        sendData(chatDocument);
      });
    }
  }

  sendData(doc) async{
    setState(() {
      i += 1;
    });
    await Firestore.instance.collection("chats").document(doc).setData({
      "msgLength": i.toString(),
      "msg" : msg,
    }).then((data){
      setState((){
        recMsg = true;
      });
    });
  }

  updateData(doc) async{
    setState(() {
      i += 1;
      print(i);
    });
    await Firestore.instance.collection("chats").document(doc).setData({
      "msgLength": i.toString(),
      "msg": msg,
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: Container(
//        height: 500,
        child: Column(
          children: <Widget>[
            Expanded(
              child: recMsg ? StreamBuilder(
                stream: Firestore.instance.collection("chats").document(chatDocument).snapshots(),
                builder: (context, snap){
                  DocumentSnapshot ds = snap.data;
                  return ListView.builder(
//                    reverse: true,
                    itemCount: i,
                    itemBuilder: (context, i){
                      if(snap.connectionState == ConnectionState.active){
                        userMsg = double.parse(ds.data["msg"][i]["uid"]);
                    //                      print("hh$i");
                        if(userMsg == double.parse(primaryId)){
                          return ListTile(
                          trailing: Text(ds.data["msg"][i]["msg"]),
                          );
                        }
                        else{
                          return ListTile(
                          leading: Text(ds.data["msg"][i]["msg"]),
                          );
                        }

                      }
                      else{
                        return CircularProgressIndicator();
                      }
                    }
                  );
                },
              ) : Center(child: Text("No Chats Yet")),

            ),
            Form(
              key: key,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: TextFormField(
                        controller: textControl,
                        decoration: InputDecoration(
                          labelText: "Type a message",
                        ),
                        validator: (input){
                          if(input.isEmpty){
                            return "Enter Message";
                          }
                          return null;
                        },
                        onSaved: (input) => message = input,
                      ),
                    ),
                  ),
                  Container(
                    child: RaisedButton(
                      child: Icon(Icons.send, color: Colors.blue,),
                      color: Colors.white,
                      onPressed: () {
                        saveData();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}