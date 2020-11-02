import 'package:docto/DoctorView.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

class listDoctor extends StatefulWidget {
   String disease;
   final String pid;
  listDoctor(this.pid,this.disease);
  @override
  _listDoctorState createState() => _listDoctorState(pid,disease);
}

class _listDoctorState extends State<listDoctor> {
  DatabaseReference _databaseReference=FirebaseDatabase.instance.reference();
  String disease;
  String pid;
  _listDoctorState(this.pid,this.disease);
  
  navigateToViewDoct(String pid,String key){
    Navigator.push(context, MaterialPageRoute(
       builder: (context){
          return DoctorView(pid,key);
       }
     ));
  }
  @override
  void initState(){
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor List'),
      ),
      body: Container(
        child: FirebaseAnimatedList(
          query: _databaseReference.child('userData').orderByChild("speciality").equalTo(disease),
          itemBuilder: (BuildContext context, DataSnapshot snapshot,Animation<double> animation,int index){
            print(index);
            return GestureDetector(
              onTap: (){
                this.navigateToViewDoct(pid,snapshot.key); //todo snapshot.key
              },
              child: Card(
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
                          image:snapshot.value['photoUrl']=="empty"?AssetImage("images/logo.png"):NetworkImage(snapshot.value['photoUrl'])
                      )
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("${snapshot.value['name']}",style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),),
                            Text("${snapshot.value['speciality']} specialist, ${snapshot.value['address']}",style: TextStyle(fontSize:15.0)),
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