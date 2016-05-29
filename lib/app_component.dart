// Copyright (c) 2016, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/core.dart';
import 'package:bullwhips/model/product.dart';
import 'package:bullwhips/model/menu.dart';
import 'dart:html';
import 'dart:convert';
import 'dart:async';
//import 'dart:io';
//import 'package:firebase/firebase.dart' as FB;
import 'package:bullwhips/pages/contact_page.dart';
import 'package:bullwhips/pages/home_page.dart';
import 'package:bullwhips/pages/about_page.dart';
import 'package:bullwhips/pages/whips_page.dart';
import 'package:bullwhips/pages/accessories_page.dart';
import 'package:bullwhips/pages/cart_page.dart';
import 'package:bullwhips/services/products_service.dart';
import 'package:bullwhips/services/cart.dart';
import 'package:bullwhips/services/menu_service.dart';
import 'package:angular2/router.dart';

@Component(selector: 'my-app', providers: const [ProductsService, Cart, MenuService])
@View(templateUrl: 'app_component.html',
    directives: const [ROUTER_DIRECTIVES] //, ContactPage, HomePage, AboutPage, WhipsPage, AccessoriesPage, CartPage
    )
@RouteConfig(const [
  const Route(path: '/', name: 'HOME', component: HomePage),
  const Route(path: '/about-page', name: 'ABOUT', component: AboutPage),
  const Route(path: '/contact-page', name: 'CONTACT', component: ContactPage),
  const Route(path: '/whips-page', name: 'WHIPS', component: WhipsPage),
  const Route(path: '/accessories-page', name: 'ACCESSORIES', component: AccessoriesPage),
  const Route(path: '/cart-page', name: 'CART', component: CartPage)
])
class AppComponent {
  String page = "WHIPS";
  String tenOrMore = "one";
  String get pathToLogo => "images/title.png";
  DivElement content;
  bool menuOpened = false;
  String zoomImage = "";
  bool hideZoom = true;
  ProductsService productsService;
  MenuService menu;
  List<Menu> topMenu = [];
  List<Menu> sideMenu = [];

  AppComponent(ProductsService this.productsService, MenuService this.menu) {

    menu.addToMenu("HOME", "white", "top");
    menu.addToMenu("ABOUT", "white", "top");
    menu.addToMenu("CONTACT", "white", "top");
    menu.addToMenu("CART", "white", "top");
    menu.addToMenu("WHIPS", "pink", "side");
    menu.addToMenu("ACCESSORIES", "white", "side");

    topMenu = menu.items.where((Menu element) => element.location == "top").toList();
    sideMenu = menu.items.where((Menu element) => element.location == "side").toList();
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

  openMenu() {
    menuOpened = true;
  }
  zoom(image) {
    zoomImage = "$productsService.pathToImages$image";
    hideZoom = false;
  }
  closeZoom() {
    hideZoom = true;
  }


}
