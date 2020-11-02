import 'package:docto/appointment/patientAppoint.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:docto/Info.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import '../dlist.dart';
import '../edit/EditPatientProfile.dart';
import '../profile/PatientProfile.dart';
import 'package:docto/DoctorList.dart';

class patientPage extends StatefulWidget {
  final String id;
  patientPage(this.id);
  @override
  _patientPageState createState() => _patientPageState(id);
}

class _patientPageState extends State<patientPage> {
  String id;
  _patientPageState(this.id);
  final FirebaseAuth _auth=FirebaseAuth.instance;
  DatabaseReference _databaseReference=FirebaseDatabase.instance.reference();
  FirebaseUser user;
  bool isSignedIn=false;
  bool isLoading=false;
  Info _info;
 List<DiseaseList> numlist=[
   DiseaseList( Colors.red, "Dentist"),
   DiseaseList( Colors.green, "Heart"), 
   DiseaseList(Colors.blue, "Ear"),
   DiseaseList( Colors.yellow, "Eye"),
   DiseaseList(Colors.blue, "Legs"),
   DiseaseList( Colors.pink, "Neuro"),
   DiseaseList(Colors.yellow, "Diabities"),
   DiseaseList(Colors.red, "Hiv Aids"),
   DiseaseList(Colors.green, "Drugs"),
   DiseaseList(Colors.brown, "Ortho"),
  ];
  
  getProfile(id) async{
     _databaseReference.child('userData').child(id).onValue.listen((event){
       setState(() {
         _info=Info.fromSnapshot(event.snapshot);

         isLoading=false;
       });
     });
   } 

  checkAuthentication() async{
    _auth.onAuthStateChanged.listen((user){
       if(user == null){
         Navigator.pushReplacementNamed(context, "/Signin");
       }
    });
  }
  moveTodoctScreen(String disease){
    Navigator.push(context, MaterialPageRoute(
       builder: (context){
          return listDoctor(id,disease);
       }
     ));
  }
  deleteAccount() async{
    user.delete();
  }
confirmAppoint(id){
    Navigator.push(context, MaterialPageRoute(
       builder: (context){
          return PatientAppointConfirm(id);
       }
     ));
  }
  getUser() async{
    FirebaseUser firebaseUser=await _auth.currentUser();
    await firebaseUser?.reload();
    firebaseUser=await _auth.currentUser();
    if(firebaseUser != null){
      setState(() {
        this.user=firebaseUser;
        this.isSignedIn=true;
      });
    }
  }
  signOut() async{
    _auth.signOut();
  }
  editProfile(id){
   Navigator.push(context, MaterialPageRoute(
       builder: (context){
          return EditPatientProfile(id);
       }
     ));
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
                 this.deleteAccount();
               },
             ),
           ],
         );
       }
     );
   } 
  seeProfile(id){
   Navigator.push(context, MaterialPageRoute(
       builder: (context){
          return PatientProfile(id);
       }
     ));
  }
  @override 
  void initState(){
    super.initState();
    this.checkAuthentication(); 
    this.getUser();
    this.getProfile(id);
  }

  @override
  Widget build(BuildContext context) {
    return !isSignedIn?Center(child:CircularProgressIndicator(),):Scaffold(
      appBar: AppBar(
        title: Text('Patient'),  
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("${_info.name.toUpperCase()}"),
              accountEmail: Text("${_info.email}"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.orangeAccent,
                child: Text("${_info.name[0].toUpperCase()}",style: TextStyle(fontSize:30.0)),
              ),
            ),
            ListTile(
              title: Text("Profile"),
              trailing: Icon(Icons.account_box),
              onTap: ()=>seeProfile(id),
            ),
            ListTile(
              title: Text("Appointments"),
              trailing: Icon(Icons.archive),
              onTap:()=> confirmAppoint(id),
            ),
            ListTile(
              title: Text("Edit Profile"),
              trailing: Icon(Icons.edit),
              onTap: ()=>editProfile(id),
            ),
            Divider(),
            ListTile(
              title: Text("Sign Out"),
              trailing: Icon(Icons.all_out),
              onTap: ()=>signOut(),
            ),
            ListTile(
              title: Text("Delete Account"),
              trailing: Icon(Icons.delete),
              onTap: ()=>deleteContact(),
            )
          ],
        ),
      ),
     body: Container(
       child: Center(
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipPath(
                clipper: WaveClipperOne(),
                child: Container(
                  width:MediaQuery.of(context).size.width,
                  height: 150.0,
                  padding:EdgeInsets.only(bottom:50.0,left:15.0),
                  alignment:Alignment.bottomLeft,
                  color: Colors.orange,
                  child:Text("Hi, ${_info.name} \nWhat are you looking for?",style: TextStyle(fontSize:20.0,color:Colors.white,fontStyle: FontStyle.italic,fontWeight: FontWeight.bold))
                ),
              ),
            SizedBox(height:20.0),
            Container(
              padding: EdgeInsets.all(15.0),
              child: Text("Categories",style: TextStyle(fontSize:20.0,fontStyle: FontStyle.italic,fontWeight: FontWeight.bold)),
              ),
            Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.all(10.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2.0,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,

                  ),
                  itemCount: numlist.length,
                  itemBuilder: (context,i)=>SizedBox(
                    height: 20.0,
                    width: 100.0,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      color:numlist[i].buttonColor[400],
                      
                      child: Text(numlist[i].buttonText,style:TextStyle(fontSize: 25.0,color: Colors.white,fontStyle: FontStyle.italic)),
                      onPressed: (){
                        this.moveTodoctScreen(numlist[i].buttonText);
                      },
                    ),
                  ),
                ),
              )
            ],
         ),
       ),
     ),
    );
  }
}