import 'package:bullwhips/model/product.dart';
import 'package:angular2/angular2.dart';

@Injectable()
class Cart {
  List<Product> _cart = [];
  int _subtotal = 0;
  int _shipping = 0;
  int _total = 0;

  List<Product> get items {
    return _cart;
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

  addToCart(Product product) {
    /*if(!checkIfItemIsInCart(product)) {
      print(product.length);*/
      _cart.add(product);
      for(var c in _cart) {
        print(c.length);
      }
      calculatePrice();
//    }
  }
  removedFromCart(item) {
    _cart.removeWhere((Product element) => element.description == item);
  }

  bool checkIfItemIsInCart(Product item) {
    for(var c in _cart) {
      if (c.description == item.description) {
        return true;
      }
    }
    return false;
  }

  calculatePrice() {
    _subtotal = 0;
    for (Product p in _cart) {
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