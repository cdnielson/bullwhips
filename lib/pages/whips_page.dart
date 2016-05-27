import 'package:angular2/core.dart';
import 'package:bullwhips/services/products_service.dart';
import 'package:bullwhips/services/cart.dart';
import 'package:bullwhips/model/product.dart';

@Component(selector: 'whips-page', templateUrl: 'whips_page.html')
class WhipsPage {
  ProductsService productsService;
  @Output() EventEmitter zoomIt = new EventEmitter();
  Cart cart;
  @Output() EventEmitter page = new EventEmitter();

  WhipsPage(ProductsService this.productsService, Cart this.cart);

  zoom(image) {
    zoomIt.emit(image);
  }

  addToCart(item) {
    Product currentItem = productsService.productList.where((Product element) => element.description == item).first;
    cart.addToCart(currentItem);
    /*for (var i in cart.items) {
      print(i.description);
    }*/
    page.emit("CART");
  }
}