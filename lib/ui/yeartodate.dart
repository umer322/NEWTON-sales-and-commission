import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class YearToDate extends StatefulWidget {
  @override
  _YearToDateState createState() => _YearToDateState();
}

class _YearToDateState extends State<YearToDate> {
  Map<DateTime, List> _events = {};
  double volume = 0.0;
  double total = 0.0;
  double commission = 0.0;
  double bonus = 0.0;
  double spiff = 0.0;
  List entryDates = [];

  _onCreate(Database db, int version) async {
    // Database is created, create the table
    await db.execute(
        "CREATE TABLE Sale (id INTEGER PRIMARY KEY, name TEXT,contact TEXT,volume INTEGER,downpayment INTEGER,commission REAL,bonus REAL,spiff REAL,date TEXT)");
    print("oncreate called");
  }

  getData() async {
    var db =
        await openDatabase('sale_entry.db', onCreate: _onCreate, version: 1);
    if (db.isOpen) {
      List<Map> listOfEntries = await db.rawQuery('SELECT * FROM Sale');

      print(listOfEntries.length);

      listOfEntries.forEach((entry) {
        print(entry);
        if (DateTime.parse(entry['date']).isAfter(DateTime.parse("${DateTime.now().year}-01-01"))) {
          setState(() {
            volume = volume + entry['volume'];
            commission = commission + entry['commission'];
            bonus = bonus + entry['bonus'];
            spiff = spiff + entry['spiff'];
          });
        }
      });
      setState(() {
        total=commission+bonus+spiff;
      });
    }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Year to Date Detail"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              DetailWidget(text: "Year to date volume", value: volume),
              SizedBox(
                height: 20,
              ),
              DetailWidget(text: "Year to date commission", value: commission),
              SizedBox(
                height: 20,
              ),
              DetailWidget(text: "Year to date bonus", value: bonus),
              SizedBox(
                height: 20,
              ),
              DetailWidget(text: "Year to date spiff", value: spiff),
              SizedBox(
                height: 20,
              ),
              DetailWidget(text: "Year to date total", value: total),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DetailWidget extends StatelessWidget {
  const DetailWidget({
    Key key,
    @required this.text,
    @required this.value,
  }) : super(key: key);
  final String text;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
              child: Text(
            "$text",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          )),
          Expanded(
              child: Text(
            "\$${value.toStringAsFixed(2)}",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.end,
          ))
        ],
      ),
    );
  }
}
