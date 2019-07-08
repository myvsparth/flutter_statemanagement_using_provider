import 'package:flutter/material.dart';
import 'package:flutter_statemanagement_using_provider/pages/new_customer.dart';
import 'package:flutter_statemanagement_using_provider/providers/customers.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // We need to place ChangeNotifierProvider just in parent widget where we need to access the data that we have defined in customers.dart and following is the structure of that.
      home: ChangeNotifierProvider<CustomerList>(
        // initialized CustomerList constructor with default 1 value.
        builder: (_) => CustomerList(
              customers: [
                Customer(name: "Parth Patel", age: 30),
              ],
            ),
        child: MyHomePage(title: 'Provider State Management'),
      ),
      // Now we are able to access customer data in all the child widgets. for that check below classes
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // this is how you can access object of the customer list class
    // there are 2 ways you can access 1.Provider and 2. Consumer(We will look in another article)
    final customerList = Provider.of<CustomerList>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: customerList.getCustomers().length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('${customerList.getCustomers()[index].name}'),
            subtitle: Text('${customerList.getCustomers()[index].age}'),
            trailing: Container(
              width: 50,
              child: Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      // removed customer
                      customerList.removeCustomer(index);
                    },
                  )
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigated to new customer page and passed object of CustomerList so that page can change data of customer list.
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NewCustomer(customerList: customerList)),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
