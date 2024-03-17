
import 'package:flutter/cupertino.dart';

enum WidgetStyle { material, cupertino }

class WidgetSwitching with ChangeNotifier {
  late WidgetStyle _currentStyle;

  WidgetSwitching(this._currentStyle);

  WidgetStyle get currentStyle => _currentStyle;

  void setStyle(WidgetStyle style) {
    _currentStyle = style;
    notifyListeners();
  }
}