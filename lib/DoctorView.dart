import 'package:docto/booking.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Info.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'dart:async';


class DoctorView extends StatefulWidget {
  final String did;
  final String pid;
  DoctorView(this.pid,this.did);
  @override
  _DoctorViewState createState() => _DoctorViewState(pid,did);
}

class _DoctorViewState extends State<DoctorView> {
  String did;
  String pid;
  _DoctorViewState(this.pid,this.did);
  String _pname='';
  String _photoU="empty";
DatabaseReference _databaseReference=FirebaseDatabase.instance.reference();
   Info info;
   Info infor;
   bool isLoading=false;
    String _name='';
    String _phone='';
    String _email='';
    String _address='';
    String _profession='';
    String _speciality='';
    String _photoUrl="empty";
    DateTime _datech=new DateTime.now();
    TimeOfDay _timech=new TimeOfDay.now();
    String _date="00-00-0000";
    String _time="00:00";

 getPatContact(pid) async{
     _databaseReference.child('userData').child(pid).onValue.listen((event){
       setState(() {
         infor=Info.fromSnapshot(event.snapshot);
         _pname=infor.name;
        _photoU=infor.photoUrl;
       });
     });
   } 

    Future<Null> _selectDate(BuildContext context) async{
      final DateTime picked=await showDatePicker(
        context: context, 
        initialDate: _datech, 
        firstDate: new DateTime(2020), 
        lastDate: new DateTime(2050));
        if(picked !=null && picked != _datech){
          setState(() {
            _datech=picked;
            _date="${_datech.day}-${_datech.month}-${_datech.year}";
          });
        }
        
    }
    Future<Null> _selectTime(BuildContext context) async{
      final TimeOfDay picked=await showTimePicker(
        context: context, 
        initialTime: _timech, 
        );
        if(picked !=null && picked != _timech){
          setState(() {
            _timech=picked;
            _time="${_timech.hour}:${_timech.minute}";
          });
        }
        
    }

   getDoctContact(did) async{
     _databaseReference.child('userData').child(did).onValue.listen((event){
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
   confirmBook(){
     showDialog(
       context: context,
       builder: (BuildContext context){
         return AlertDialog(
           title: Text("Confirm Booking"),
           content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text("Selected Date : ${_date}",textAlign: TextAlign.center,style:TextStyle(fontSize: 15.0,color: Colors.red)),
              Text("Selected Time : ${_time}",textAlign: TextAlign.center,style:TextStyle(fontSize: 15.0,color: Colors.red)),
            ],
          ),
        ),
           actions: <Widget>[
             FlatButton(
               child: Text("Cancel"),
               onPressed: (){
                 Navigator.of(context).pop();
               },
             ),
             FlatButton(
               child: Text("Book"),
               onPressed: () async{
                 Navigator.of(context).pop();
                 createBooking();
               },
             ),
           ],
         );
       }
     );
   }

   bookAppointment() async{
     showDialog(
       context: context,
       builder: (BuildContext context){
         return AlertDialog(
           title: Text("Book Appointment"),
           content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
               FlatButton(
                    onPressed: (){
                      this._selectDate(context);
                    }, 
                    child: Text("Select Date",textAlign: TextAlign.center,style:TextStyle(fontSize: 15.0,color: Colors.red))),
                    FlatButton(
                    onPressed: (){
                      this._selectTime(context);
                    }, 
                    child: Text("Select Time",textAlign: TextAlign.center,style:TextStyle(fontSize: 15.0,color: Colors.red))),  
            ],
          ),
        ),
                   
           
             
           actions: <Widget>[
            
             FlatButton(
               child: Text("Cancel"),
               onPressed: (){
                 Navigator.of(context).pop();
               },
             ),
             FlatButton(
               child: Text("Confirm"),
               onPressed: () async{
                 Navigator.of(context).pop();
                 this.confirmBook();
               },
             ),
           ],
         );
       }
     );
   }
    
   createBooking() async{      
          try {
             if(pid.isNotEmpty && did.isNotEmpty && _date.isNotEmpty && _time.isNotEmpty )
             {
             Booking book=Booking(this.pid,this._pname, this.did,this._date, this._time,this._photoU);
             await _databaseReference.child("booking").push().set(book.toJson());
             }
          } catch (e) {
            showError(e.message,context);
          }
         this.bookSuccess();
  }
  bookSuccess(){
     showDialog(
       context: context,
       builder: (BuildContext context){
         return AlertDialog(
           title: Text("Booking Confirmed"),
           content: Text("Successfully Booked."),
           actions: <Widget>[
             FlatButton(
               child: Text("Ok"),
               onPressed: (){
                 Navigator.of(context).pop();
               },
             ),
             
           ],
         );
       }
     );
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
   navigateToLastScreen(BuildContext context){
   Navigator.pop(context);
 }
   @override 
   void initState(){
     super.initState();
     this.getDoctContact(did);
     this.getPatContact(pid);
     
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Profile')
        
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
                  color: Colors.yellow,
                  child:Container(
                                width: 150.0,
                                height: 150.0,
                                decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
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
                  Container(
                    padding: EdgeInsets.all(20.0),
                  child:Center(
                    child:RaisedButton(
                      padding: EdgeInsets.all(15.0),
                      shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          color: Colors.red,
                          onPressed: (){
                             this.bookAppointment();
                          },
                          child: Text('Book',style:TextStyle(color:Colors.white,fontSize:20.0)),
                    )
                  )
                ),
                ]
                
                ),
                
      ),
      
    
    );
  }
}