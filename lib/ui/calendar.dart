import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:expense_calculator/ui/salesentry.dart';
import 'package:sqflite/sqflite.dart';




class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> with SingleTickerProviderStateMixin{

  Map<DateTime, List> _events={};
  List entryDates=[];
  List _selectedEvents;
  AnimationController _animationController;

  double total=0.0;
  double commission=0.0;
  double bonus=0.0;
  double spiff=0.0;

  bool details=false;

  Widget _buildEventList() {
    return Expanded(
      child: ListView(
        children: _selectedEvents
            .map((event) => Container(
          decoration: BoxDecoration(
            border: Border.all(width: 0.8),
            borderRadius: BorderRadius.circular(12.0),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: ListTile(
            leading: Icon(Icons.attach_money),
            title: Text(event['name']),
            isThreeLine: true,
            subtitle: Column(children: <Widget>[
              Row(children: <Widget>[Expanded(child: Text("Volume:")),Expanded(child: Text("\$${event['volume']}"),),Expanded(child: Text("Bonus:")),Expanded(child: Text("\$${event['bonus']}"))],),
              Row(children: <Widget>[Expanded(child: Text("Spiff:")),Expanded(child: Text("\$${event['spiff']}"),),Expanded(child: Text("COMSN:")),Expanded(child: Text("\$${event['commission']}"))],),
              Row(children: <Widget>[Expanded(child: Text("Pay Date: ${event['paydate']}"))],),
              Row(children: <Widget>[Expanded(child: Text("Note: ${event['note']}"))],)
            ],),
            onTap: () => print('$event tapped!'),
            onLongPress: (){
              showDialog(context: context,builder:(context)=> AlertDialog(title: Text("Sale Entry Option"),content: Text("Select appropriate button for relative action"),actions: <Widget>[
                FlatButton(onPressed: ()async{
                  var db = await openDatabase('sale_entry.db',onCreate: _onCreate,version: 1);
                  int count = await db.rawDelete('DELETE FROM Sale WHERE id = ?', ['${event["id"]}']);

                  if(count==1)
                    {
                      setState(() {
                        total=0.0;
                        commission=0.0;
                        bonus=0.0;
                        spiff=0.0;
                        _selectedEvents.clear();
                      });
                      getData();
                      Navigator.pop(context);
                    }
                }, child: Text("Delete")),
                FlatButton(onPressed: ()async{

                  var ish=await Navigator.push(context,MaterialPageRoute(builder: (context)=>SaleEntry.forEdit(edited: true,data: event,date: DateTime.parse(event['date']),)));
                  print("here is sih"+ish.toString());
                  if(ish==null){
                  }
                  else if(ish ==true){
                    print("get data called");
                    getData();
                  }
                }, child: Text("Edit")),
                FlatButton(onPressed: ()=>Navigator.pop(context), child: Text("Cancel"))
              ],));
            },
          ),
        ))
            .toList(),
      ),
    );
  }

  deleteDB()async{
    var db=await deleteDatabase("sale_entry.db");
    print("database deleted");
  }

  void enterSale(DateTime date,list){

    setState(() {
      _selectedEvents = list;
    });

    showDialog(context: context,builder: (context){
     return  AlertDialog(
       title: Text("Sales Entry"),
       content: Text("Do you want to add sale entry to ${date.toString().split(" ")[0]}"),
       actions: <Widget>[
         FlatButton(onPressed: (){setState(() {
           details=true;
         });
         Navigator.pop(context);
         }, child: Text("Show details")),
         FlatButton(onPressed: ()async{
           var ish=await Navigator.push(context, MaterialPageRoute(builder:(context)=>SaleEntry(date)));
           if(ish==null){
           }
           else if(ish ==true){
               getData();
             }
           
           }, child: Text("Ok")),

         FlatButton(onPressed: (){
           setState(() {
             details=false;
           });
           Navigator.pop(context);}, child: Text("Cancel"))
       ],
     );

    });
  }

  _onCreate(Database db, int version) async {
    // Database is created, create the table
    await db.execute(
        "CREATE TABLE Sale (id INTEGER PRIMARY KEY, name TEXT,contact TEXT,volume INTEGER,downpayment INTEGER,commission REAL,bonus REAL,spiff REAL,date TEXT,note TEXT,podium INTEGER,paydate TEXT)");
    print("oncreate called");
  }



  getData()async{
    var db = await openDatabase('sale_entry.db',onCreate: _onCreate,version: 1);
    if(db.isOpen) {
      List<Map> listOfEntries = await db.rawQuery('SELECT * FROM Sale');
      listOfEntries.forEach((entry) {
        entryDates.add(entry['date']);
      });
      entryDates.forEach((date) {
        List data = [];
        listOfEntries.forEach((entry) {
          if (entry['date'] == date) {
            setState(() {
              data.add(entry);
            });
          }
        });
        setState(() {
          _events[DateTime.parse(date)] = List.from(data);
        });

        data.clear();
      });

      _events.forEach((k, v) {

        String monthdata=DateTime.now().month.toString().length==1?"0${DateTime.now().month}":"${DateTime.now().month}";

        DateTime dateFormat=DateTime.parse("${DateTime.now().year}-$monthdata-01");

        String nextMonth="${DateTime.now().month==12?DateTime.now().year+1:DateTime.now().year}-${DateTime.now().month==12?1:DateTime.now().month+1}-01";

        if (k.isAfter(dateFormat)&& k.isBefore(DateTime.parse(nextMonth)) || k.isAtSameMomentAs(dateFormat)) {

          v.forEach((entry) {
            setState(() {
              total = total + entry['volume'];
              commission = commission + entry['commission'];
              bonus = bonus + entry['bonus'];
              spiff = spiff + entry['spiff'];
              _selectedEvents.clear();
            });
          });
        }

      });
    }
  }


  CalendarController _calendarController;
  void initState() {
    super.initState();
//    deleteDB();
    _calendarController = CalendarController();
    getData();
    final _selectedDay = DateTime.now();
    _selectedEvents = _events[_selectedDay] ?? [];

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();

  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
    _animationController.dispose();
  }


  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: _calendarController.isSelected(date)
            ? Colors.brown[500]
            : _calendarController.isToday(date) ? Colors.brown[300] : Colors.blue[400],
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${"\$"*events.length}',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Calendar"),centerTitle: true,),
        body: Column(
          children: <Widget>[
            TableCalendar(calendarController: _calendarController,availableCalendarFormats: {CalendarFormat.month:"Month"},startDay:  DateTime.now().subtract(Duration(days: 300)),onDaySelected: enterSale,events: _events, calendarStyle: CalendarStyle(
              selectedColor: Colors.deepOrange[400],
              todayColor: Colors.deepOrange[200],
              markersColor: Colors.brown[700],
              outsideDaysVisible: false,
            ),
            builders: CalendarBuilders(
              selectedDayBuilder: (context, date, _) {
                return FadeTransition(
                  opacity: Tween(begin: 0.0, end: 1.0).animate(_animationController),
                  child: Container(
                    margin: const EdgeInsets.all(4.0),
                    padding: const EdgeInsets.only(top: 5.0, left: 6.0),
                    color: Colors.deepOrange[300],
                    width: 100,
                    height: 100,
                    child: Text(
                      '${date.day}',
                      style: TextStyle().copyWith(fontSize: 16.0),
                    ),
                  ),
                );
              },
              todayDayBuilder: (context, date, _) {
                return Container(
                  margin: const EdgeInsets.all(4.0),
                  padding: const EdgeInsets.only(top: 5.0, left: 6.0),
                  color: Colors.amber[400],
                  width: 100,
                  height: 100,
                  child: Text(
                    '${date.day}',
                    style: TextStyle().copyWith(fontSize: 16.0),
                  ),
                );
              },
              markersBuilder: (context, date, events, holidays) {
                final children = <Widget>[];

                if (events.isNotEmpty) {
                  children.add(
                    Positioned(
                      right: 1,
                      bottom: 1,
                      child: _buildEventsMarker(date, events),
                    ),
                  );
                }


                return children;
              },

            ),
            ),
            const SizedBox(height: 20.0),
            details?_buildEventList():Expanded(child: Column(
              children: <Widget>[
                new DetailWidget(total: total),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(children: <Widget>[Expanded(child: Center(child:Text("Commission",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),))),Expanded(child: Center(child:Text("\$${commission.toStringAsFixed(2)}")))],),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(children: <Widget>[Expanded(child: Center(child:Text("Bonus",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),))),Expanded(child: Center(child:Text("\$${bonus.toStringAsFixed(2)}")))],),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(children: <Widget>[Expanded(child: Center(child:Text("Spiff",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),))),Expanded(child: Center(child:Text("\$${spiff.toStringAsFixed(2)}")))],),
                )
              ],
            ),)

          ],
        ),
    );
  }
}



class DetailWidget extends StatelessWidget {
  const DetailWidget({
    Key key,
    @required this.total,
  }) : super(key: key);

  final double total;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(children: <Widget>[Expanded(child: Center(child:Text("Month to date",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),))),Expanded(child: Center(child:Text("\$${total.toStringAsFixed(2)}")))],),
    );
  }
}
