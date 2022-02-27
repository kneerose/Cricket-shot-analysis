import 'dart:io';
import 'package:cricket_shot_analysis/constant.dart';
import 'package:cricket_shot_analysis/model/profilemodel.dart';
import 'package:cricket_shot_analysis/model/shotmodel.dart';
import 'package:cricket_shot_analysis/random/data.dart';
import 'package:cricket_shot_analysis/server/server_operation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

class Analysis extends StatefulWidget {
  final String from;
  final ProfileModel? profileModel;
  const Analysis({Key? key, required this.from, this.profileModel})
      : super(key: key);

  @override
  _AnalysisState createState() => _AnalysisState();
}

class _AnalysisState extends State<Analysis> {
  ShotModel? _shotModel;
  File? image;
  Map<String, dynamic> result = {};
  double? _imageHeight;
  double? _imageWidth;
  var _recognitions;
  final ImagePicker _picker = ImagePicker();
  double? efficiency;
  int? frequency;
  bool isWorking = false;
  // intCamera() {
  //   _cameraController = CameraController(cameras[0], ResolutionPreset.medium,
  //       imageFormatGroup: ImageFormatGroup.yuv420);
  //   _cameraController!.initialize().then((value) {
  //     if (!mounted) {
  //       return;
  //     }
  //     setState(() {
  //       _cameraController!.startImageStream((imageFromStream) => {
  //             if (!isWorking)
  //               {
  //                 isWorking = true,
  //                 _cameraImage = imageFromStream,
  //                 runModelOnStream(),
  //               }
  //           });
  //     });
  //   });
  // }

  // detectObject(File image) async {
  //   var recognitions = await Tflite.detectObjectOnImage(
  //       path: image.path, // required
  //       imageMean: 127.5,
  //       // model: "YOLO",
  //       imageStd: 127.5,
  //       threshold: 0.4, // defaults to 0.1 // defaults to 5
  //       asynch: true // defaults to true
  //       );
  //   print("i am ${recognitions}");
  //   var decodedImage = await decodeImageFromList(image.readAsBytesSync());
  //   setState(() {
  //     _imageWidth = decodedImage.width.toDouble();
  //     _imageHeight = decodedImage.height.toDouble();
  //   });
  //   // FileImage(image)
  //   //     .resolve(const ImageConfiguration())
  //   //     .addListener((ImageStreamListener((ImageInfo info, bool _) {
  //   //       setState(() {
  //   //         _imageWidth = info.image.width.toDouble();
  //   //         _imageHeight = info.image.height.toDouble();
  //   //       });
  //   //     })));
  //   print("i am $_imageHeight and $_imageWidth");
  //   print(
  //       "i am ${MediaQuery.of(context).size.height} and ${MediaQuery.of(context).size.width}");
  //   for (var response in recognitions!) {
  //     result += response['label'] +
  //         "  " +
  //         (response['confidence'] as double).toStringAsFixed(2) +
  //         "\n\n";
  //   }
  //   setState(() {
  //     result;
  //     _recognitions = recognitions;
  //   });
  // }

  // runModelOnStream() async {
  //   if (_cameraImage != null) {
  //     var recognitions = await Tflite.runModelOnFrame(
  //       bytesList: _cameraImage!.planes.map((e) {
  //         return e.bytes;
  //       }).toList(),
  //       imageHeight: _cameraImage!.height,
  //       imageWidth: _cameraImage!.width,
  //       imageMean: 127.5,
  //       imageStd: 127.5,
  //       rotation: 90,
  //       numResults: 1,
  //       threshold: 0.1,
  //       asynch: true,
  //     );
  //     result = "";
  //     print("i am ${recognitions}");
  //     for (var response in recognitions!) {
  //       result += response['label'] +
  //           "  " +
  //           (response['confidence'] as double).toStringAsFixed(2) +
  //           "\n\n";
  //     }
  //     setState(() {
  //       result;
  //       _recognitions = recognitions;
  //       _imageHeight = _cameraImage!.height.toDouble();
  //       _imageWidth = _cameraImage!.width.toDouble();
  //     });
  //     isWorking = false;
  //   }
  // }

  // loadTModel() async {
  //   await Tflite.loadModel(
  //       model: 'assets/tfliteModel/ssd_mobilenet.tflite',
  //       labels: 'assets/tfliteModel/labels.txt');
  // }
  Map<int, String> classes_list = {
    0: 'Cut Shot',
    1: 'Cover Drive',
    2: 'Straight Drive',
    3: 'Pull Shot',
    4: 'Leg Glance Shot',
    5: 'Scoop Shot'
  };

