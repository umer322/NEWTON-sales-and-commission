import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'sale.dart';
import 'package:path/path.dart';

class SaleEntry extends StatefulWidget {
  DateTime date;
  bool edited = false;
  Map data = {};
  SaleEntry.forEdit({this.edited, this.data, this.date});

  SaleEntry(this.date, {Key key}) : super(key: key);
  @override
  _SaleEntryState createState() => _SaleEntryState();
}

class _SaleEntryState extends State<SaleEntry> {
  bool podiumCondition = false;
  GlobalKey<FormState> _form = GlobalKey<FormState>();
  String volumeError = '';
  TextEditingController volumeController = TextEditingController();
  int volume = 0;
  int commissionValue = 0;
  int bonusValue = 0;
  double commission = 0.0;
  double bonus = 0.0;
  String podiumState = '';
  var podiumValue;
  String name;
  String contact;
  int downPayment = 0;
  String note = '';
  double spiff = 0.0;

  DateTime selectedDate;

  String bonusNew = '%';

  String commissionNew = '%';
  Sale editedData;

  TextEditingController commissionController = TextEditingController();
  TextEditingController bonusController = TextEditingController();

  GlobalKey<ScaffoldState> _scaffoldEntry = GlobalKey<ScaffoldState>();

  _onCreate(Database db, int version) async {
    // Database is created, create the table
    await db.execute(
        "CREATE TABLE Sale (id INTEGER PRIMARY KEY, name TEXT,contact TEXT,volume INTEGER,downpayment INTEGER,commission REAL,bonus REAL,spiff REAL,date TEXT,note TEXT,podium INTEGER,paydate TEXT)");
    print("oncreate called");
  }

  _onOpen(Database db) async {
    // Database is open, print its version
    print('db version ${await db.getVersion()}');
  }

  dataToDatabase(context, Sale sale) async {
    var db = await openDatabase('sale_entry.db',
        onCreate: _onCreate, onOpen: _onOpen, version: 1);
    if (db.isOpen) {
      if (widget.edited) {
        int count = await db.rawUpdate(
            'UPDATE Sale SET name=?,contact=?,volume=?,downpayment=?,commission=?,bonus=?,spiff=?,date=?,note=?,podium=?,paydate=? WHERE id = ?',
            [
              sale.name,
              sale.contact,
              sale.volume,
              sale.downpayment,
              sale.commission,
              sale.bonus,
              sale.spiff,
              sale.date,
              sale.note,
              sale.podium,
              sale.paydate,
              widget.data['id']
            ]);
        print(count);
        _scaffoldEntry.currentState
            .showSnackBar(SnackBar(content: Text("Sale entry updated")));
        _form.currentState.reset();
        setState(() {
          volumeController.text = "";
          podiumCondition = false;
        });
      } else {
        await db.transaction((txn) async {
          int id1 = await txn.rawInsert(
              'INSERT INTO Sale(name,contact,volume,downpayment,commission,bonus,spiff,date,note,podium,paydate) VALUES("${sale.name}", "${sale.contact}", ${sale.volume},${sale.downpayment},${sale.commission},${sale.bonus},${sale.spiff},"${sale.date}","${sale.note}","${sale.podium}","${sale.paydate}")');
          print('inserted1: $id1');
          _scaffoldEntry.currentState
              .showSnackBar(SnackBar(content: Text("Sale entry saved")));
          _form.currentState.reset();
          setState(() {
            volumeController.text = "";
            podiumCondition = false;
          });
        });
      }

      Future.delayed(Duration(seconds: 1), () {
        Navigator.pop(context, true);
        Navigator.pop(context);
      });
    } else {
      print(db.path);
    }
  }

  getValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      commissionValue = int.parse(prefs.getString("commission") ?? '0');
      bonusValue = int.parse(prefs.getString("bonus") ?? '0');
      podiumValue = double.tryParse(prefs.getString("podiumValue")) ?? "0";
      podiumState = prefs.getString("podiumState");
      commissionController.text = commissionValue.toString();
      bonusController.text = bonusValue.toString();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.edited) {
      editedData = Sale.fromJson(widget.data);
      getValues();
      setState(() {
        volumeController.text = editedData.volume.toString();
        volume = editedData.volume;
        commission = editedData.commission;
        bonus = editedData.bonus;
        podiumCondition=editedData.podium==1?true:false;
        selectedDate=DateTime.parse(editedData.paydate);
      });
    } else {
      getValues();
    }
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate:selectedDate==null?widget.date:selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          key: _scaffoldEntry,
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Form(
                key: _form,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Flexible(
                              flex:1,
                              child: Text("Sold Date: ${widget.date.month}\\${widget.date.day}",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),),
                          Flexible(
                            flex:1,
                            child: RaisedButton(
                              onPressed: () => _selectDate(context),
                              child: Text(selectedDate==null?'Pay date':"Pay Date: ${selectedDate.month}\\${selectedDate.day}"),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        initialValue: widget.edited ? editedData.name : null,
                        validator: (val) {
                          if (val == "") {
                            return "Please enter name here";
                          }
                          return null;
                        },
                        onSaved: (val) {
                          setState(() {
                            name = val;
                          });
                        },
                        decoration: InputDecoration(
                            labelText: "Name",
                            filled: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 10)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        initialValue: widget.edited ? editedData.contact : null,
                        onSaved: (val) {
                          setState(() {
                            contact = val;
                          });
                        },
                        validator: (val) {
                          if (val == "") {
                            return "Please enter contact details here";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: "Contact#",
                            filled: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 10)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        onChanged: (val) {
                          if (int.tryParse(val) == null) {
                            setState(() {
                              volumeError = "Value must be integer";
                            });
                          } else {
                            setState(() {
                              volumeError = '';
                              volume = int.parse(val);
                              commission = double.parse(
                                  (volume * (commissionValue / 100))
                                      .toStringAsFixed(2));
                              bonus = double.parse((volume * (bonusValue / 100))
                                  .toStringAsFixed(2));
                            });
                          }
                        },
                        controller: volumeController,
                        decoration: InputDecoration(
                            errorText: volumeError == '' ? null : volumeError,
                            labelText: "Volume",
                            filled: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 10)),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        initialValue: widget.edited
                            ? editedData.downpayment.toString()
                            : null,
                        decoration: InputDecoration(
                            labelText: "Downpayment %",
                            filled: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 10)),
                        keyboardType: TextInputType.number,
                        onSaved: (val) {
                          setState(() {
                            downPayment = int.parse(val);
                          });
                        },
                        validator: (val) {
                          if (int.tryParse(val) == null) {
                            return "Please enter number here";
                          } else if (int.tryParse(val) != null &&
                                  int.parse(val) < 0 ||
                              int.parse(val) > 100) {
                            return "Please enter value between 0 to 100 to compute as %";
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        initialValue:
                            widget.edited ? editedData.spiff.toString() : null,
                        decoration: InputDecoration(
                            labelText: "Spiff",
                            filled: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 10)),
                        keyboardType: TextInputType.number,
                        onSaved: (val) {
                          setState(() {
                            spiff = double.parse(val);
                          });
                        },
                        validator: (val) {
                          if (double.tryParse(val) == null) {
                            return "Please enter number here";
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        initialValue: widget.edited ? editedData.note : null,
                        decoration: InputDecoration(
                            labelText: "Note",
                            filled: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 10)),
                        onSaved: (val) {
                          setState(() {
                            note = val;
                          });
                        },
                        validator: (val) {
                          if (val == "") {
                            return "Please enter some note here";
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text("Podium/Mentor/Deduction"),
                          Checkbox(
                              value: podiumCondition,
                              onChanged: (val) {
                                setState(() {
                                  podiumCondition = val;
                                  if (val == true) {
                                    if (podiumState == "Fixed") {
                                      commission = double.parse(
                                          (commission - podiumValue)
                                              .toStringAsFixed(2));
                                    } else if (podiumState == "%") {
                                      commission = double.parse((volume *
                                              ((commissionValue - podiumValue) /
                                                  100))
                                          .toStringAsFixed(2));
                                    }
                                  }
                                  if (val == false) {
                                    commission = double.parse(
                                        (volume * (commissionValue / 100))
                                            .toStringAsFixed(2));
                                  }
                                });
                              })
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Flexible(
                            child: Text(
                              "Commission",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                          ),
                          commissionNew == "Fixed"
                              ? SizedBox(
                                  width: 1,
                                )
                              : Flexible(
                                  child: Text("$commission",
                                      style: TextStyle(fontSize: 16))),
                          Flexible(
                            child: TextField(
                              onChanged: (val) {
                                setState(() {
                                  commissionValue = int.parse(val);
                                  commission = double.parse(
                                      (volume * (commissionValue / 100))
                                          .toStringAsFixed(2));
                                });
                              },
                              controller: commissionController,
                              decoration: InputDecoration(
                                labelText: commissionNew == 'Fixed'
                                    ? "Commission Value"
                                    : "Commission %",
                                filled: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 10),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          Flexible(
                              child: DropdownButton(
                            items: ['Fixed', '%']
                                .map((k) => DropdownMenuItem<String>(
                                    child: Text(k), value: k))
                                .toList(),
                            onChanged: (val) {
                              setState(() {
                                commissionNew = val;
                                if (val == "%") {
                                  commission = double.parse(
                                      (volume * (commissionValue / 100))
                                          .toStringAsFixed(2));
                                }
                              });
                            },
                            value: commissionNew,
                          ))
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Flexible(
                            child: Text(
                              "Bonus",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                          ),
                          bonusNew == "Fixed"
                              ? SizedBox(
                                  width: 5,
                                )
                              : Flexible(
                                  child: Text("$bonus",
                                      style: TextStyle(fontSize: 20))),
                          Flexible(
                            child: TextField(
                              onChanged: (val) {
                                setState(() {
                                  bonusValue = int.parse(val);
                                  bonus = double.parse(
                                      (volume * (bonusValue / 100))
                                          .toStringAsFixed(2));
                                });
                              },
                              controller: bonusController,
                              decoration: InputDecoration(
                                labelText: bonusNew == "Fixed"
                                    ? "Bonus value"
                                    : "Bonus %",
                                filled: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 10),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          Flexible(
                              child: DropdownButton(
                                  value: bonusNew,
                                  items: ['Fixed', '%']
                                      .map((k) => DropdownMenuItem<String>(
                                            child: Text(k),
                                            value: k,
                                          ))
                                      .toList(),
                                  onChanged: (val) {
                                    setState(() {
                                      bonusNew = val;
                                    });
                                  }))
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          RaisedButton(
                            onPressed: () {
                              if (_form.currentState.validate()) {
                                _form.currentState.save();

                                Sale sale = Sale(
                                    name: name,
                                    contact: contact,
                                    volume: volume,
                                    commission: commissionNew == "Fixed"
                                        ? double.parse(
                                            commissionController.text)
                                        : commission,
                                    bonus: bonusNew == "Fixed"
                                        ? double.parse(bonusController.text)
                                        : bonus,
                                    date: widget.date.toString().split(" ")[0],
                                    downpayment: downPayment,
                                    spiff: spiff,
                                    note: note,
                                    podium: podiumCondition ? 1 : 0,
                                    paydate: selectedDate==null?widget.date.toString().split(" ")[0]:selectedDate.toString().split(" ")[0]);
                                dataToDatabase(context, sale);
                              }
                            },
                            child: Text("Save"),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
