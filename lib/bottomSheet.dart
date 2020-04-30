import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class AddSheet extends StatefulWidget {
  final String displayText;
  final String textFieldValue;
  final String docRef;

  AddSheet({@required this.displayText, this.textFieldValue,this.docRef});
  @override
  _AddSheetState createState() => _AddSheetState();
}

class _AddSheetState extends State<AddSheet> {
  String value;
  final _fireStore =Firestore.instance;
  TextEditingController controller;

  @override
  void initState() {
    // TODO: implement initState
    controller = TextEditingController(text: widget.textFieldValue);
    super.initState();
    print(controller.text);
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              widget.displayText,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextField(
              controller: controller,
              textAlign: TextAlign.center,
              textAlignVertical: TextAlignVertical.bottom,
              onChanged: (text){
                value=text;
                print(widget.displayText);
                print(value);
                print(widget.docRef);
              },
            ),
            SizedBox(
              height: 10,
            ),
            FlatButton(
              color: Colors.green,
              onPressed: ()async {
                widget.textFieldValue==null ?
                  _fireStore.collection('items').add({'value': value,})
                :
                  _fireStore.collection('items').document(widget.docRef).updateData({'value': value}).catchError((e){print(e);});
                controller.clear();
                Navigator.pop(context);
              },
              child: Text("Add"),
            ),
          ],
        ),
      ),
    );
  }
}
