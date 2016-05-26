// Copyright (c) 2016, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/core.dart';
import 'package:bullwhips/model/product.dart';
import 'package:bullwhips/model/menu.dart';
import 'dart:html';
import 'dart:convert';
import 'dart:async';
//import 'dart:io';
import 'package:bullwhips/pages/contact_page.dart';
import 'package:firebase/firebase.dart' as FB;

@Component(
    selector: 'my-app',
    templateUrl: 'app_component.html',
    directives: const [ContactPage])
class AppComponent {
  static const String PATH_TO_PRODUCTS = "data/products.json";
  String page = "WHIPS";
  String tenOrMore = "one";
  String get pathToLogo => "images/title.png";
  String get pathToImages => "images/";
  String get pathToThumbnails => "images/200w_thumbnails/";
  List<Product> cart = [];
  List<Product> whips = [];
  List<Product> accessories = [];
  int subtotal = 0;
  int shipping = 0;
  int total = 0;
  List<Product> productList = [];
  List<Menu> topMenu = [];
  List<Menu> sideMenu = [];
  String zoomImage = "";
  bool hideZoom = true;
  DivElement content;
  bool menuOpened = false;
  String get paymentsPHP => "payments.php";
  static const String PATH_TO_PAYPAL_PHP = "php/order_place.php";
  static const String PATH_TO_DB_PHP = "php/order_to_db.php";
  bool hideProcessing = true;
  String orderId;
  String firstName;
  String lastName;
  String email;

  AppComponent() {
    HttpRequest.getString(PATH_TO_PRODUCTS).then(parseProducts);
    topMenu.add(new Menu("HOME", "white"));
    topMenu.add(new Menu("ABOUT", "white"));
    topMenu.add(new Menu("CONTACT", "white"));
    topMenu.add(new Menu("CART", "white"));
    sideMenu.add(new Menu("WHIPS", "pink"));
    sideMenu.add(new Menu("ACCESSORIES", "white"));
    content = querySelector('#content');
  }
  parseProducts(data) {
    List<Map> mapList = JSON.decode(data);
    productList = mapList.map((Map element) => new Product.fromMap(element)).toList();
    whips = productList.where((Product element) => element.category == "whip").toList();
    accessories = productList.where((Product element) => element.category == "accessory").toList();
  }
  handleMenu(page, menu) {
    this.page = page;
    for (Menu t in topMenu) {
      t.style = "white";
    }
    for (Menu t in sideMenu) {
      t.style = "white";
    }
    if (menu == 'top') {
      topMenu.where((Menu element) => element.title == page).first.style = "pink";
    }
    if (menu == 'side') {
      sideMenu.where((Menu element) => element.title == page).first.style = "pink";
    }
    //scroll();
    menuOpened = false;
  }
  scroll() {
    int location = content.offsetTop;
    window.scrollTo(0, location);
  }
  addToCart(item) {
    Product currentItem = productList.where((Product element) => element.description == item).first;
    if(!checkIfItemIsInCart(currentItem)) {
      cart.add(currentItem);
      calculatePrice();
      page = "CART";
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
  zoom(image) {
    zoomImage = "$pathToImages$image";
    hideZoom = false;
  }
  closeZoom() {
    hideZoom = true;
  }
  continueShopping() {
    page = "WHIPS";
  }
  openMenu() {
    menuOpened = true;
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
