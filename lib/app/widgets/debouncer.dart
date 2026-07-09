import 'dart:ui';

class Debouncer {
  static final Map<String, DateTime> _lastClickMap = {};

  static bool isRedundantClick(String tag, {int cooldownMs = 1000}) {
    final now = DateTime.now();
    final lastClick = _lastClickMap[tag];
    if (lastClick != null && now.difference(lastClick).inMilliseconds < cooldownMs) {
      return true;
    }
    _lastClickMap[tag] = now;
    return false;
  }
  
  static VoidCallback? wrap(VoidCallback? onPressed, {String? tag, int cooldownMs = 1000}) {
    if (onPressed == null) return null;
    final finalTag = tag ?? onPressed.hashCode.toString();
    return () {
      if (!isRedundantClick(finalTag, cooldownMs: cooldownMs)) {
        onPressed();
      }
    };
  }
}
