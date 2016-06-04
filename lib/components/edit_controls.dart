import 'package:angular2/core.dart';
import 'package:bullwhips/services/settings.dart';
import 'package:bullwhips/services/menu_service.dart';

@Component(selector: 'edit-controls', templateUrl: 'edit_controls.html')
class EditControls {
  Settings settings;
  MenuService menu;

  EditControls(Settings this.settings);

  handleFontChange(font) {
    print(font);
    settings.fontStyle = font;
  }

  handleFontColorChange(color) {
    settings.fontColor = color;
  }

  handleMenuFontColorChange(color) {
    for (var m in menu.items) {
      m.style = color;
    }
  }

  handleFontSizeChange(size) {
    settings.fontSize = size;
  }

}