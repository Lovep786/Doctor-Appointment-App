import 'package:firebase_database/firebase_database.dart';


class Info{
  String _id;
  String _name;
  String _phone;
  String _profession;
  String _email;
  String _address;
  String _speciality;
  String _photoUrl="empty";
  String _password;

  Info(this._name, this._phone,this._speciality, this._email,this._profession, this._address,this._photoUrl);
  Info.withId(this._id,this._name, this._phone,this._speciality, this._email,this._profession, this._address,this._photoUrl);

  String get id=>this._id;
  String get name=>this._name;
  String get phone=>this._phone;
  String get email=>this._email;
  String get address=>this._address;
  String get password=>this._password;
  String get profession=>this._profession;
  String get speciality=>this._speciality;
  String get photoUrl=>this._photoUrl;


  set name(String name){
    this._name=name;
  }
  set phone(String phone){
    this._phone=phone;
  }
  set speciality(String speciality){
    this._speciality=speciality;
  }
  set email(String email){
    this._email=email;
  }
  set address(String address){
    this._address=address;
  }
  set password(String password){
    this._password=password;
  }
  set profession(String profession){
    this._profession=profession;
  }
  set photoUrl(String photoUrl){
    this._photoUrl=photoUrl;
  }

  Info.fromSnapshot(DataSnapshot snapshot){
    this._id=snapshot.key;
    this._name=snapshot.value['name'];
    this._phone=snapshot.value['phone'];
    this._speciality=snapshot.value['speciality'];
    this._email=snapshot.value['email'];
    this._address=snapshot.value['address'];
    this._password=snapshot.value['password'];
    this._profession=snapshot.value['profession'];
    this._photoUrl=snapshot.value['photoUrl'];
  }
   
   Map<String,dynamic> toJson(){
     return {
       "name":_name,
       "phone":_phone,
       "speciality":_speciality,
       "email":_email,
       "address":_address,
       "password":_password,
       "profession":_profession,
       "photoUrl":_photoUrl,
     };
   }
}