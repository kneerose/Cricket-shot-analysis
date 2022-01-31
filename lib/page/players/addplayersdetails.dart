import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../../constant.dart';

class AddPlayersDetails extends StatefulWidget {
  AddPlayersDetails({Key? key}) : super(key: key);

  @override
  State<AddPlayersDetails> createState() => _AddPlayersDetailsState();
}

class _AddPlayersDetailsState extends State<AddPlayersDetails> {
  String? image;
  final ImagePicker _picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Text(
          "Add Player",
          style: textStyleTitle,
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              FontAwesomeIcons.chevronLeft,
              color: Colors.black,
            )),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            heightSpace(20),
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.green,
                      child: image != null
                          ? Image.file(File(image!))
                          : const Image(
                              image: AssetImage("assets/images/user.png"))

                      // backgroundImage: const AssetImage("assets/images/user.png"),
                      ),
                  Positioned(
                    right: -5,
                    top: -5,
                    child: IconButton(
                        alignment: Alignment.topRight,
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => showdialog());
                        },
                        icon: Icon(
                          Icons.add_a_photo,
                          size: 30,
                          color: Colors.grey.shade700,
                        )),
                  ),
                ],
              ),
            ),
            heightSpace(20),
          ],
        ),
      )),
    );
  }

  Future imagePicker(
    ImageSource source,
  ) async {
    XFile? pickedFile;
    try {
      pickedFile = await _picker.pickImage(source: source);
      setState(() {
        if (pickedFile != null) {
          image = pickedFile.path;
        } else {
          print("No image Selected");
        }
      });
      print(image!);
    } catch (e) {
      return null;
    }
  }

  Dialog showdialog() {
    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Icon(
                        FontAwesomeIcons.fileUpload,
                        size: 25,
                      ),
                      widthSpace(30),
                      Text(
                        "Pick From File",
                        style: textStyleTitle,
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  imagePicker(ImageSource.gallery);
                  Navigator.pop(context);
                },
              ),
              heightSpace(10),
              InkWell(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Icon(
                        FontAwesomeIcons.camera,
                        size: 25,
                      ),
                      widthSpace(33),
                      Text(
                        "Camera",
                        style: textStyleTitle,
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  imagePicker(
                    ImageSource.camera,
                  );
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ));
  }
}
