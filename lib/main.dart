import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:poc/Asset.dart';
import 'package:share/share.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey _globalKey = GlobalKey();
  Uint8List? imageInMemory = Uint8List.fromList(List.empty(growable: true));

  Future<Uint8List?> _capturePng() async {
    try {
      RenderRepaintBoundary? boundary = _globalKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary?;
      ui.Image? image = await boundary?.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image?.toByteData(format: ui.ImageByteFormat.png);
      Uint8List? pngBytes = byteData?.buffer.asUint8List();
      final directory = (await getExternalStorageDirectory()).path;
      File imgFile = File('$directory/flutter.png');
      imgFile.writeAsBytesSync(pngBytes!);
      List<String> paths = List.empty(growable: true);
      paths.add('$directory/flutter.png');
      Share.shareFiles(paths,
          subject: 'Share ScreenShot',
          sharePositionOrigin: boundary!.localToGlobal(Offset.zero) & boundary.size
      );
      setState(() {
        imageInMemory = pngBytes;
      });
      return pngBytes;
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Widget To Image demo'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RepaintBoundary(
              key: _globalKey,
              child: _cardWidget(),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: InkWell(
                  onTap: () {
                    _capturePng().then((value) {

                    });
                  },
                  child: Container(
                    color: Colors.blue,
                    padding: const EdgeInsets.all(16.0),
                    child: const Text(
                      'Capture Image',
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Widget _cardWidget() {
    return Stack(
      children: [
        Image.asset(
          Assets.card_background,
          width: MediaQuery.of(context).size.width * 0.8,
        ),
        const Positioned(
          child: Text(
            '7982611621',
            style: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
                fontWeight: FontWeight.bold),
          ),
          bottom: 8.0,
          right: 12.0,
        ),
        const Positioned(
          top: 80.0,
          left: 52.0,
          child: Text(
            'Goyal Enterprises',
            style: TextStyle(
                fontSize: 24.0,
                color: Colors.black,
                fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
