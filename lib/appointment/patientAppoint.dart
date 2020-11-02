import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/services.dart';
import '../Info.dart';
class PatientAppointConfirm extends StatefulWidget {
  final String id;
  PatientAppointConfirm(this.id);
  @override
  _PatientAppointConfirmState createState() => _PatientAppointConfirmState(id);
}

class _PatientAppointConfirmState extends State<PatientAppointConfirm> {
  DatabaseReference _databaseReference=FirebaseDatabase.instance.reference();
  String id;
  String name='';
  String photoUrl="empty";
  Info _infl;
  _PatientAppointConfirmState(this.id);

  deleteContact(String rid){
     showDialog(
       context: context,
       builder: (BuildContext context){
         return AlertDialog(
           title: Text("Delete"),
           content: Text("Delete Appointment ?"),
           actions: <Widget>[
             FlatButton(
               child: Text("Cancel"),
               onPressed: (){
                 Navigator.of(context).pop();
               },
             ),
             FlatButton(
               child: Text("Delete"),
               onPressed: () async{
                 Navigator.of(context).pop();
                 await _databaseReference.child('confirm').child(rid).remove();
                 initState();
               },
             ),
           ],
         );
       }
     );
   } 
  @override
  void initState(){
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirm Appointment'),
      ),
      body: Container(
        child: FirebaseAnimatedList(
          query: _databaseReference.child('confirm').orderByChild("pid").equalTo(id) ,
          
          itemBuilder: (BuildContext context, DataSnapshot snapshot,Animation<double> animation,int index)  {
           
               
                        return GestureDetector(
                          
                          onTap: ()=>deleteContact(snapshot.key),
                          child :Card(
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
                                      image:snapshot.value['dph']=="empty"?AssetImage("images/logo.png"):NetworkImage(snapshot.value['dph'])
                      )
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(snapshot.value['dna'],style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),),
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