import 'package:angular2/core.dart';
import 'package:bullwhips/model/product.dart';
import 'package:bullwhips/services/products_service.dart';
import 'dart:html';
import 'dart:convert';
import 'dart:async';
import 'package:bullwhips/services/cart.dart';
import 'package:angular2/router.dart';
import 'package:bullwhips/model/menu.dart';
import 'package:bullwhips/services/menu_service.dart';

@Component(selector: 'cart-page', templateUrl: 'cart_page.html')
class CartPage {
  ProductsService productsService;
  String get paymentsPHP => "payments.php";
  static const String PATH_TO_PAYPAL_PHP = "php/order_place.php";
  static const String PATH_TO_DB_PHP = "php/order_to_db.php";
  String orderId;
  String firstName;
  String lastName;
  String email;
  bool hideProcessing = true;
  Cart cart;
  int subtotal;
  int shipping;
  int total;
  //List<Product> cartItems = [];
  Router _router;
  MenuService menu;

  @Output() EventEmitter page = new EventEmitter<String>();

  CartPage(ProductsService this.productsService, Cart this.cart, Router this._router);

  /*ngDoCheck() {
    cartItems = cart.items;
    print(cartItems);
  }*/

  handleQuantityDropdown(description, value) {
    Product currentItem = cart.items.where((Product element) => element.description == description).first;
    currentItem.quantity = int.parse(value);
    currentItem.subtotal = currentItem.quantity * currentItem.price;
    cart.calculatePrice();
    print(value);
  }

  removeItem(item) {
    cart.removedFromCart(item);
    //inCart = cart.cart;
    cart.calculatePrice();
  }

  payIt() {
    if(firstName.isEmpty || lastName.isEmpty || email.isEmpty) {
      return;
    }
    if (cart.total > 0) {
      var data =
      {"customer":{
        "firstName":firstName,
        "lastName":lastName,
        "email":email
      },
        "amounts":{
          "currency":"USD",
          "shipping":cart.shipping,
          "total":cart.total
        },
        "items_list":[]};
      for (Product p in cart.items) {
        data["items_list"].add(
            {"name":p.description,
              "quantity":p.quantity,
              "price":p.price}
        );
      }

      var datasend = JSON.encode(data);

      hideProcessing = false;
      HttpRequest.request(PATH_TO_DB_PHP, method: 'POST', mimeType: 'application/json', sendData: datasend).catchError((obj) {
        //print(obj);
      }).then((val) {
        print(val.responseText);
        orderId = val.responseText;
        window.location.replace("$PATH_TO_PAYPAL_PHP?order_amount=${cart.total}&order_id=$orderId");
      }, onError: (e) => print("error"));
    } else {

    }
  }

  continueShopping() {
    _router.navigate(['WHIPS', {'id': 'whips-page'}]);
    for (Menu m in menu.items) {
      m.style = "white";
    };
    menu.items.where((Menu element) => element.title == "WHIPS").first.style = "pink";
  }
}