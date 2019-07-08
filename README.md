# flutter_statemanagement_using_provider

State Management using Provider in Flutter

## Introduction:
First and basic question came to anyone’s mind that what is state management and why we need it. I would like to explain you briefly giving you basic example what and why we need it and how the provider handle state management. So tie your seat belt and let’s dive in to it. This concept is very important to get command in flutter programming so relax and more get focused while reading this article.

## Brief Explanation with Real Example:
Scenario 1: Now, everyone of you have created a list of customer or product in any other programming language. Now you have added new customer or product dynamically in the list so what you need is to refresh the list to view newly added item into list. So what you are doing is getting the whole list again to get new list. It is worthless to fetch the whole list again and create the UI again. It reduces the performance of the app so state management is a concept to handle such situation to improve the performance.

Scenario 2: Now, think that you have list in page-1 and you have added new item in page-2 so in page-1 new added items will not be reflected until you fetch the list again. So Provider will helps you to manage such condition where any update in list will be notified every where it is used and automatically updated with changes as and when needed.

You will note during further discussion about ChangeNotifier, notifyListeners, ChangeNotifierProvider, Consumer etc this all are the part of Provider to manage above scenario.

So let’s understand it by implementing above example.

Plugin we need: provider

## Steps:
1. Create New Project in flutter. I have created with name “flutter_statemanagement_using_provider”.

2. Add Dependency in pubspec.yaml file
```
dependencies:
 flutter:
   sdk: flutter
 cupertino_icons: ^0.1.2
 provider: ^3.0.0+1
```

3. Now create one folder under lib folder and name it as providers. Providers folder will contain all the data related files. Now create one file under providers and name it as customers.dart. Below is the code of the customers.dart file. Please read the comments in the code it will give you detailed explanation.

```
// Package for ChangeNotifier class
import 'package:flutter/foundation.dart';

class CustomerList with ChangeNotifier {
  // ChangeNotifier : will provide a notifier for any changes in the value to all it's listeners
  List<Customer> customers = [];
  CustomerList({this.customers});

  getCustomers() => customers;
  void addCustomer(Customer customer) {
    customers.add(customer);
    notifyListeners(); // Notify all it's listeners about update. If you comment this line then you will see that new added items will not be reflected in the list.
  }

  void removeCustomer(int index) {
    customers.removeAt(index);
    notifyListeners();
  }
}

class Customer {
  // Structure for Customer Data Storage
  String name;
  int age;
  Customer({this.name, this.age});
}
```

4. Now create another folder under lib named as pages this folder will contain all the pages of the app. Now, create a file under this folder named as new_customer.dart. We are going to create a form to add new customers. Below is the code of the new_customer.dart file. I have created a form to get customer name and age. Please read the comments in the code it will give you detailed explanation. 

```
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statemanagement_using_provider/providers/customers.dart';

class NewCustomer extends StatefulWidget {
  final customerList; // stores object of listener passed from calling class
  NewCustomer({Key key, this.customerList}) : super(key: key);

  @override
  _NewCustomerState createState() => _NewCustomerState();
}

class _NewCustomerState extends State<NewCustomer> {
  final GlobalKey<FormState> _formStateKey = GlobalKey<FormState>();
  String _name;
  String _age;

  final _nameController = TextEditingController(text: '');
  final _ageController = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Customer"),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            Form(
              key: _formStateKey,
              autovalidate: true,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10, bottom: 5),
                    child: TextFormField(
                      onSaved: (value) {
                        _name = value;
                      },
                      controller: _nameController,
                      decoration: InputDecoration(
                        focusedBorder: new UnderlineInputBorder(
                            borderSide: new BorderSide(
                          width: 2,
                          style: BorderStyle.solid,
                        )),
                        labelText: "Customer Name",
                        icon: Icon(Icons.account_box, color: Colors.green),
                        fillColor: Colors.white,
                        labelStyle: TextStyle(
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10, bottom: 5),
                    child: TextFormField(
                      onSaved: (value) {
                        _age = value;
                      },
                      keyboardType: TextInputType.phone,
                      inputFormatters: <TextInputFormatter>[
                        WhitelistingTextInputFormatter.digitsOnly
                      ],
                      controller: _ageController,
                      decoration: InputDecoration(
                        focusedBorder: new UnderlineInputBorder(
                            borderSide: new BorderSide(
                                color: Colors.green,
                                width: 2,
                                style: BorderStyle.solid)),
                        labelText: "Age",
                        icon: Icon(
                          Icons.phone_android,
                          color: Colors.green,
                        ),
                        fillColor: Colors.white,
                        labelStyle: TextStyle(
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  color: Colors.green,
                  child: Text(
                    ('SAVE'),
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    _formStateKey.currentState.save();
                    // widget : is used to access property of parent stateful class
                    widget.customerList.addCustomer(
                        Customer(name: _name, age: int.parse(_age)));
                    Navigator.of(context).pop();
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
```

5. Now, in main.dart we have created a list of customers. Please note that in main.dart file we have implemented listener and that is the important part of this article so carefully read the comment in the code it will explain you the thing how it works.

```
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
```

## Conclusion:
State Management is one of the key parts of performance improvement of the app and Provider is the best approach is to achieve it. Previously state will be managed by scoped models and provider is developed by community not by google but provider is highly encouraged by google to use it.

Git Repo: https://github.com/myvsparth/flutter_statemanagement_using_provider

Related to Tags: Flutter, State Management, Provider