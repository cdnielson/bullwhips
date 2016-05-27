import 'package:angular2/core.dart';
import 'package:bullwhips/model/product.dart';
import 'package:bullwhips/services/products_service.dart';
import 'dart:html';
import 'dart:convert';
@Component(selector: 'cart-page', templateUrl: 'cart_page.html')
class CartPage {
  ProductsService productsService;
  List<Product> cart = [];
  int subtotal = 0;
  int shipping = 0;
  int total = 0;
  String get paymentsPHP => "payments.php";
  static const String PATH_TO_PAYPAL_PHP = "php/order_place.php";
  static const String PATH_TO_DB_PHP = "php/order_to_db.php";
  String orderId;
  String firstName;
  String lastName;
  String email;
  bool hideProcessing = true;
  @Output() EventEmitter page = new EventEmitter<String>();
  CartPage(ProductsService this.productsService);

  addToCart(item) {
    Product currentItem = productsService.productList.where((Product element) => element.description == item).first;
    if(!checkIfItemIsInCart(currentItem)) {
      cart.add(currentItem);
      calculatePrice();
      page.emit("CART");
      // TODO verify this works
      handleMenu(page, "top");
    }
  }
  bool checkIfItemIsInCart(Product item) {
    for(var c in cart) {
      if (c.description == item.description) {
        return true;
      }
    }
    return false;
  }
  handleQuantityDropdown(description, value) {
    Product currentItem = cart.where((Product element) => element.description == description).first;
    currentItem.quantity = int.parse(value);
    currentItem.subtotal = currentItem.quantity * currentItem.price;
    calculatePrice();
    print(value);
  }
  calculatePrice() {
    subtotal = 0;
    for (Product p in cart) {
      subtotal += p.subtotal;
    }
    if (subtotal >= 500 || subtotal == 0) {
      shipping = 0;
    } else {
      shipping = 7;
    }
    total = shipping + subtotal;
  }
  removeItem(item) {
    cart.removeWhere((Product element) => element.description == item);
    calculatePrice();
  }

  payIt() {
    if(firstName.isEmpty || lastName.isEmpty || email.isEmpty) {
      return;
    }
    if (total > 0) {
      var data =
      {"customer":{
        "firstName":firstName,
        "lastName":lastName,
        "email":email
      },
        "amounts":{
          "currency":"USD",
          "shipping":shipping,
          "total":total
        },
        "items_list":[]};
      for (Product p in cart) {
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
        window.location.replace("$PATH_TO_PAYPAL_PHP?order_amount=$total&order_id=$orderId");
      }, onError: (e) => print("error"));
    } else {

    }
  }
}