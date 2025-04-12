import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PersonDetailsPage extends StatefulWidget {
  final Map<String, dynamic> person;
  final Function(String, int, String, bool) onUpdate;

  PersonDetailsPage({required this.person, required this.onUpdate});

  @override
  _PersonDetailsPageState createState() => _PersonDetailsPageState();
}

class _PersonDetailsPageState extends State<PersonDetailsPage> {
  TextEditingController amountController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  // Add a new transaction with animation
  _addTransaction(bool isGiven) {
    int amount = int.tryParse(amountController.text) ?? 0;
    String description = descriptionController.text;

    if (amount > 0 && description.isNotEmpty) {
      widget.onUpdate(widget.person['name'], amount, description, isGiven);
      amountController.clear();
      descriptionController.clear();
      _listKey.currentState?.insertItem(0);
      setState(() {});
    }
  }

  // Edit an existing transaction
  _editTransaction(int index) {
    var transaction = widget.person['transactions'][index];
    amountController.text = transaction['amount'].toString();
    descriptionController.text = transaction['description'];

    showDialog(
      context: context,
      builder: (context) {
        return FadeTransition(
          opacity: AlwaysStoppedAnimation(1.0),
          child: AlertDialog(
            title: Text("Edit Transaction"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: amountController, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: "Amount")),
                TextField(controller: descriptionController, decoration: InputDecoration(labelText: "Description")),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {
                    widget.person['transactions'][index] = {
                      'amount': int.tryParse(amountController.text) ?? transaction['amount'],
                      'description': descriptionController.text,
                      'isGiven': transaction['isGiven'],
                    };
                  });
                  Navigator.pop(context);
                },
                child: Text("Save"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancel"),
              ),
            ],
          ),
        );
      },
    );
  }

  // Delete a transaction with fade-out effect
  // Delete a transaction with fade-out effect
  _deleteTransaction(int index) {
    final removedItem = widget.person['transactions'][index];

    _listKey.currentState?.removeItem(
      index,
          (context, animation) => FadeTransition(
        opacity: animation,
        child: ListTile(
          title: Text(removedItem['description']),
          trailing: Text(
            "₹${removedItem['amount']}",
            style: TextStyle(color: removedItem['isGiven'] ? Colors.green : Colors.red),
          ),
        ),
      ),
      duration: Duration(milliseconds: 300),
    );

    widget.person['transactions'].removeAt(index);
    setState(() {}); // Ensure UI updates
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.person['name'])),
      body: Column(
        children: [
          AnimatedSwitcher(
            duration: Duration(milliseconds: 500),
            child: Text(
              "Total Balance: ₹${widget.person['balance']}",
              key: ValueKey(widget.person['balance']),
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: AnimatedList(
              key: _listKey,
              initialItemCount: widget.person['transactions'].length,
              itemBuilder: (context, index, animation) {
                var transaction = widget.person['transactions'][index];
                return FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(
                    scale: animation,
                    child: ListTile(
                      title: Text(transaction['description']),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "₹${transaction['amount']}",
                            style: TextStyle(color: transaction['isGiven'] ? Colors.green : Colors.red),
                          ),
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _editTransaction(index),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteTransaction(index),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(controller: amountController, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: "Amount")),
                TextField(controller: descriptionController, decoration: InputDecoration(labelText: "Description")),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => _addTransaction(true),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      child: Text("Given"),
                    ),
                    ElevatedButton(
                      onPressed: () => _addTransaction(false),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: Text("Taken"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
