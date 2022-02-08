import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:poc/Data/Asset.dart';
import 'package:poc/Data/total_card.dart';
import 'package:poc/structure/stack_type_general.dart';
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
  final TotalCards _totalCardsClass = TotalCards();
  List<Widget> totalCards = List.empty(growable: true);
  Uint8List? imageInMemory = Uint8List.fromList(List.empty(growable: true));
  int curIndex = 0;
  final PageController _pageController = PageController(initialPage: 0 ,viewportFraction: 0.9);

  @override
  void initState() {
    super.initState();
    totalCards = _totalCardsClass.getTotalCards();
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
            Container(
              constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height*0.27),
                child:PageView.builder(
                itemCount: totalCards.length,
                controller: _pageController,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: totalCards[index],
                  );
                },
                onPageChanged: (index) {
                  setState(() {
                    curIndex = index;
                  });
                },
              ),
            ),
            InkWell(
              onTap: () {
                _capturePng((totalCards[curIndex] as StackTypeGeneral).globalKey).then((value) {});
              },
              child: Container(
                color: Colors.blue,
                padding: const EdgeInsets.all(16.0),
                child: const Text(
                  'Capture Image',
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Uint8List?> _capturePng(GlobalKey _globalKey) async {
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
          sharePositionOrigin:
          boundary!.localToGlobal(Offset.zero) & boundary.size);
      setState(() {
        imageInMemory = pngBytes;
      });
      return pngBytes;
    } catch (e) {
      print("debug: $e");
      return null;
    }
  }

}
