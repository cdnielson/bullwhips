import 'package:angular2/core.dart';
import 'package:bullwhips/model/menu.dart';

@Injectable()
class MenuService {
  List<Menu> _items = [];

  List<Menu> get items {
    return _items;
  }

  addToMenu(String title, String style, String location, String icon) {
    _items.add(new Menu(title, style, location, icon));
  }
}