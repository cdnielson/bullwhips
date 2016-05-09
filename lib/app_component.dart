// Copyright (c) 2016, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/core.dart';
import 'package:bullwhips/model/item.dart';
import 'package:bullwhips/model/product.dart';
import 'dart:html';
import 'dart:convert';

@Component(selector: 'my-app', templateUrl: 'app_component.html')
class AppComponent {
  static const String PATH_TO_PRODUCTS = "data/products.json";
  String page = "home";
  String get pathToLogo => "images/title.png";
  List<Item> cart = [];
  List<Product> whips = [];
  List<Product> accessories = [];

  AppComponent() {
    HttpRequest.getString(PATH_TO_PRODUCTS).then(parseProducts);
  }
  parseProducts(data) {
    List<map> mapList = JSON.decode(data);
    List<Product> productList = mapList.map((Map element) => new Product.fromMap(element)).toList();
    whips = productList.where((Product element) => element.category == "whip").toList();
    accessories = productList.where((Product element) => element.category == "accessory").toList();
  }
  handleTopMenu(page) {
    this.page = page;
  }
  addToCart(item) {
    if(!checkIfItemIsInCart(item)) {
      cart.add(new Item(item, 1));
      page = "cart";
    }
  }
  bool checkIfItemIsInCart(item) {
    for(var c in cart) {
      if (c.name == item) {
      return true;
      }
    }
    return false;
  }
  handleQuantityDropdown(name, value) {
    Item currentItem = cart.where((Item element) => element.name == name).first;
    currentItem.quantity = int.parse(value);
    print(value);
  }
}
