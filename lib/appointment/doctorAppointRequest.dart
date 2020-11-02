import 'package:docto/booking.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import '../Info.dart';
import '../confirmBook.dart';


class DoctAppointRequest extends StatefulWidget {
  final String id;
  DoctAppointRequest(this.id);
  @override
  _DoctAppointRequestState createState() => _DoctAppointRequestState(id);
}

class _DoctAppointRequestState extends State<DoctAppointRequest> {
  String id; 
  _DoctAppointRequestState(this.id);

  DatabaseReference _databaseReference=FirebaseDatabase.instance.reference();

  String pid='';
  String did='';
  String date='';
  String time='';
  String pna='';
  String pph='empty';
  String dna='';
  String dph='empty';

  Info _info;
  getProfile(id) async{
     _databaseReference.child('userData').child(id).onValue.listen((event){
       setState(() {
         _info=Info.fromSnapshot(event.snapshot);
         dna=_info.name;
         dph=_info.photoUrl;
       });
     });
   }

  

 confirmRequest(String kid){
     showDialog(
       context: context,
       builder: (BuildContext context){
         return AlertDialog(
           title: Text("Confirm Request"),
           content: Text("Do you want book the appointment or not?"),
           actions: <Widget>[
             FlatButton(
               child: Text("Cancel"),
               onPressed: () async {
                 Navigator.of(context).pop();
                 await _databaseReference.child('booking').child(kid).remove();
                 this.initState();
               },
             ),
             FlatButton(
               child: Text("Accept"),
               onPressed: () async{
                 Navigator.of(context).pop();
                 createConfirm();
                 await _databaseReference.child('booking').child(kid).remove();
                 this.initState();  
               },
             ),
           ],
         );
       }
     );
   } 
   navigateToLastScreen(BuildContext context){
   Navigator.pop(context);
 }
 
 setConfirm(String _id) async{ 
    
    _databaseReference.child("booking").child(_id).onValue.listen((event){
      setState(() {
         Booking boki=Booking.fromSnapshot(event.snapshot);
         pid=boki.pid;
         did=boki.did;
         date=boki.date;
         time=boki.time;
         pna=boki.pname;
         pph=boki.photoU;
       });
     }); 
      
  }
  createConfirm() async{
    if(pid.isNotEmpty && did.isNotEmpty  && date.isNotEmpty && time.isNotEmpty)
    {
      Confirm conf=Confirm(this.pid,this.did,this.date,this.time,this.pna,this.pph,this.dna,this.dph);
      await _databaseReference.child("confirm").push().set(conf.toJson());
    }
  }

  @override
  void initState(){
    super.initState();
    this.getProfile(id);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Requests'),
      ),
      body: Container(
        child: FirebaseAnimatedList(
          query: _databaseReference.child("booking").orderByChild("did").equalTo(id),
          itemBuilder: (BuildContext context, DataSnapshot snapshot,Animation<double> animation,int index)
          { 
               return GestureDetector(
              onTap: (){
                confirmRequest(snapshot.key);
                setConfirm(snapshot.key);
              },
              child:Card(
                
                elevation: 2.0,
                child: Container(
                  margin: EdgeInsets.all(10.0),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 50.0,
                        height: 50.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle, 
                          image:DecorationImage(
                          fit: BoxFit.cover,
                          image:snapshot.value['photoU']=="empty"?AssetImage("images/logo.png"):NetworkImage(snapshot.value['photoU'])
                      )
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("${snapshot.value['pname']}",style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),),
                            Text("Appointment Date : ${snapshot.value['date']}",style: TextStyle(fontSize:15.0)),
                            Text("Appointment Time : ${snapshot.value['time']}",style: TextStyle(fontSize:15.0)),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              
            );
            }
           
        ),
      ),
    );
  }
}