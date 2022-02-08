import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

class SizeOffsetWrapper extends SingleChildRenderObjectWidget {
  final OnWidgetSizeChange onSizeChange;

  const SizeOffsetWrapper({
    Key? key,
    required this.onSizeChange,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return SizeRenderObject(onSizeChange);
  }
}

typedef void OnWidgetSizeChange(Size size);

class SizeRenderObject extends RenderProxyBox {
  final OnWidgetSizeChange onSizeChange;
  Size? currentSize;

  SizeRenderObject(this.onSizeChange);

  @override
  void performLayout() {
    super.performLayout();

    try {
      Size? newSize = child?.size;

      if (newSize != null && currentSize != newSize) {
        currentSize = newSize;
        WidgetsBinding.instance?.addPostFrameCallback((_) {
          onSizeChange(newSize);
        });
      }
    } catch (e) {
      print(e);
    }
  }
}
