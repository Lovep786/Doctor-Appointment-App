import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:docto/Info.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path/path.dart';


class EditPatientProfile extends StatefulWidget {
  String id;
  EditPatientProfile(this.id);
  @override
  _EditPatientProfileState createState() => _EditPatientProfileState(id);
}

class _EditPatientProfileState extends State<EditPatientProfile> {
  String id;
  _EditPatientProfileState(this.id);
  String _name='';
  String _phone='';
  String _email='';
  String _address='';
  String _profession='';
  String _speciality='';
  String _photoUrl="empty";

  TextEditingController _naController=TextEditingController();
  TextEditingController _poController=TextEditingController();
  TextEditingController _emController=TextEditingController();
  TextEditingController _adController=TextEditingController();
  bool isLoading=true;

  DatabaseReference _databaseReference=FirebaseDatabase.instance.reference();
  getContact(id) async{
    Info info;
    _databaseReference.child("userData").child(id).onValue.listen((event) {

      info=Info.fromSnapshot(event.snapshot);
      _naController.text=info.name;
      _poController.text=info.phone;
      _emController.text=info.email;
      _adController.text=info.address;
      
      setState(() {
        _name=info.name;
        _phone=info.phone;
        _email=info.email;
        _address=info.address;
        _profession=info.profession;
        _speciality=info.speciality;
        _photoUrl=info.photoUrl;
        isLoading=false;
      });
    }
    );
  }

  updateContact(BuildContext context) async{
    if(_name.isNotEmpty && _profession.isNotEmpty && _speciality.isNotEmpty && _phone.isNotEmpty && _email.isNotEmpty && _address.isNotEmpty && _photoUrl.isNotEmpty)
             {
             Info info=Info.withId(this.id,this._name, this._phone,this._speciality, this._email,this._profession, this._address,this._photoUrl);
             await _databaseReference.child('userData').child(id).set(info.toJson());
             navigateToLastScreen(context);
             }
    else{
      showDialog(
       context: context,
       builder: (BuildContext context){
         return AlertDialog(
           title: Text('Field required'),
           content: Text('All fields are required'),
           actions: <Widget>[
             FlatButton(
               child: Text('close'),
               onPressed: (){
                 Navigator.of(context).pop();
               },
             )
           ],
         );
       }
      );
    }
  }
  navigateToLastScreen(BuildContext context){
   Navigator.pop(context);
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
  @override 
  void initState(){
    super.initState();
    this.getContact(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
      ),
      body: Container(
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: EdgeInsets.all(20.0),
                child: ListView(
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(top: 20.0),
                        child: GestureDetector(
                          onTap: () {
                            this.pickImage();
                          },
                          child: Center(
                            child: Container(
                                width: 150.0,
                                height: 150.0,
                                decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: new DecorationImage(
                                      fit: BoxFit.cover,
                                      image: _photoUrl == "empty"
                                          ? AssetImage("images/logo.png")
                                          : NetworkImage(_photoUrl),
                                    ))),
                          ),
                        )),
                    Container(
                      margin: EdgeInsets.only(top: 30.0),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _name = value;
                          });
                        },
                        controller: _naController,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                      ),
                    ),
                    //
                    //
                    Container(
                      margin: EdgeInsets.only(top: 30.0),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _phone = value;
                          });
                        },
                        controller: _poController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Phone',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                      ),
                    ),
                    //
                    Container(
                      margin: EdgeInsets.only(top: 30.0),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _email = value;
                          });
                        },
                        controller: _emController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                      ),
                    ),
                    //
                    Container(
                      margin: EdgeInsets.only(top: 30.0),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _address = value;
                          });
                        },
                        controller: _adController,
                        decoration: InputDecoration(
                          labelText: 'Address',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                      ),
                    ),
                    // update button
                   Container(
                            padding: EdgeInsets.fromLTRB(0, 30, 0, 30),
                            child: RaisedButton(
                              padding: EdgeInsets.fromLTRB(20.0, 20.0, 60.0, 20.0),
                              color: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              onPressed: (){
                                this.updateContact(context);
                              },
                              child: Text('Update',style:TextStyle(color:Colors.white,fontSize:20.0)),
                            ),
                          ),
                  ],
                ),
              ),
      ),
    );
  }
}