// Copyright (c) 2016, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/core.dart';
import 'package:bullwhips/model/product.dart';
import 'package:bullwhips/model/menu.dart';
import 'dart:html';
import 'dart:convert';
import 'dart:async';
//import 'dart:io';
import 'package:bul'
    'lwhips/pages/contact_page.dart';

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

  AppComponent() {
    HttpRequest.getString(PATH_TO_PRODUCTS).then(parseProducts);
    topMenu.add(new Menu("HOME", "black"));
    topMenu.add(new Menu("ABOUT", "gray"));
    topMenu.add(new Menu("CONTACT", "gray"));
    topMenu.add(new Menu("CART", "gray"));
    sideMenu.add(new Menu("WHIPS", "gray"));
    sideMenu.add(new Menu("ACCESSORIES", "gray"));
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
      t.style = "gray";
    }
    for (Menu t in sideMenu) {
      t.style = "gray";
    }
    if (menu == 'top') {
      topMenu.where((Menu element) => element.title == page).first.style = "black";
    }
    if (menu == 'side') {
      sideMenu.where((Menu element) => element.title == page).first.style = "black";
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
    /*Map testData = {
      "USER": "cdnielson@folkprophet.com",
      "PWD": "Bryony1!",
      "SIGNATURE": "",
      "METHOD": "SetExpressCheckout",
      "VERSION": "98",
      "PAYMENTREQUEST_0_AMT": "500",
      "PAYMENTREQUEST_0_CURRENCYCODE": "USD",
      "PAYMENTREQUEST_0_PAYMENTACTION": "SALE",
      "cancleUrl": "http://www.folkprophet.com/whips/success.html",
      "returnUrl": "http://www.folkprophet.com/cancel.html"
    };
    testJsonData = JSON.encode(testData);
    print(testJsonData);
      */

    Map keys = {
      'username':'AUfYsD88MkBeGv4kz78fHRyg_-OKW1WndNs1VioiWWpcKaWdrtjMal3rARDPiKiu676fOlB1lFvBef-I',
      'password':'EBPhXA4_J9UCk5V2CBlqvJB9y8IFJmyO72Fda-tc_AVeSun0jvQ8wfkUVFkFl8x2W1v9xQCQXRDGbo-D'
    };
    print("here");

//    Found: request(url, method, withCredentials, responseType, mimeType, requestHeaders, sendData, onProgress

      HttpRequest.request(
        'https://api.sandbox.paypal.com/v1/oauth2/token',
        method: 'POST',
        withCredentials: true,
        mimeType: 'application/x-www-form-urlencoded',
        sendData: keys
        ).catchError((obj) {
      //print(obj);
    }).then((HttpRequest val) {
      HttpResponse res = val.response;
      print(val.responseText);
      makePayment(val.responseText);
    }, onError: (e) => print("error"));


/*    curl -v https://api.sandbox.paypal.com/v1/oauth2/token \
    -H "Accept: application/json" \
    -H "Accept-Language: en_US" \
    -u "EOJ2S-Z6OoN_le_KS1d75wsZ6y0SFdVsY9183IvxFyZp:EClusMEUk8e9ihI7ZdVLF5cZ6y0SFdVsY9183IvxFyZp" \
    -d "grant_type=client_credentials"*/

  }
  makePayment(data) {
    print(data);
    return;
    Map datatosend = {
      "intent":"sale",
      "redirect_urls":{
        "return_url":"http://example.com/your_redirect_url.html",
        "cancel_url":"http://example.com/your_cancel_url.html"
      },
      "payer":{
        "payment_method":"paypal"
      },
      "transactions":[
        {
          "amount":{
            "total":"7.47",
            "currency":"USD"
          }
        }
      ]
    };
    HttpRequest.request('https://api.sandbox.paypal.com/v1/payments/payment', method: 'POST', Authorization: 'Bearer Access-Token', mimeType: 'application/json', sendData: datatosend).catchError((obj) {
      //print(obj);
    }).then((HttpRequest val) {
      print(val.responseText);
    }, onError: (e) => print("error"));

  }
}
