import 'package:flutter/material.dart';
import 'package:expense_calculator/ui/calendar.dart';
import 'package:expense_calculator/ui/vacation.dart';
import 'package:expense_calculator/ui/settings.dart';
import 'package:expense_calculator/ui/loan.dart';
import 'package:expense_calculator/ui/converter.dart';
import 'package:expense_calculator/ui/yeartodate.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("NEWTON Sales & Commissions"),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.settings), onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>Settings())))
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.1,
                  vertical: MediaQuery.of(context).size.height * 0.08),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height * 0.02),
                    child: MaterialButton(
                      onPressed: () =>Navigator.push(context, MaterialPageRoute(builder: (context)=>Calendar())),
                      minWidth: MediaQuery.of(context).size.width * 0.7,
                      height: MediaQuery.of(context).size.height * 0.09,
                      child: Row(
                        children: <Widget>[
                          Flexible(child: Container(child: Center(child: Icon(Icons.calendar_today,color: Colors.green[800],),),)),
                          Flexible(
                            fit: FlexFit.tight,
                            flex: 3,
                            child: Text(
                              "Calendar",
                              style: TextStyle(fontSize: 22, color: Colors.green[800]),
                            ),
                          ),
                        ],
                      ),
                      color: Colors.lightGreenAccent.withOpacity(0.5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height * 0.02),
                    child: MaterialButton(
                      onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>YearToDate())),
                      minWidth: MediaQuery.of(context).size.width * 0.7,
                      height: MediaQuery.of(context).size.height * 0.09,
                      child: Row(
                        children: <Widget>[
                          Flexible(child: Container(child: Center(child: Icon(Icons.dashboard,color: Colors.yellow[800],),),)),
                          Flexible(
                            fit: FlexFit.tight,
                            flex: 3,
                            child: Text(
                              "Year to Date",
                              style: TextStyle(fontSize: 22, color: Colors.yellow[800]),
                            ),
                          ),
                        ],
                      ),
                      color: Colors.limeAccent.withOpacity(0.5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height * 0.02),
                    child: MaterialButton(
                      onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>Vacation())),
                      minWidth: MediaQuery.of(context).size.width * 0.7,
                      height: MediaQuery.of(context).size.height * 0.09,
                      child: Row(
                        children: <Widget>[
                          Flexible(child: Container(child: Center(child: Icon(Icons.beach_access,color: Colors.blue[800],),),)),
                          Flexible(
                            fit: FlexFit.tight,
                            flex: 3,
                            child: Text(
                              "Vacation Calculator",
                              style: TextStyle(fontSize: 22, color: Colors.blue[800]),
                            ),
                          ),
                        ],
                      ),
                      color: Colors.lightBlueAccent.withOpacity(0.5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height * 0.02),
                    child: MaterialButton(
                      onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>CurrencyConverter())),
                      minWidth: MediaQuery.of(context).size.width * 0.7,
                      height: MediaQuery.of(context).size.height * 0.09,
                      child:Row(
                        children: <Widget>[
                          Flexible(child: Container(child: Center(child: Icon(Icons.attach_money,color: Colors.orange[800],),),)),
                          Flexible(
                            fit: FlexFit.tight,
                            flex:3,
                            child: Text(
                              "Currency Converter",
                              style: TextStyle(fontSize: 22, color: Colors.orange[800]),
                            ),
                          ),
                        ],
                      ),
                      color: Colors.orangeAccent.withOpacity(0.5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height * 0.02),
                    child: MaterialButton(
                      onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>Loan())),
                      minWidth: MediaQuery.of(context).size.width * 0.7,
                      height: MediaQuery.of(context).size.height * 0.09,
                      child: Row(
                        children: <Widget>[
                          Flexible(child: Container(child: Center(child: Icon(Icons.book,color: Colors.greenAccent[800],),),)),
                          Flexible(
                            fit: FlexFit.tight,
                            flex: 3,
                            child: Text(
                              "Loan Calculator",
                              style: TextStyle(fontSize: 22, color: Colors.green[800]),
                            ),
                          ),
                        ],
                      ),
                      color: Colors.greenAccent.withOpacity(0.5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }
}
