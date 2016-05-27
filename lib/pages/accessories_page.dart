import 'package:angular2/core.dart';
import 'package:bullwhips/services/products_service.dart';
import 'package:bullwhips/services/cart.dart';
import 'package:bullwhips/model/product.dart';

@Component(selector: 'accessories-page', templateUrl: 'accessories_page.html', providers: const [ProductsService, Cart])
class AccessoriesPage {
  ProductsService productsService;
  @Output() EventEmitter zoomIt = new EventEmitter();
  Cart cart;
  @Output() EventEmitter page = new EventEmitter();

  AccessoriesPage(ProductsService this.productsService, Cart this.cart);

  zoom(image) {
    zoomIt.emit(image);
  }
  addToCart(item) {
    Product currentItem = productsService.productList.where((Product element) => element.description == item).first;
    cart.addToCart(currentItem);
    cart.calculatePrice();
    page.emit("CART");
  }
}