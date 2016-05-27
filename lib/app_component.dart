// Copyright (c) 2016, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/core.dart';
import 'package:bullwhips/model/product.dart';
import 'package:bullwhips/model/menu.dart';
import 'dart:html';
import 'dart:convert';
import 'dart:async';
//import 'dart:io';
import 'package:firebase/firebase.dart' as FB;
import 'package:bullwhips/pages/contact_page.dart';
import 'package:bullwhips/pages/home_page.dart';
import 'package:bullwhips/pages/about_page.dart';
import 'package:bullwhips/pages/whips_page.dart';
import 'package:bullwhips/pages/accessories_page.dart';
import 'package:bullwhips/pages/cart_page.dart';
import 'package:bullwhips/services/products_service.dart';

@Component(
    selector: 'my-app',
    templateUrl: 'app_component.html',
    directives: const [ContactPage, HomePage, AboutPage, WhipsPage, AccessoriesPage, CartPage],
    providers: const [ProductsService])
class AppComponent {

  String page = "WHIPS";
  String tenOrMore = "one";
  String get pathToLogo => "images/title.png";


  List<Menu> topMenu = [];
  List<Menu> sideMenu = [];
  String zoomImage = "";
  bool hideZoom = true;
  DivElement content;
  bool menuOpened = false;


  AppComponent() {

    topMenu.add(new Menu("HOME", "white"));
    topMenu.add(new Menu("ABOUT", "white"));
    topMenu.add(new Menu("CONTACT", "white"));
    topMenu.add(new Menu("CART", "white"));
    sideMenu.add(new Menu("WHIPS", "pink"));
    sideMenu.add(new Menu("ACCESSORIES", "white"));
    content = querySelector('#content');
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


}
