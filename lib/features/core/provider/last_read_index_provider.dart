import 'package:flutter/foundation.dart';

class LastReadIndexProvider extends ChangeNotifier {
  int _lastReadIndex = 0;

  int get lastReadIndex => _lastReadIndex;

  void updateLastReadIndex(int index) {
    _lastReadIndex = index;
    notifyListeners();
  }
}
