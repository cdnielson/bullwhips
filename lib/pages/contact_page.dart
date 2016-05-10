import 'package:angular2/core.dart';

@Component(selector: 'contact-page', templateUrl: 'contact_page.html')
class ContactPage {
  String get pathToContact => "contact.php";
}