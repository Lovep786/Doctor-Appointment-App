import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Info.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import '../edit/EditPatientProfile.dart';

class PatientProfile extends StatefulWidget {
  final String id;
  PatientProfile(this.id);
  @override
  _PatientProfileState createState() => _PatientProfileState(id);
}
class _PatientProfileState extends State<PatientProfile> {
  String id;
  _PatientProfileState(this.id);
   DatabaseReference _databaseReference=FirebaseDatabase.instance.reference();
   Info info;
   bool isLoading=false;
    String _name='';
    String _phone='';
    String _email='';
    String _address='';
    String _profession='';
    String _speciality='';
    String _photoUrl="empty";

   getContact(id) async{
     _databaseReference.child('userData').child(id).onValue.listen((event){
       setState(() {
         info=Info.fromSnapshot(event.snapshot);
         _name=info.name;
        _phone=info.phone;
        _email=info.email;
        _address=info.address;
        _profession=info.profession;
        _speciality=info.speciality;
        _photoUrl=info.photoUrl;
         isLoading=true;
       });
     });
   } 
   deleteContact(){
     showDialog(
       context: context,
       builder: (BuildContext context){
         return AlertDialog(
           title: Text("Delete"),
           content: Text("Delete Contact?"),
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
                 await _databaseReference.child('userData').child(id).remove();
                 this.navigateToLastScreen(context);
                 
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
   editProfile(id){
   Navigator.push(context, MaterialPageRoute(
       builder: (context){
          return EditPatientProfile(id);
       }
     ));
  }
   @override 
   void initState(){
     super.initState();
     this.getContact(id);
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile')
        
      ),
      body: Container(
        child: !isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
              :ListView(
                children: <Widget>[
                  ClipPath(
                clipper: WaveClipperOne(),
                child: Container(
                  width:MediaQuery.of(context).size.width,
                  height: 250.0,
                  padding:EdgeInsets.only(bottom:50.0,left:15.0),
                  alignment:Alignment.bottomCenter,
                  color: Colors.cyan[200],
                  child:Container(
                                width: 150.0,
                                height: 150.0,
                                decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: new DecorationImage(
                                      fit: BoxFit.cover,
                                      image: _photoUrl == "empty"
                                          ? AssetImage("images/logo.png")
                                          : NetworkImage(_photoUrl),
                                    ),
                          ),
                         
                    ),
                    
                  
                ),
              ),
            SizedBox(height:20.0),
            Card(
                    elevation: 2.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Center(
                      child:Container(
                        margin: EdgeInsets.all(20.0),
                        
                        width: double.maxFinite,
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.perm_identity,color: Colors.teal),
                            Container(
                              width: 10.0,
                            ),
                            Text(
                             _name,
                             
                              style: TextStyle(color: Colors.red,fontSize: 20.0,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),
                            ),
                          ],
                        ))),
                  ),
                  Card(
                    elevation: 2.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Center(
                      child:Container(
                        margin: EdgeInsets.all(20.0),
                        
                        width: double.maxFinite,
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.phone,color: Colors.teal),
                            Container(
                              width: 10.0,
                            ),
                            Text(
                             _phone,
                              style: TextStyle(color: Colors.red,fontSize: 20.0,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),
                            ),
                          ],
                        ))),
                  ),
                  Card(
                    elevation: 2.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Center(
                      child:Container(
                        margin: EdgeInsets.all(20.0),
                        
                        width: double.maxFinite,
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.email,color: Colors.teal),
                            Container(
                              width: 10.0,
                            ),
                            Text(
                             _email,
                              style: TextStyle(color: Colors.red,fontSize: 20.0,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),
                            ),
                          ],
                        ))),
                  ),
                  Card(
                    elevation: 2.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Center(
                      child:Container(
                        margin: EdgeInsets.all(20.0),
                        
                        width: double.maxFinite,
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.home,color: Colors.teal),
                            Container(
                              width: 10.0,
                            ),
                            Text(
                             _address,
                              style: TextStyle(color: Colors.red,fontSize: 20.0,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),
                            ),
                          ],
                        ))),
                  ),   
                ],
                )
      ),
    );
  }
}