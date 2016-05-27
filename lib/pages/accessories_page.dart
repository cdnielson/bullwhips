import 'package:angular2/core.dart';
import 'package:bullwhips/services/products_service.dart';

@Component(selector: 'accessories-page', templateUrl: 'accessories_page.html', providers: const [ProductsService])
class AccessoriesPage {
  ProductsService productsService;

  AccessoriesPage(ProductsService this.productsService);
  // TODO pass in data
}