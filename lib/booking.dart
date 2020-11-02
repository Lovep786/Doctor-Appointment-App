import 'package:firebase_database/firebase_database.dart';


class Booking{
  String _id;
  String _pname;
  String _pid;
  String _did;
  String _date;
  String _time;
  String _photoU="empty";

  Booking(this._pid,this._pname,this._did,this._date,this._time,this._photoU);
  Booking.withId(this._id,this._pname,this._pid,this._did,this._date,this._time,this._photoU);

  String get id=>this._id;
  String get pid=>this._pid;
  String get pname=>this._pname;
  String get did=>this._did;
  String get date=>this._date;
  String get time=>this._time;
  String get photoU=>this._photoU;

set pid(String pid){
    this._pid=pid;
  }
  set pname(String pname){
    this._pname=pname;
  }
  set did(String did){
    this._did=did;
  }
  set date(String date){
    this._date=date;
  }
  set time(String time){
    this._time=time;
  }
  set photoU(String photoU){
    this._photoU=photoU;
  }

  Booking.fromSnapshot(DataSnapshot snapshot){
    this._id=snapshot.key;
    this._pid=snapshot.value['pid'];
    this._pname=snapshot.value['pname'];
    this._did=snapshot.value['did'];
    this._date=snapshot.value['date'];
    this._time=snapshot.value['time'];
    this._photoU=snapshot.value['photoU'];
  }
   
   Map<String,dynamic> toJson(){
     return {
       "pid":_pid,
       "pname":_pname,
       "did":_did,
       "date":_date,
       "time":_time,
       "photoU":_photoU,
     };
   }
}