import 'package:angular2/core.dart';
import 'package:bullwhips/services/products_service.dart';
import 'package:bullwhips/services/cart.dart';
import 'package:bullwhips/model/product.dart';
import 'package:angular2/router.dart';
import 'package:bullwhips/services/menu_service.dart';
import 'package:bullwhips/model/menu.dart';
import 'dart:async';

@Component(selector: 'custom-page', templateUrl: 'custom_page.html')
class CustomPage {
  ProductsService productsService;
  @Output() EventEmitter zoomIt = new EventEmitter();
  Cart cart;
  @Output() EventEmitter page = new EventEmitter();
  Router _router;
  MenuService menu;
  List lengths = ["10", "12"];
  String length = "6";
  String color = "Natural";
  String endcolor = "Natural";
  String ringcolor = "Natural";
  String plaits = "12";
  int lengthCost = 250;
  int plaitsCost = 0;
  int cost = 250;
  String notes;

  CustomPage(ProductsService this.productsService, Cart this.cart, Router this._router, MenuService this.menu);

  addToCart(item) {
    Product currentItem = productsService.productList.where((Product element) => element.description == item).first;
    cart.addToCart(currentItem);
    /*for (var i in cart.items) {
      print(i.description);
    }*/
    page.emit("CART");
    routeIt();
  }

  routeIt() {
    _router.navigate(['Cart', {'id': 'cart-page'}]);
    for (Menu m in menu.items) {
      m.style = "white";
    };
    menu.items.where((Menu element) => element.title == "Cart").first.style = "pink";
  }

  handleCustom() {
    print(length);
    print(color);
    print(endcolor);
    print(ringcolor);
    print(plaits);
    print(cost);
    cart.addToCart(new Product("$plaits Plait", "Custom","Color: $color, End knot: $endcolor, Ring knot: $ringcolor", "Kangaroo Leather", "$length Foot", "none", cost, notes));
    routeIt();
  }

  handleLengthCost() {
    Timer.run(calculateLengthCost);
  }
  handlePlaitsCost() {
    Timer.run(calculatePlaitsCost);
  }

  calculatePlaitsCost() {
    switch(plaits) {
      case "12": plaitsCost = 0;
        break;
      case "16": plaitsCost = 100;
        break;
      case "20": plaitsCost = 200;
        break;
    }
    calculateCost();
  }

  calculateLengthCost() {
    switch(length) {
      case "6": lengthCost = 250;
        break;
      case "7": lengthCost = 275;
        break;
      case "8": lengthCost = 300;
        break;
      case "9": lengthCost = 400;
        break;
      case "10": lengthCost = 500;
        break;
      case "11": lengthCost = 575;
        break;
      case "12": lengthCost = 650;
        break;
    }
    calculateCost();
  }

  calculateCost() {
    cost = lengthCost + plaitsCost;
  }
}