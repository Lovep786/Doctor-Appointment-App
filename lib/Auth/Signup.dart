import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:docto/Info.dart';
import 'package:docto/home/doctorPage.dart';
import 'package:docto/home/patientPage.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';


class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
    final FirebaseAuth _auth=FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey=GlobalKey<FormState>();
  DatabaseReference _databaseReference=FirebaseDatabase.instance.reference();
  Info _info;
  List<String> _accountType=['Doctor','Patient'];
  List<String> _accountTypevalue=['None','Eye','Heart','Dentist','Ear','Ortho','Diabitics','Neuro','Hiv Aids','Drugs','Legs'];
  String _name='',_email='',_address='',_password='',_profession, _phone='',_speciality,_photoUrl="empty";

  checkAuthentication(context) async{
    _auth.onAuthStateChanged.listen((user) async {
       if(user != null){
         FirebaseUser firebaseUser=await _auth.currentUser();
         await firebaseUser?.reload();
         firebaseUser=await _auth.currentUser();

         _databaseReference.child('userData').once().then((DataSnapshot snapshot){
           var keys=snapshot.value.keys;
           var data=snapshot.value;
           var specialkey;
           bool docoperation=false;
           bool patoperation=false;
           for(var key in keys){
             if(firebaseUser != null && firebaseUser.email==data[key]['email'] && data[key]['profession']=='Doctor'){
               specialkey=key;
               docoperation=true;
             }
             if(firebaseUser != null && firebaseUser.email==data[key]['email'] && data[key]['profession']=='Patient'){
               specialkey=key;
               patoperation=true;
             }
           }
             if(docoperation==true){
               Navigator.push(context,MaterialPageRoute(builder: (context) => doctorPage(specialkey)));
             }
             if(patoperation==true){
               Navigator.push(context,MaterialPageRoute(builder: (context) => patientPage(specialkey)));
             }
         });
       }
    });
  }
  
  Future pickImage() async{
    File file=await ImagePicker.pickImage(source: ImageSource.gallery,maxHeight: 200.0,maxWidth: 200.0);
    String filename=basename(file.path);
    uploadImage(file,filename);
  }

  void uploadImage(File file,String filename) async{
    StorageReference storageReference=FirebaseStorage.instance.ref().child(filename);
    storageReference.putFile(file).onComplete.then((firebaseFile) async{
      var downloadUrl=await firebaseFile.ref.getDownloadURL();
      setState(() {
        _photoUrl=downloadUrl;
      });
    });
  }

  navigateToSigninScreen(context){
    Navigator.pushReplacementNamed(context, "/Signin");
  }

  @override 
  void initState(){
    super.initState();
    this.checkAuthentication(context);
    }
      
    signup() async{
        if(_formKey.currentState.validate()){
          _formKey.currentState.save();
          try {
             if(_name.isNotEmpty && _profession.isNotEmpty && _speciality.isNotEmpty && _phone.isNotEmpty && _email.isNotEmpty && _address.isNotEmpty && _password.isNotEmpty && _photoUrl.isNotEmpty)
             {
             Info info=Info(this._name, this._phone,this._speciality, this._email,this._profession, this._address,this._photoUrl);
             await _databaseReference.child("userData").push().set(info.toJson());
             }
            FirebaseUser user=(await _auth.createUserWithEmailAndPassword(email: _email,password: _password)) as FirebaseUser;
            if(user != null){
              UserUpdateInfo updateuser=UserUpdateInfo();
              user.updateProfile(updateuser);
            }
          } catch (e) {
            showError(e.message,context);
          }
        }
    
      }
      showError(String errorMessage,context){
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
          
          body: Container(
            child: Center(
              child: ListView(
                children: <Widget>[
                  Container(
              margin: EdgeInsets.only(top:20.0),
              child: GestureDetector(
                onTap: (){
                  this.pickImage();
                },
                child: Center(
                  child: Container(
                    width: 100.0,
                    height: 100.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: _photoUrl=="empty"?AssetImage("images/logo.png"):NetworkImage(_photoUrl),

                      )
                    ),
                  ),
                ),
              ),
            ),
                  
                  Container(
                    padding: EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.account_box,
                      color:Colors.green,
                      
                    ),
                    SizedBox(width:20.0),
                    DropdownButton(
                      items: _accountType.map((value)=>DropdownMenuItem(
                        child:Text(
                          value,
                          ),
                        value: value,
                      )).toList(), 
                      onChanged: (selectedAccountType){
                        setState(() {
                          _profession=selectedAccountType;
                        });
                      },
                      value: _profession,
                      isExpanded: false,
                      hint: Text('Profession'),
                    )
                  ],
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.assistant,
                      color:Colors.green,
                      
                    ),
                    SizedBox(width:20.0),
                    DropdownButton(
                      items: _accountTypevalue.map((value)=>DropdownMenuItem(
                        child:Text(
                          value,
                          ),
                        value: value,
                      )).toList(), 
                      onChanged: (selectedAccountType){
                        setState(() {
                          _speciality=selectedAccountType;
                        });
                      },
                      value: _speciality,
                      isExpanded: false,
                      hint: Text('Specilaity'),
                    )
                  ],
              ),
                          Container(
                            padding: EdgeInsets.only(top: 20.0),
                            child: TextFormField(
                              validator:  (input){
                                if(input.isEmpty)
                                {
                                  return 'Provide a name';
                                }
                              },
                              decoration: InputDecoration(
                                labelText: 'Name',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                )
                              ),
                              onSaved: (input)=>_name=input,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 20.0),
                            child: TextFormField(
                              validator:  (input){
                                if(input.length<10)
                                {
                                  return 'Enter a phone number';
                                }
                              },
                              decoration: InputDecoration(
                                labelText: 'Mobile Number',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                )
                              ),
                              onSaved: (input)=>_phone=input,
                            ),
                          ),
                          
                          Container(
                            padding: EdgeInsets.only(top: 20.0),
                            child: TextFormField(
                              validator:  (input){
                                if(input.isEmpty)
                                {
                                  return 'Enter the address';
                                }
                              },
                              decoration: InputDecoration(
                                labelText: 'Address',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                )
                              ),
                              onSaved: (input)=>_address=input,
                            ),
                          ),
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
                            padding: EdgeInsets.fromLTRB(0, 30, 0, 30),
                            child: RaisedButton(
                              padding: EdgeInsets.fromLTRB(60.0, 20.0, 60.0, 20.0),
                              color: Colors.red,
                              splashColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              onPressed: signup,
                              child: Text('Sign Up',style:TextStyle(color:Colors.white,fontSize:20.0)),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){this.navigateToSigninScreen(context);},
                            child: Text('Go to Sign In Page?',textAlign:TextAlign.center,style:TextStyle(fontSize: 16.0,color: Colors.red)),
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
