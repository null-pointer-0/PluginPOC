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
  final int _currentPage=0;
  late PageController _pageController;
  final GlobalKey _globalKey = GlobalKey();
  Uint8List? imageInMemory = Uint8List.fromList(List.empty(growable: true));
  Assets imageList= Assets();

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
  void initState() {
    super.initState();
    print(imageList.images[0]);
    _pageController=PageController(initialPage: _currentPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
              AspectRatio(
                aspectRatio: 0.85,
                child: PageView.builder(
                  itemCount: imageList.images.length,
                    physics:const ClampingScrollPhysics(),
                    controller:_pageController ,
                    itemBuilder: (context,index){
                    return _cardWidget(index) ;
                    }
                ),
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

  /*Widget _cardWidget(index) {
    return RepaintBoundary(
      key: _globalKey,
      child: Container(
        height: 100,
        width: 100,
        child: Stack(
          children: [
            Image.asset(
              imageList.images[index],
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
        ),
      ),
    );
  }
}*/

  Widget _cardWidget(index) {
    return RepaintBoundary(
      key: _globalKey,
      child: Stack(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child:Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        image: DecorationImage(
                            image: AssetImage(
                              imageList.images[index],
                            ),
                            fit: BoxFit.fill),
                        boxShadow: const [
                          BoxShadow(
                              offset: Offset(0, 4),
                              blurRadius: 4,
                              color: Colors.black26)
                        ]),
                  ),
            ),
          ),
          const Positioned(
            child: Text(
              '7982611621',
              style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            bottom: 50.0,
            right: 40.0,
          ),
          const Positioned(
            top:200.0,
            left: 44.0,
            child: Text(
              'Factory Plus',
              style: TextStyle(
                  fontSize: 35.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}
