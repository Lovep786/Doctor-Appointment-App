import 'package:flutter/cupertino.dart';

class Dinfo {
  
  String message;
  AssetImage imageUrl;

  Dinfo({this.message,this.imageUrl});
}

List<Dinfo> messageData = [
  new Dinfo(
      message: "Lockdown comes into force in Punjab, Chandigarh, 7 districts of Haryana.",
      imageUrl:
          AssetImage("images/1.jpg"),
          ),
  new Dinfo(
      message: "There are total 89 positive Coronavirus cases in the state including 14 new cases in Mumbai and 1 in Pune.",
      imageUrl:
          AssetImage("images/2.jpg"),
          ),
  new Dinfo(
      message: "Total number of positive Coronavirus cases in the country is 415 and 7 deaths: Ministry of Health and Family Welfare.",
      imageUrl:
          AssetImage("images/3.jpg"),
          ),
  new Dinfo(
      message: "In Delhi, 30 case-23 people returned from abroad, 7 their family members infected by them.",
      imageUrl:
          AssetImage("images/4.jpg"),
          ),
  new Dinfo(
      message: "11 new coronavirus cases in Gujarat; total number of patients rises to 29: Official.",
      imageUrl:
          AssetImage("images/5.jpg"),
          ),
  new Dinfo(
      message:"68-yr-old man who recovered from COVID-19 dies in Mumbai.",
     imageUrl:
          AssetImage("images/6.jpg"),
          ),
  
];