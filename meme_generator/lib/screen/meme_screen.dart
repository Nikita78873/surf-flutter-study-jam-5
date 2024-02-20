import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class MemeScreen extends StatefulWidget {
  final String textimage;
  final XFile? image;

  const MemeScreen({super.key, required this.textimage, required this.image});

  @override
  State<MemeScreen> createState() =>
      _MemeScreenState(textimage: textimage, image: image);
}

class _MemeScreenState extends State<MemeScreen> {
  double posx = 0;
  double posy = 0;
  String Txt = "Tap Here To Start!";
  final String textimage;
  final XFile? image;
  late Uint8List? _content;

  ScreenshotController screenshotController = ScreenshotController();

  _MemeScreenState({required this.textimage, required this.image});

  void onTapDown(BuildContext context, TapDownDetails details) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    final Offset localOffset = box.globalToLocal(details.globalPosition);

    setState(() {
      posx = localOffset.dx;
      posy = localOffset.dy;
      Txt = 'Tapped\nX:$posx \nY:$posy';
    });
  }

  // void _shareContent() {
  //   Share.shareXFiles(_content);
  // }

  @override
  Widget build(BuildContext context) {
    print(textimage);
    print(image);
    if (textimage == '') {
      return Scaffold(
        body: Screenshot(
          controller: screenshotController,
          child: Stack(
            children: [
              GestureDetector(
                onTapDown: (TapDownDetails details) =>
                    onTapDown(context, details),
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.sizeOf(context).width,
                      height: MediaQuery.sizeOf(context).height,
                      child: image == null
                          ? const Center(
                              child: Text('Изображение не выбрано'),
                            )
                          : Image(
                              image: FileImage(
                                File(image!.path),
                              ),
                            ),
                    ),
                  ],
                  // child: Image.file(image, fit: BoxFit.scaleDown),
                ),
              ),
              Positioned(
                width: MediaQuery.sizeOf(context).width,
                height: 70,
                child: TextField(
                  maxLength: 30,
                  decoration: const InputDecoration(
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                  ),
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 35,
                      fontWeight: FontWeight.bold),
                ),
                left: posx,
                top: posy,
              ),
            ],
          ),
        ),
        floatingActionButton: ElevatedButton(
          onPressed: () async {
            screenshotController
                .capture(delay: Duration(milliseconds: 10))
                .then(
              (capturedImage) async {
                ShowCapturedWidget(context, capturedImage!);
              },
            ).catchError(
              (onError) {
                print(onError);
              },
            );
            _content = await screenshotController.capture();
            // final screenfile = await screenshotController.capture();
            // _shareContent();
          },
          child: Icon(Icons.share),
        ),
      );
    } else {
      return Scaffold(
        body: Screenshot(
          controller: screenshotController,
          child: Stack(
            children: [
              // SizedBox(
              //   width: MediaQuery.sizeOf(context).width,
              //   height: MediaQuery.sizeOf(context).height,
              //   child: Image.network(
              //     textimage,
              //     fit: BoxFit.scaleDown,
              //   ),
              // ),
              GestureDetector(
                onTapDown: (TapDownDetails details) =>
                    onTapDown(context, details),
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.sizeOf(context).width,
                      height: MediaQuery.sizeOf(context).height,
                      child: Image.network(
                        textimage,
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                    Positioned(
                      width: MediaQuery.sizeOf(context).width,
                      height: 70,
                      child: TextField(
                        maxLength: 30,
                        decoration: const InputDecoration(
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                        ),
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 35,
                            fontWeight: FontWeight.bold),
                      ),
                      left: posx,
                      top: posy,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: ElevatedButton(
          onPressed: () async {
            screenshotController
                .capture(delay: Duration(milliseconds: 10))
                .then(
              (capturedImage) async {
                ShowCapturedWidget(context, capturedImage!);
              },
            ).catchError(
              (onError) {
                print(onError);
              },
            );
            _content = await screenshotController.capture();
            // final screenfile = await screenshotController.capture();
            // _shareContent();
          },
          child: Icon(Icons.share),
        ),
      );
    }
  }

  Future<dynamic> ShowCapturedWidget(
      BuildContext context, Uint8List capturedImage) async {
    Share.shareXFiles([XFile.fromData(capturedImage)]);
    return showDialog(
      useSafeArea: false,
      context: context,
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: Text("Captured widget screenshot"),
        ),
        body: Center(child: Image.memory(capturedImage)),
      ),
    );
  }
}
