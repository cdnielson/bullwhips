import 'package:angular2/core.dart';
import 'package:bullwhips/services/products_service.dart';
import 'package:bullwhips/services/cart.dart';
import 'package:bullwhips/model/product.dart';
import 'package:angular2/router.dart';
import 'package:bullwhips/services/menu_service.dart';
import 'package:bullwhips/model/menu.dart';

@Component(selector: 'custom-page', templateUrl: 'custom_page.html')
class CustomPage {
  ProductsService productsService;
  @Output() EventEmitter zoomIt = new EventEmitter();
  Cart cart;
  @Output() EventEmitter page = new EventEmitter();
  Router _router;
  MenuService menu;

  CustomPage(ProductsService this.productsService, Cart this.cart, Router this._router, MenuService this.menu);

  zoom(image) {
    // TODO get zoom working (probably local to this and accessories components)
    zoomIt.emit(image);
  }

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
    _router.navigate(['CART', {'id': 'cart-page'}]);
    for (Menu m in menu.items) {
      m.style = "white";
    };
    menu.items.where((Menu element) => element.title == "CART").first.style = "pink";
  }
}