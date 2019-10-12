import 'package:flutter/material.dart';

class Vacation extends StatefulWidget {
  @override
  _VacationState createState() => _VacationState();
}

class _VacationState extends State<Vacation> {
  GlobalKey<FormState> _form1 = GlobalKey<FormState>();

  int totalDays=0;
  double averageCostPerNight=0.0;
  double flightsPerYear=0.0;
  double misc=0.0;
  double totalYearly=0.0;
  int numOfYears=0;
  double inflation=0.0;
  double total=0.0;
  double totalAmount=0.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Vacation Calculator"),),
      body: Form(
        key: _form1,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: <Widget>[

                    Flexible(
                      child: TextFormField(
                        onSaved: (val){
                          setState(() {
                            totalDays=int.parse(val);
                          });
                        },
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: "Total Days",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)),
                            contentPadding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                        ),

                        validator: (val) {
                          if (int.tryParse(val) == null) {
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
                        onSaved: (val){
                          setState(() {
                            averageCostPerNight=double.parse(val);
                          });
                        },
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: "Average Night Cost",
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
                          flightsPerYear=double.parse(val);
                        },
                        decoration: InputDecoration(
                            labelText: "Flights per year",
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
                        onSaved: (val){
                          setState(() {
                            misc=double.parse(val);
                          });
                        },
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: "Misc",
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
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: Center(
                          child: Text(
                        "Total yearly",
                        style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                      )),
                      flex: 1,
                      fit: FlexFit.tight,
                    ),
                    Flexible(
                        child: Center(
                          child: Text(
                            "$totalYearly",
                            style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                          ),
                        ))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: <Widget>[

                    Flexible(
                      child: TextFormField(
                        onSaved: (val){
                          numOfYears=int.parse(val);
                        },
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: "# years",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)),
                            contentPadding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 10)),
                        validator: (val) {
                          if (int.tryParse(val) == null) {
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
                        onSaved: (val){
                          setState(() {
                            inflation=double.parse(val);
                          });
                        },
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: "Inflation",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)),
                            contentPadding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 10)),
                        validator: (val) {
                          if (double.tryParse(val) == null) {
                            return "Please enter number here";
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
                padding: EdgeInsets.all(10),
                child: Row(
                  children: <Widget>[
                    Flexible(
                        child: Center(
                      child: Text(
                        "Total",
                        style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                      ),
                    )),
                    Flexible(
                        child: Center(
                      child: Text(
                        "${totalAmount.toStringAsFixed(2)}",
                        style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                      ),
                    ))
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      onPressed: () {
                        if(_form1.currentState.validate()){
                          _form1.currentState.save();

                          setState(() {
                            totalYearly=totalDays*averageCostPerNight+flightsPerYear+misc;
                            double inflationCalculated=totalYearly*inflation/100;
                            totalAmount=totalYearly;
                            total=totalYearly;
                            int i=1;
                            while(i<numOfYears){
                              inflationCalculated=total*inflation/100;
                              total=total+inflationCalculated;
                              totalAmount=totalAmount+total;
                              i++;
                            }
                          });
                        }
                      },
                      child: Text("Compute"),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
