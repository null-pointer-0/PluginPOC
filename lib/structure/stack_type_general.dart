import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:poc/size_of_widget.dart';

class StackTypeGeneral extends StatefulWidget {
  final String image;
  final GlobalKey globalKey;

  StackTypeGeneral(this.image, this.globalKey);

  @override
  _StackTypeGeneralState createState() => _StackTypeGeneralState();
}

class _StackTypeGeneralState extends State<StackTypeGeneral> {
  ValueNotifier<double> imageWidth = ValueNotifier(0.0);

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: widget.globalKey,
      child: Stack(
        children: [
          SizeOffsetWrapper(
            onSizeChange: (Size size) {
              imageWidth.value = size.width;
            },
            child: Image.asset(
              widget.image,
              height: MediaQuery.of(context).size.height * 0.27,
              fit: BoxFit.fitHeight,
            ),
          ),
          _contactWidget(),
          _nameAndDetailWidget(),
        ],
      ),
    );
  }

  Widget _contactWidget() {
    return ValueListenableBuilder(
      valueListenable: imageWidth,
      builder: (context, value, child) {
        return Positioned(
          child: const Text(
            '7982611621',
            style: TextStyle(
                fontSize: 16.0,
                color: Colors.red,
                fontWeight: FontWeight.bold),
          ),
          top: MediaQuery.of(context).size.height * 0.27 * 0.85,
          right: 12.0,
        );
      },
    );
  }

  Widget _nameAndDetailWidget() {
    return ValueListenableBuilder(
      valueListenable: imageWidth,
      builder: (context, value, child) {
        return Positioned(
          top: MediaQuery.of(context).size.height * 0.27 * 0.45,
          width: imageWidth.value,
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'Goyal Enterprises',
              maxLines: 2,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 24.0,
                  color: Colors.red,
                  fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }
}
