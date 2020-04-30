import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'bottomSheet.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _fireStore = Firestore.instance;
  List<DropdownMenuItem> itemList = [];
  String dropDownValue;

  void updateValue(){
    showModalBottomSheet(context: context, builder: (context)=>Container());
  }


  void getList() async {
    await for (var snapshot in _fireStore.collection("items").snapshots()) {
      itemList.clear();
      for (var message in snapshot.documents) {
        itemList.add(DropdownMenuItem(
          value: message.data["value"].toString(),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onLongPress: (){
              showModalBottomSheet(context: context, builder: (context)=>AddSheet(
                displayText: "Edit value",
                textFieldValue: message.data["value"].toString(),
                docRef: message.documentID,
              ));
            },
            child: Text(
              message.data["value"],
            ),
          ),
        ));

      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Task Submission"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Select items from given list",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Select required item:"),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _fireStore.collection("items").orderBy("value").snapshots(),
                    builder: (context, snapshots) {
                      if (!snapshots.hasData) {
                        CircularProgressIndicator();
                      }
                      return DropdownButton(
                        items: itemList,
                        value: dropDownValue,
                        isExpanded: true,
                        onChanged: (newValue) {
                          setState(() {
                            dropDownValue = newValue;
                          });
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => AddSheet(
              displayText: "ADD Value",
              textFieldValue: null,
            ),
          );
        },
        tooltip: 'Add new item',
        child: Icon(Icons.add),
      ),
    );
  }
}

//
//DropdownButton(
//items: itemList,
//value: dropDownValue,
//onChanged: (newValue){
//setState(() {
//dropDownValue=newValue;
//});
//},
//),
