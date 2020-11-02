import 'package:firebase_database/firebase_database.dart';


class Confirm{
  String _id;
  String _pid;
  String _did;
  String _date;
  String _time;
  String _pna;
  String _pph;
  String _dna;
  String _dph;

  Confirm(this._pid,this._did,this._date,this._time,this._pna,this._pph,this._dna,this._dph);
  Confirm.withId(this._id,this._pid,this._did,this._date,this._time,this._pna,this._pph,this._dna,this._dph);

  String get id=>this._id;
  String get pid=>this._pid;
  String get did=>this._did;
  String get date=>this._date;
  String get time=>this._time;
  String get pna=>this._pna;
  String get pph=>this._pph;
  String get dna=>this._dna;
  String get dph=>this._dph;


set pid(String pid){
    this._pid=pid;
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
  set pna(String pna){
    this._pna=pna;
  }
  set pph(String pph){
    this._pph=pph;
  }
  set dna(String dna){
    this._dna=dna;
  }
  set dph(String dph){
    this._dph=dph;
  }
  

  Confirm.fromSnapshot(DataSnapshot snapshot){
    this._id=snapshot.key;
    this._pid=snapshot.value['pid']; 
    this._did=snapshot.value['did'];
    this._date=snapshot.value['date'];
    this._time=snapshot.value['time'];
    this._pna=snapshot.value['pna'];
    this._pph=snapshot.value['pph'];
    this._dna=snapshot.value['dna'];
    this._dph=snapshot.value['dph'];
  }
   
   Map<String,dynamic> toJson(){
     return {
       "pid":_pid,
       "did":_did,
       "date":_date,
       "time":_time,
       "pna":_pna,
       "pph":_pph,
       "dna":_dna,
       "dph":_dph,
     };
   }
}