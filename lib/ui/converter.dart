import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CurrencyConverter extends StatefulWidget {
  @override
  _CurrencyConverterState createState() => _CurrencyConverterState();
}

class _CurrencyConverterState extends State<CurrencyConverter> {

  GlobalKey<ScaffoldState> _scaffoldCurrency=GlobalKey<ScaffoldState>();
  List currencyDetails=[];
  String symbolTo='';
  String toName='';
  String symbolFrom='';
  String fromName='';
  double enteredValue=0.0;
  double convertedValue=0.0;
  List currencyid=[];
  GlobalKey<FormState> _form123=GlobalKey<FormState>();
   currencyData()async{
     http.Response response=await http.get("https://free.currconv.com/api/v7/currencies?apiKey=c170196be4ba22d760a0");
     Map data= jsonDecode(response.body);

     data['results'].forEach((k,v){
       currencyDetails.add(v);
       currencyid.add(v['id']);
     });
     setState(() {
       currencyid.sort();
     });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currencyData();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldCurrency,
      appBar: AppBar(title: Text("Currency Converter"),centerTitle: true,actions: <Widget>[IconButton(icon: Icon(Icons.refresh), onPressed: (){
        _form123.currentState.reset();
        setState(() {
          toName='';
          fromName='';
          symbolFrom='';
          symbolTo='';
          enteredValue=0.0;
          convertedValue=0.0;
        });
      })],),
      body: SingleChildScrollView(
        child: Form(
          key: _form123,
          child: Column(children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: <Widget>[

                  Flexible(
                    child: TextFormField(
                      onSaved: (val){
                        setState(() {
                          enteredValue=double.parse(val);
                        });
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: "From",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)),
                          contentPadding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 10)),

                      validator: (val) {
                        if (int.tryParse(val) == null) {
                          return "Enter number";
                        }

                        return null;
                      },
                    ),
                    flex: 1,
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: <Widget>[
                  Flexible(

                    child:  Text(
                      symbolFrom==''?"Select Currency":fromName,

                      style: TextStyle(fontSize: symbolFrom==''?20:22,fontWeight: FontWeight.bold),
                    ),
                    flex: 3,
                    fit: FlexFit.tight,
                  ),

                  Expanded(
                    child:  DropdownButton(

                        items:currencyid.map((d)=>DropdownMenuItem(child: Text(d),value: d,)).toList(), onChanged: (val){
                      setState(() {
                        symbolFrom=val;
                        currencyDetails.forEach((v){if(v['id']==symbolFrom){setState(() {
                          fromName=v['currencyName'];
                        });}});
                      });

                    }),
                    flex: 1,
                  )
                ],
              ),
            ),

            Padding(padding: EdgeInsets.symmetric(vertical: 20,horizontal: 30),child: Divider(color: Colors.black,height: 10,),),

            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: <Widget>[
                  Flexible(

                    child:  Text(
                      "To",
                      style: TextStyle(fontSize: 20),
                    ),
                    flex: 2,
                    fit: FlexFit.tight,
                  ),

                  Flexible(
                    child: Text("$convertedValue",style: TextStyle(fontSize: 20,color: Colors.red,fontWeight: FontWeight.bold),textAlign: TextAlign.end,),
                    flex: 1,
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: <Widget>[
                  Flexible(

                    child:  Text(
                      symbolTo==''?"Select Currency":toName,

                      style: TextStyle(fontSize: symbolTo==''?20:22,fontWeight: FontWeight.bold),
                    ),
                    flex: 3,
                    fit: FlexFit.tight,
                  ),

                  Expanded(
                    child:  DropdownButton(

                        items:currencyid.map((d)=>DropdownMenuItem(child: Text(d),value: d,)).toList(), onChanged: (val){
                      setState(() {
                        symbolTo=val;
                        currencyDetails.forEach((v){if(v['id']==symbolTo){setState(() {
                          toName=v['currencyName'];
                        });}});
                      });

                    }),
                    flex: 1,
                  )
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                 RaisedButton(onPressed: ()async{
                   if(_form123.currentState.validate()){
                     _form123.currentState.save();
                     if(symbolTo=='' || symbolFrom =='')
                       {
                         _scaffoldCurrency.currentState.showSnackBar(SnackBar(content:Text("Please select both currencies")));
                       }
                       else{

                       print("https://free.currconv.com/api/v7/convert?q=${symbolFrom}_$symbolTo&compact=ultra&apiKey=c170196be4ba22d760a0");
                       http.Response response=await http.get("https://free.currconv.com/api/v7/convert?q=${symbolFrom}_$symbolTo&compact=ultra&apiKey=c170196be4ba22d760a0");

                      Map data=jsonDecode(response.body);
                       setState(() {
                         convertedValue=double.parse((enteredValue*data['${symbolFrom}_$symbolTo']).toStringAsFixed(2));
                       });

                     }

                   }
                 },child: Text("Convert"),)
                ],
              ),
            ),


          ],),
        ),
      ),
    );
  }
}
