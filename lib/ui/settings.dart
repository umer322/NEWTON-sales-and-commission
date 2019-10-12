import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  TextEditingController bonusController = TextEditingController();
  TextEditingController commissionController = TextEditingController();
  TextEditingController podiumController = TextEditingController();
  GlobalKey<FormState> _form2 = GlobalKey<FormState>();

  GlobalKey<ScaffoldState> _scaffoldSetting=GlobalKey<ScaffoldState>();

  String podium='Fixed';



  getValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      commissionController.text = prefs.getString("commission") ?? '0';
      bonusController.text = prefs.getString("bonus") ?? '0';
      podiumController.text=prefs.getString("podiumValue")??"0";
      podium=prefs.getString("podiumState")??"Fixed";
    });
  }

  setValues() async {
    if (_form2.currentState.validate()) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("commission", commissionController.text);
      prefs.setString("bonus", bonusController.text);
      prefs.setString("podiumValue", podiumController.text);
      prefs.setString("podiumState", podium);
      setState(() {
        commissionController.text = prefs.getString("commission") ?? '0';
        bonusController.text = prefs.getString("bonus") ?? '0';
        podiumController.text=prefs.getString("podiumValue")??"0";
        podium=prefs.getString("podiumState")??"Fixed";
      });
       _scaffoldSetting.currentState.showSnackBar(SnackBar(content: Text("Values updated")));
      Future.delayed(Duration(seconds: 1),(){
        Navigator.pop(context);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getValues();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldSetting,
      appBar: AppBar(
        title: Text("Settings"),
        centerTitle: true,
      ),
      body: Form(
        key: _form2,
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: <Widget>[

                  Flexible(
                    child: TextFormField(
                      controller: commissionController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: "Commission",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)),
                          contentPadding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 10)),
                      validator: (val) {
                        if (int.tryParse(val) == null) {
                          return "Please enter number";
                        } else if (int.parse(val) < 0 || int.parse(val) > 100) {
                          return "Enter number between 0 to 100";
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
                      controller: bonusController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: "Bonus",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)),
                          contentPadding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 10)),
                      validator: (val) {
                        if (int.tryParse(val) == null) {
                          return "Please enter number";
                        } else if (int.parse(val) < 0 || int.parse(val) > 100) {
                          return "Enter number between 0 to 100";
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
                      controller: podiumController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: "Podium/Mentor/Deduction",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)),
                          contentPadding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                        errorStyle: TextStyle(fontSize: 10)),

                      validator: (val) {
                        if (int.tryParse(val) == null && double.tryParse(val)==null) {
                          return "Please enter number";
                        } else if (int.tryParse(val)==null && podium == "%") {

                            return "Enter integer values!";

                        }
                        else if(int.parse(val) <0 || int.parse(val) >100){
                          return "Enter values between 0 to 100 as %";
                        }
                        return null;
                      },
                    ),
                    flex: 1,
                  ),
                  DropdownButton<String>(
                    value: podium,
                    items: <String>['Fixed', '%',].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (val) {setState(() {
                      podium=val;
                      podiumController.text='';
                    });},
                  )
                ],
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        onPressed: setValues,
                        child: Text("Update"),
                      )
                    ]))
          ],
        ),
      ),
    );
  }
}
