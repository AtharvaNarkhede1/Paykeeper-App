import 'package:flutter/material.dart';

class AddPersonPage extends StatefulWidget {
  final Function(String) onAdd;

  AddPersonPage({required this.onAdd});

  @override
  _AddPersonPageState createState() => _AddPersonPageState();
}

class _AddPersonPageState extends State<AddPersonPage> {
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Person")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: nameController, decoration: InputDecoration(labelText: "Person Name")),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  widget.onAdd(nameController.text);
                  Navigator.pop(context);
                }
              },
              child: Text("Add"),
            ),
          ],
        ),
      ),
    );
  }
}
