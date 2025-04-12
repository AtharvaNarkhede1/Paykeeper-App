import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'add_person_page.dart';
import 'person_details_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> persons = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString('persons');
    if (data != null) {
      setState(() {
        persons = List<Map<String, dynamic>>.from(json.decode(data));
      });
    }
  }

  _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('persons', json.encode(persons));
  }

  _addPerson(String name) {
    setState(() {
      persons.add({'name': name, 'balance': 0, 'transactions': []});
      _saveData();
    });
  }

  _updatePerson(String name, int amount, String description, bool isGiven) {
    setState(() {
      int index = persons.indexWhere((person) => person['name'] == name);
      if (index != -1) {
        if (isGiven) {
          persons[index]['balance'] += amount;
        } else {
          persons[index]['balance'] -= amount;
        }
        persons[index]['transactions'].add({'amount': amount, 'description': description, 'isGiven': isGiven});
        _saveData();
      }
    });
  }

  _deletePerson(int index) {
    setState(() {
      persons.removeAt(index);
      _saveData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("PayKeeper")),
      body: ListView.builder(
        itemCount: persons.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(persons[index]['name']),
            subtitle: Text("Balance: ₹${persons[index]['balance']}"),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deletePerson(index),
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => PersonDetailsPage(
                  person: persons[index],
                  onUpdate: _updatePerson,
                ),
              ));
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => AddPersonPage(onAdd: _addPerson),
          ));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}