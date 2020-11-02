import 'package:docto/home/doctorPage.dart';
import 'package:docto/home/patientPage.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:docto/Info.dart';


class SigninPage extends StatefulWidget {
  @override
  _SigninPageState createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final FirebaseAuth _auth=FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey=GlobalKey<FormState>();
  DatabaseReference _databaseReference=FirebaseDatabase.instance.reference();
  String _email='',_password='';
  Info _info;
  bool isgoing=false;
  List<Info> infoData=[];
  bool docoperation=false;
  bool patoperation=false;
  var  specialkey;


  checkAuthentication() async{
    _auth.onAuthStateChanged.listen((user) async {
       if(user != null){
         isgoing=true;
         FirebaseUser firebaseUser=await _auth.currentUser();
         await firebaseUser?.reload();
         firebaseUser=await _auth.currentUser();

         _databaseReference.child("userData").once().then((DataSnapshot snapshot){
           var keys=snapshot.value.keys;
           var data=snapshot.value;
           
             for(var key in keys){
                if(data[key]["email"]==firebaseUser.email){
                  if(data[key]["profession"]=="Doctor"){
                  specialkey=key;
                  travelDoctor(specialkey);
                }
                  else{
                     specialkey=key;
                     travelPatient(specialkey);
                  }
                }    
              }
         });

       }
    });
  }
travelDoctor(var sp){
   Navigator.push(context,MaterialPageRoute(builder: (context) => doctorPage(sp)));
}
travelPatient(var sp){
   Navigator.push(context,MaterialPageRoute(builder: (context) => patientPage(sp)));
}
             
             
  navigateToSignupScreen(){
    Navigator.pushReplacementNamed(context, "/Signup");
  }
  @override 
  void initState(){
    super.initState();
    this.checkAuthentication();
  }

  void signin() async{
    if(_formKey.currentState.validate()){
      _formKey.currentState.save();
      try {
      FirebaseUser user=(await _auth.signInWithEmailAndPassword(email: _email,password: _password)) as FirebaseUser;
    } catch (e) {
      showError(e.message);
    }
    }
    
  }
  
  showError(String errorMessage){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
           title: Text('Error'),
           content: Text(errorMessage),
           actions: <Widget>[
             FlatButton(
               child: Text('OK'
               ),
               onPressed: (){
                 Navigator.of(context).pop();
               },
             )
           ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: isgoing?Center(child: CircularProgressIndicator(),) :Container(
        child: Center(
          child: ListView(
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(10.0, 50.0, 10.0, 20.0),
                child: Image(
                  image: AssetImage("images/logo.png"),
                  width: 200.0,
                  height: 200.0,
                ),
              ),
              Container(
                padding: EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 20.0),
                        child: TextFormField(
                          validator:  (input){
                            if(input.isEmpty)
                            {
                              return 'Provide an email';
                            }
                          },
                          decoration: InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            )
                          ),
                          onSaved: (input)=>_email=input,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 20.0),
                        child: TextFormField(
                          validator:  (input){
                            if(input.length<6)
                            {
                              return 'Provide password should be six char';
                            }
                          },
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            )
                          ),
                          onSaved: (input)=>_password=input,
                          obscureText: true,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 40, 0, 40),
                        child: RaisedButton(
                          padding: EdgeInsets.fromLTRB(60.0, 20.0, 60.0, 20.0),
                          color: Colors.red,
                          splashColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          onPressed: signin,
                          child: Text('Sign In',style:TextStyle(color:Colors.white,fontSize:20.0)),
                        ),
                      ),
                      GestureDetector(
                        onTap: navigateToSignupScreen,
                        child: Text('Create an Account?',textAlign:TextAlign.center,style:TextStyle(fontSize: 16.0,color: Colors.red)),
                      )
                    ],
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