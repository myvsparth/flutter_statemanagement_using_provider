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
