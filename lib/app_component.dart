// Copyright (c) 2016, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/core.dart';

@Component(selector: 'my-app', templateUrl: 'app_component.html')
class AppComponent {
  String page = "home";
  String get pathToLogo => "images/title.png";

  handleTopMenu(page) {
    this.page = page;
  }
}
