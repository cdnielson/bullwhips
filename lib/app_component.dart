// Copyright (c) 2016, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/core.dart';
import 'package:bullwhips/model/product.dart';
import 'package:bullwhips/model/menu.dart';
import 'dart:html';
import 'dart:convert';
import 'package:bullwhips/pages/contact_page.dart';

@Component(
    selector: 'my-app',
    templateUrl: 'app_component.html',
    directives: const [ContactPage])
class AppComponent {
  static const String PATH_TO_PRODUCTS = "data/products.json";
  String page = "HOME";
  String tenOrMore = "one";
  String get pathToLogo => "images/title.png";
  String get pathToImages => "images/";
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

  AppComponent() {
    HttpRequest.getString(PATH_TO_PRODUCTS).then(parseProducts);
    topMenu.add(new Menu("HOME", true));
    topMenu.add(new Menu("ABOUT", false));
    topMenu.add(new Menu("CONTACT", false));
    topMenu.add(new Menu("CART", false));
    sideMenu.add(new Menu("Whips", false));
    sideMenu.add(new Menu("Accessories", false));
  }
  parseProducts(data) {
    List<Map> mapList = JSON.decode(data);
    productList = mapList.map((Map element) => new Product.fromMap(element)).toList();
    whips = productList.where((Product element) => element.category == "whip").toList();
    accessories = productList.where((Product element) => element.category == "accessory").toList();
  }
  handleTopMenu(page) {
    this.page = page;
  }
  addToCart(item) {
    Product currentItem = productList.where((Product element) => element.description == item).first;
    if(!checkIfItemIsInCart(currentItem)) {
      cart.add(currentItem);
      calculatePrice();
      page = "CART";
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
    page = "Whips";
  }
}
