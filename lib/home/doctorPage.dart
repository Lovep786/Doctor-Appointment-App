import 'package:docto/DiseaseInfo.dart';
import 'package:docto/appointment/confirmAppoint.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:docto/Info.dart';
import 'package:firebase_database/firebase_database.dart';
import '../edit/EditDoctorProfile.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import '../profile/DoctorProfile.dart';
import '../appointment/doctorAppointRequest.dart';


class doctorPage extends StatefulWidget {
  final String id;
  doctorPage(this.id);
  @override
  _doctorPageState createState() => _doctorPageState(id);
}

class _doctorPageState extends State<doctorPage> {
  String id;
  _doctorPageState(this.id);
  final FirebaseAuth _auth=FirebaseAuth.instance;
  DatabaseReference _databaseReference=FirebaseDatabase.instance.reference();
  FirebaseUser user;
  bool isSignedIn=false;
  Info _info;
  Info _infl;
  String _name='';
  String _photoUrl="empty";

  getProfile(id) async{
     _databaseReference.child('userData').child(id).onValue.listen((event){
       setState(() {
         _info=Info.fromSnapshot(event.snapshot);
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
  editProfile(id){
   Navigator.push(context, MaterialPageRoute(
       builder: (context){
          return EditDoctorProfile(id);
       }
     ));
  }
  seeProfile(id){
   Navigator.push(context, MaterialPageRoute(
       builder: (context){
          return DoctorProfile(id);
       }
     ));
  }
  signOut() async{
    _auth.signOut();
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
  deleteAccount() async{
    user.delete();
  }
  doctorRequest(id){
    Navigator.push(context, MaterialPageRoute(
       builder: (context){
          return DoctAppointRequest(id);
       }
     ));
  }
  confirmAppoint(id){
    Navigator.push(context, MaterialPageRoute(
       builder: (context){
          return ConfirmAppoint(id);
       }
     ));
  }
  fetchPat(String _id) async{
    _databaseReference.child('userData').child(_id).onValue.listen((event){
       setState(() {
         _infl=Info.fromSnapshot(event.snapshot);
       });
     });
     return _infl;
  }
  @override 
  void initState(){
    setState(() {
    super.initState();
    this.checkAuthentication();
    this.getUser();
    this.getProfile(id);
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return !isSignedIn?Center(child:CircularProgressIndicator(),):Scaffold(
      appBar: AppBar(
        title: Text('Doctor'),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("${_info.name.toUpperCase()}"),
              accountEmail: Text("${_info.email}"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.red,
                child: Text("${_info.name[0].toUpperCase()}",style: TextStyle(fontSize:30.0)),
              ),
            ),
            ListTile(
              title: Text("Profile"),
              trailing: Icon(Icons.account_box),
              onTap: ()=>seeProfile(id),
            ),
            ListTile(
              title: Text("Requests"),
              trailing: Icon(Icons.person_add),
              onTap: ()=>doctorRequest(id),
            ),
            ListTile(
              title: Text("My Appointments"),
              trailing: Icon(Icons.archive),
              onTap: ()=>confirmAppoint(id),
            ),
            
            ListTile(
              title: Text("Edit Profile"),
              trailing: Icon(Icons.edit),
              onTap: ()=> editProfile(id),
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
              child: Text("Information",style: TextStyle(fontSize:20.0,fontStyle: FontStyle.italic,fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.all(10.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: 1.0,
                    crossAxisSpacing: 3.0,
                    mainAxisSpacing: 3.0,
                  ),
                  itemCount: messageData.length,
                  itemBuilder: (context,i)=>Container(
                    
                    margin:EdgeInsets.all(8.0),
                    child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),  
                       
                        child: InkWell( 
                           child: Column(
                                     
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(top:20.0),
                                   ),
                                    ClipRRect(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(8.0),
                                        topRight: Radius.circular(8.0),
                                      ),
                                      child: Image(
                                        image: messageData[i].imageUrl,
                                        width: 320,
                                        height: 250,
                                        fit:BoxFit.fill  
                                      ),
                                    ),
                                    ListTile(
                                      title: Text(messageData[i].message,textAlign: TextAlign.center,),
                                    ),
                                ],
                           ),
                        ),
                    ),
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