import 'package:angular2/angular2.dart';
import 'dart:html';
import 'dart:convert';
import 'package:bullwhips/model/product.dart';

@Injectable()
class ProductsService {
  static const String PATH_TO_PRODUCTS = "data/products.json";
  String get pathToImages => "images/";
  String get pathToThumbnails => "images/200w_thumbnails/";
  List<Product> _productList = [];
  List<Product> _whips = [];
  List<Product> _accessories = [];

  List<Product> get productList {
    return _productList;
  }
  List<Product> get whips {
    return _whips;
  }
  List<Product> get accessories {
    return _accessories;
  }

  ProductsService() {
    HttpRequest.getString(PATH_TO_PRODUCTS).then(parseProducts);
  }

  parseProducts(data) {
    List<Map> mapList = JSON.decode(data);
    _productList = mapList.map((Map element) => new Product.fromMap(element)).toList();
    _whips = _productList.where((Product element) => element.category == "whip").toList();
    _accessories = _productList.where((Product element) => element.category == "accessory").toList();
  }

}