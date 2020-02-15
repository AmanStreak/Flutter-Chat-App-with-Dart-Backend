class DatabaseHelper{
  String uid;
  String msg;

  DatabaseHelper(this.msg, this.uid);

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = Map<String, dynamic>();
    map["msg"] = this.msg;
    map["uid"] = this.uid;

    return map;
  }
}