  Future imagePicker(ImageSource source) async {
    XFile? pickedFile;
    try {
      pickedFile = await _picker.pickImage(source: source);
      // final temporaryImage = media!.path;
      // setState(() {
      //   image = temporaryImage;
      // });
      setState(() {
        if (pickedFile != null) {
          image = File(pickedFile.path);
        } else {
          print("No image Selected");
        }
      });
      if (image != null) {
        print("image");
        var data = await ServerOp().predictShot(filePath: image!.path);
        print("hello $data");
        print(data.runtimeType);
        setState(() {
          result = data;
        });
        // detectObject(image!);
      }
      // if (widget.profileModel != null) {
      //   if (result != "") {
      //     int? shotid;
      //     for (int i = 0; i < shot_profile.length; i++) {
      //       if (result == shot_profile[i]['name']) {
      //         shotid = shot_profile[i]['id'];
      //       }
      //     }
      //     Map<String, dynamic> map = {
      //       "shotid": shotid,
      //       "playerid": widget.profileModel!.id,
      //       "efficiency": efficiency,
      //       "frequency": frequency
      //     };
      //     _shotModel = ShotModel.fromMap(map);
      //   }
      // }
      //  /detectObject(image!);
      print(image!.path);
    } catch (e) {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    widget.from == "Camera"
        ? imagePicker(ImageSource.camera)
        : imagePicker(ImageSource.gallery);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, result);
        return true;
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  (image != null)
                      ? SizedBox(
                          height: MediaQuery.of(context).size.height,
                          // width:_imageWidth,
                          child: Center(child: Image.file(image!)))
                      : SizedBox(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: Center(
                            child: InkWell(
                              onTap: () {
                                widget.from == "Camera"
                                    ? imagePicker(ImageSource.camera)
                                    : imagePicker(ImageSource.gallery);
                              },
                              child: Icon(
                                widget.from == "Camera"
                                    ? FontAwesomeIcons.camera
                                    : FontAwesomeIcons.image,
                                size: 50,
                              ),
                            ),
                          ),
                        ),
                  Positioned(
                      top: 5,
                      right: 5,
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context, result);
                        },
                        child: const CircleAvatar(
                          backgroundColor: Colors.black45,
                          radius: 20,
                          child: Center(
                              child: Icon(
                            FontAwesomeIcons.times,
                            color: Colors.white,
                            size: 20,
                          )),
                        ),
                      )),
                  //   widget.from == "Camera"
                  result.isNotEmpty
                      ? Positioned(
                          bottom: 0,
                          width: MediaQuery.of(context).size.width,
                          left: 0,
                          child: Card(
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    topLeft: Radius.circular(10))),
                            child: Center(
                              child: Column(
                                children: [
                                  Text(
                                    "Prediction :  ${classes_list[result['PredictedShot']] ?? "Unknown"}",
                                    style: textStyle,
                                  ),
                                  heightSpace(10),
                                  Text(
                                    "Efficiency :  ${result['Efficiency']} \n",
                                    style: textStyle,
                                  ),
                                ],
                              ),
                            ),
                          ))
                      : Positioned(
                          bottom: 40,
                          left: MediaQuery.of(context).size.width / 2 - 10,
                          child: CircularProgressIndicator(
                            color: Colors.grey.shade900,
                          ),
                        )
                  // ...renderBoxes(MediaQuery.of(context).size)
                ],
              ),
            ),
          )),
    );
  }

  // List<dynamic> renderBoxes(Size screen) {
  //   if (widget.from != "Camera") {
  //     if (_imageWidth == null || _imageHeight == null || result == '') {
  //       return [];
  //     } else {
  //       double factorX = screen.width;
  //       double factorY = screen.height;

  //       Color blue = Colors.blue;

  //       return _recognitions.map((re) {
  //         return Container(
  //           child: Positioned(
  //               left: re['rect']['x'] * factorX,
  //               top: re['rect']['y'] * factorY,
  //               width: re['rect']['w'] * factorX,
  //               height: re['rect']['h'] * factorY,
  //               child: ((re["confidenceInClass"] > 0.50))
  //                   ? Container(
  //                       decoration: BoxDecoration(
  //                           border: Border.all(
  //                         color: blue,
  //                         width: 3,
  //                       )),
  //                       child: Text(
  //                         "${re["detectedClass"]} ${(re["confidenceInClass"] * 100).toStringAsFixed(0)}%",
  //                         style: TextStyle(
  //                           background: Paint()..color = blue,
  //                           color: Colors.white,
  //                           fontSize: 15,
  //                         ),
  //                       ),
  //                     )
  //                   : Container()),
  //         );
  //       }).toList();
  //     }
  //   } else {
  //     return [];
  //   }
  // }
}
