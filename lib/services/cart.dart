import 'package:bullwhips/model/product.dart';
import 'package:angular2/angular2.dart';

@Injectable()
class Cart {
  List<Product> _items = [];
  int _subtotal = 0;
  int _shipping = 0;
  int _total = 0;
  int _cartAmount = 0;

  List<Product> get items {
    return _items;
  }
  int get subtotal {
    return _subtotal;
  }
  int get shipping {
    return _shipping;
  }
  int get total {
    return _total;
  }
  int get cartAmount {
    return _cartAmount;
  }

  addToCart(Product product) {
    /*if(!checkIfItemIsInCart(product)) {
      print(product.length);*/
      _items.add(product);
      _cartAmount = _items.length;
      calculatePrice();
//    }
  }
  removedFromCart(item) {
    _items.removeWhere((Product element) => element.description == item);
  }

  bool checkIfItemIsInCart(Product item) {
    for(var c in _items) {
      if (c.description == item.description) {
        return true;
      }
    }
    return false;
  }

  calculatePrice() {
    _subtotal = 0;
    for (Product p in _items) {
      _subtotal += p.subtotal;
    }
    if (_subtotal >= 500 || _subtotal == 0) {
      _shipping = 0;
    } else {
      _shipping = 7;
    }
    _total = _shipping + _subtotal;
  }
}