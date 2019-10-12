//import 'package:sqflite/sqflite.dart';
class Sale{
  String name;
  String contact;
  int volume;
  int downpayment;
  double commission;
  double bonus;
  String date;
  double spiff;
  String note;
  int podium;
  String paydate;
  Sale({this.name,this.contact,this.volume,this.downpayment,this.commission,this.bonus,this.date,this.spiff,this.note,this.podium,this.paydate});


  Sale.fromJson(Map<String,dynamic> json){
    name=json['name'];
    contact=json['contact'];
    volume=json['volume'];
    downpayment=json['downpayment'];
    commission=json['commission'];
    bonus=json['bonus'];
    date=json['date'];
    spiff=json['spiff'];
    note=json['note'];
    podium=json['podium'];
    paydate=json['paydate'];
  }


}