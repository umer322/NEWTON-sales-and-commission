import 'package:flutter/material.dart';
import 'dart:math';
class Loan extends StatefulWidget {
  @override
  _LoanState createState() => _LoanState();
}

class _LoanState extends State<Loan> {
  GlobalKey<FormState> _form3 = GlobalKey<FormState>();

  double loanAmount=0.0;
  double interestRate=0.0;
  int loanTerm1=0;
  int loanTerm2=0;
  int totalMonths=0;
  double extraPay=0.0;

  bool calculated=false;

  double monthlyPayment=0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Loan Calculator"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _form3,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: <Widget>[

                    Flexible(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: "Loan Amount",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)),
                            contentPadding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 10)),
                        onSaved: (val){
                          setState(() {
                            loanAmount=double.parse(val);
                          });
                        },
                        validator: (val) {
                          if (double.tryParse(val) == null) {
                            return "Please enter number";
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
                      child: TextFormField(
                        keyboardType: TextInputType.number,

                        onSaved: (val){
                          setState(() {
                            interestRate=double.parse(val);
                          });
                        },
                        decoration: InputDecoration(

                            labelText: "Interest Rate",
                            helperText: "% per year",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)),
                            contentPadding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 10)),
                        validator: (val) {
                          if (double.tryParse(val) == null) {
                            return "Please enter number";
                          }

                          return null;
                        },
                      ),
                      flex: 1,
                    ),

                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: <Widget>[

                    Flexible(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: "Loan Term Year",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)),
                            contentPadding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 10)),
                        onSaved: (val){
                          setState(() {
                            loanTerm1=int.parse(val);
                          });
                        },

                        initialValue: '0',
                        validator: (val) {
                          if (int.tryParse(val) == null) {
                            return "enter number";
                          }

                          return null;
                        },
                      ),
                      flex: 1,
                    ),
                    SizedBox(width: 10,),
                    Flexible(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        initialValue: '0',
                        decoration: InputDecoration(
                            labelText: "Loan Term Month",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)),
                            contentPadding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 10)),
                        onSaved: (val){
                          setState(() {
                            loanTerm2=int.parse(val);
                          });
                        },

                        validator: (val) {
                          if (int.tryParse(val) == null) {
                            return "enter number";
                          }

                          return null;
                        },
                      ),
                      flex: 1,
                    ),

                  ],
                ),
              ),
//              Padding(
//                padding: const EdgeInsets.all(10.0),
//                child: Row(
//                  children: <Widget>[
//                    Flexible(
//                      child: Center(
//                          child: Text(
//                        "Extra pay per month",
//                        style: TextStyle(fontSize: 20),
//                      )),
//                      flex: 1,
//                      fit: FlexFit.tight,
//                    ),
//                    Flexible(
//                      child: TextFormField(
//                        keyboardType: TextInputType.number,
//                        onSaved: (val){
//                          setState(() {
//                            extraPay=double.parse(val);
//                          });
//                        },
//                        decoration: InputDecoration(
//                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//                            contentPadding: EdgeInsets.symmetric(vertical: 7,horizontal: 10)),
//                        validator: (val) {
//                          if (double.tryParse(val) == null) {
//                            return "Please enter number";
//                          }
//
//                          return null;
//                        },
//                      ),
//                      flex: 1,
//                    )
//                  ],
//                ),
//              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RaisedButton(
                      onPressed: () {
                        _form3.currentState.reset();
                        setState(() {
                          calculated=false;
                        });
                      },
                      child: Text("Reset"),
                    ),
                    RaisedButton(
                      onPressed: () {
                        if(_form3.currentState.validate())
                          {
                            _form3.currentState.save();
                            totalMonths=(loanTerm1*12)+loanTerm2;
                            double percentageIncrease=interestRate/100;
                            percentageIncrease=percentageIncrease/12;
                            print(percentageIncrease);

                            double divider=((pow((1+percentageIncrease),totalMonths))-1)/((pow((1+percentageIncrease),totalMonths))*percentageIncrease);

                            monthlyPayment=loanAmount/divider;

                            setState(() {
                              calculated=true;
                            });
                          }
                      },
                      child: Text("Calculate"),
                    )
                  ],
                ),
              ),
              SizedBox(height: 10,),

              calculated?Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RichText(
                      text: TextSpan(
                        text: 'Monthly Payment: ',
                        style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.blue),
                        children: <TextSpan>[
                          TextSpan(text: ' ${monthlyPayment.toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red)),
                        ],
                      ),
                    ),

                  ],
                ),
              ):SizedBox(),


//              calculated?Padding(
//                padding: EdgeInsets.all(10),
//                child: Row(
//                  mainAxisAlignment: MainAxisAlignment.start,
//                  children: <Widget>[
//                   SizedBox(width: 10,),Text("With Additional Payment",style: TextStyle(color: Colors.blue,fontSize: 20,fontWeight: FontWeight.bold),)
//
//                  ],
//                ),
//              ):SizedBox(),
//              Padding(
//                padding: EdgeInsets.all(10),
//                child: Row(
//                  mainAxisAlignment: MainAxisAlignment.center,
//                  children: <Widget>[
//                    RichText(
//                      text: TextSpan(
//                        text: 'Annual Payment: ',
//                        style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
//                        children: <TextSpan>[
//                          TextSpan(text: ' ${(monthlyPayment*12).toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red)),
//                        ],
//                      ),
//                    ),
//
//                  ],
//                ),
//              ),

            ],
          ),
        ),
      ),
    );
  }
}
