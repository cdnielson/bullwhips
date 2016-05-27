import 'package:angular2/core.dart';
import 'package:bullwhips/services/products_service.dart';

@Component(selector: 'whips-page', templateUrl: 'whips_page.html')
class WhipsPage {
  ProductsService productsService;

  WhipsPage(ProductsService this.productsService);
  // TODO pass in data
}