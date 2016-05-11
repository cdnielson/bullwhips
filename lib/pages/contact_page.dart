import 'package:angular2/core.dart';
import 'dart:html';
import 'dart:convert';
import 'package:intl/intl.dart';

@Component(selector: 'contact-page', templateUrl: 'contact_page.html')
class ContactPage {
  String get pathToContact => "contact.php";
  DateTime now = new DateTime.now();
  String date;
  String firstName;
  String lastName;
  String email;
  String phone;
  String message;
  String page = "contact";

  ContactPage() {
    DateFormat dateFormatter = new DateFormat("MM-dd-yyyy");
    date = dateFormatter.format(now);
  }

  sendMessage() {
    var data =
    {
    "date":date,
    "firstName":firstName,
    "lastName":lastName,
    "email":email,
    "phone":phone,
    "message":message
    };
    var dataToSend = JSON.encode(data);

    HttpRequest.request(pathToContact, method: 'POST', mimeType: 'application/json', sendData: dataToSend).catchError((obj) {
      //print(obj);
    }).then((HttpRequest val) {
      print(val.responseText);
      page = "messageSent";
    }, onError: (e) => print("error"));
  }
}