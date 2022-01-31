import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cricket_shot_analysis/constant.dart';
import 'package:cricket_shot_analysis/model/newsmodel.dart';
import 'package:cricket_shot_analysis/model/profilemodel.dart';
import 'package:cricket_shot_analysis/model/sampleanalysismodel.dart';
import 'package:cricket_shot_analysis/page/analysis/image.dart';
import 'package:cricket_shot_analysis/page/news/latestnews.dart';
import 'package:cricket_shot_analysis/page/players/addplayersdetails.dart';
import 'package:cricket_shot_analysis/page/players/players.dart';
import 'package:cricket_shot_analysis/page/players/playersdetails.dart';
import 'package:cricket_shot_analysis/page/shots/sampleshot.dart';
import 'package:cricket_shot_analysis/random/data.dart';
import 'package:cricket_shot_analysis/server/server_operation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cricket_shot_analysis/server/server_operation.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  bool isFetching = true;
  List storyId = [];
  List playerId = [];
  List sampleId = [];
  @override
  void initState() {
    // TODO: implement initState
    // fetchdata();
    availablecamera();
    fetchSampleAnalysis();
    fetchNews();
    fetchPlayer();

    super.initState();
  }

  void availablecamera() async {
    cameras = await availableCameras();
  }

  // void fetchdata() {
  //   for (int i = 0; i < news.length; i++) {
  //     newsModel.add(NewsModel.fromMap(news[i]));
  //   }
  // }
  void fetchPlayer() async {
    List data = await ServerOperation().fetchplayerProfile();
    print(data.length);
    for (int i = 0; i < data.length; i++) {
      if (data[i] != null) {
        if (playerId.isEmpty) {
          setState(() {
            players.add(ProfileModel.fromMap(data[i]));
          });
        } else {
          if (!playerId.contains((int.parse(data[i]['id'])))) {
            setState(() {
              players.add(ProfileModel.fromMap(data[i]));
            });
          }
        }
      }
    }
  }

  void fetchSampleAnalysis() async {
    List data = await ServerOperation().fetchSampleAnalysis();
    print(data.length);
    for (int i = 0; i < data.length; i++) {
      if (data[i] != null) {
        if (sampleId.isEmpty) {
          setState(() {
            sampleAnalysis.add(SampleAnalysis.fromMap(data[i]));
          });
        } else {
          if (!sampleId.contains((int.parse(data[i]['id'])))) {
            setState(() {
              sampleAnalysis.add(SampleAnalysis.fromMap(data[i]));
            });
          }
        }
      }
    }
  }

  void fetchNews() async {
    List data = await ServerOperation().fetchNewsList();
    print(data.length);
    for (int i = 0; i < data.length; i++) {
      if (data[i] != null) {
        if (storyId.isEmpty) {
          setState(() {
            news.add(NewsModel.fromMap(data[i]));
          });
        } else {
          if (!storyId.contains((data[i]['id']))) {
            setState(() {
              news.add(NewsModel.fromMap(data[i]));
            });
          }
        }
      }
    }
    setState(() {
      isFetching = false;
    });
  }

  void sync() {
    setState(() {
      storyId = news.map((e) => e.id).toList();
      playerId = players.map((e) => e.id).toList();
      sampleId = sampleAnalysis.map((e) => e.id).toList();
      // equipmentcategoryid = equipmentcategory.map((e) => e.id).toList();
    });
    fetchSampleAnalysis();
    fetchNews();
    fetchPlayer();
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        title: Text(
          "Cricket Shot Ananysis",
          style: textStyleTitle,
        ),
        // centerTitle: true,
        leading: Container(
          padding: const EdgeInsets.all(2),
          margin: const EdgeInsets.only(left: 10),
          child: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey.shade300,
            child: const Image(
              image: AssetImage("assets/images/players/paras.png"),
              height: 30,
              width: 30,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      body: SmartRefresher(
        onRefresh: sync,
        controller: _refreshController,
        child: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  heightSpace(10),
                  Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: Text(
                      "Analyse Shot",
                      style: textStyleTitle,
                    ),
                  ),
                  heightSpace(30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Analysis(
                                            from: 'Camera',
                                          )));
                              // showDialog(
                              //     context: context,
                              //     builder: (context) => showdialog());
                            },
                            child: const Icon(
                              FontAwesomeIcons.camera,
                              color: kButtonColor,
                              size: 70,
                            ),
                          ),
                          heightSpace(10),
                          Text(
                            "Capture",
                            style: textStyle,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          InkWell(
                            onTap: () {
                              // imagePicker(ImageSource.gallery, context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const Analysis(from: "upload")));
                            },
                            child: const Icon(
                              Icons.upload_file,
                              color: kButtonColor,
                              size: 70,
                            ),
                          ),
                          heightSpace(10),
                          Text(
                            "Upload",
                            style: textStyle,
                          ),
                        ],
                      )
                    ],
                  ),
                  // : InkWell(
                  //     onLongPress: () {
                  //       setState(() {
                  //         image = null;
                  //       });
                  //     },
                  //     child: Image.file(
                  //       File(image!),
                  //       height: 150,
                  //     ),
                  //   ),
                  //  Image(
                  //     image: Image.file(image!),
                  //     height: 150,
                  //   ),
                  //Image(image: FileImage(image!)),
                  heightSpace(50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: Text(
                          "Sample Analysis",
                          style: textStyleTitle,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SampleShots()));
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade200,
                                )
                              ]),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 8),
                          child: const Text(
                            "See All",
                            style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontSize: 15,
                              color: kPrimaryColor,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  heightSpace(30),
                  SizedBox(
                    height: 200,
                    child: sampleAnalysis.isEmpty
                        ? const Center(child: CircularProgressIndicator())
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: sampleAnalysis.length,
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            padding: const EdgeInsets.only(left: 10),
                            itemBuilder: (context, items) {
                              return Card(
                                margin: const EdgeInsets.only(right: 20),
                                color: Colors.grey.shade100,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 8),
                                  child: Column(
                                    children: [
                                      Image(
                                        image: NetworkImage(
                                            "https://shotanalysis.000webhostapp.com/sample_analysis/${sampleAnalysis[items].src}"),
                                        width: 150,
                                        height: 150,
                                        fit: BoxFit.fill,
                                      ),
                                      heightSpace(10),
                                      Container(
                                        width: 140,
                                        height: 20,
                                        alignment: Alignment.center,
                                        child: Text(
                                          sampleAnalysis[items].name,
                                          style: const TextStyle(
                                            fontFamily: "OpenSans",
                                            fontSize: 15,
                                            color: kPrimaryColor,
                                          ),
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }),
                  ),
                  heightSpace(50),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 10),
                          child: Text(
                            "Latest Cricket News",
                            style: textStyleTitle,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LatestNews()));
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade200,
                                  )
                                ]),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 8),
                            child: const Text(
                              "See All",
                              style: TextStyle(
                                fontFamily: 'OpenSans',
                                fontSize: 15,
                                color: kPrimaryColor,
                              ),
                            ),
                          ),
                        )
                      ]),
                  heightSpace(30),
                  SizedBox(
                    height: 260,
                    child: isFetching
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: kPrimaryColor,
                            ),
                          )
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: news.length,
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.only(left: 10),
                            shrinkWrap: true,
                            itemBuilder: (context, items) {
                              return Card(
                                  margin: const EdgeInsets.only(right: 20),
                                  color: Colors.grey.shade100,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 10),
                                    width: 250,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        heightSpace(10),
                                        Text(
                                          news[items].title,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontFamily: "OpenSans",
                                            color: kTextColor,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        heightSpace(10),
                                        Text(
                                          news[items].subtitle,
                                          maxLines: 4,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontFamily: "OpenSans",
                                            color: kTextColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                        heightSpace(20),
                                        Text(
                                          "Context : ${news[items].context}",
                                          maxLines: 2,
                                          style: const TextStyle(
                                            color: kTextColor,
                                            fontFamily: "OpenSans",
                                          ),
                                        ),
                                      ],
                                    ),
                                  ));
                            }),
                  ),
                  heightSpace(50),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 10),
                          child: Text(
                            "Players",
                            style: textStyleTitle,
                          ),
                        ),
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Players()));
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.shade200,
                                      )
                                    ]),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 8),
                                child: const Text(
                                  "See All",
                                  style: TextStyle(
                                    fontFamily: 'OpenSans',
                                    fontSize: 15,
                                    color: kPrimaryColor,
                                  ),
                                ),
                              ),
                            ),
                            // IconButton(
                            //     onPressed: () {
                            //       Navigator.push(
                            //           context,
                            //           MaterialPageRoute(
                            //               builder: (context) =>
                            //                   AddPlayersDetails()));
                            //     },
                            //     icon: const Icon(Icons.add_circle,
                            //         size: 30, color: Colors.black38))
                          ],
                        )
                      ]),
                  heightSpace(30),
                  SizedBox(
                    height: 220,
                    child: players.isEmpty
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: players.length,
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            padding: const EdgeInsets.only(left: 10),
                            itemBuilder: (context, items) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => PlayersDetails(
                                              profileModel: players[items])));
                                },
                                child: Card(
                                  margin: const EdgeInsets.only(right: 20),
                                  color: Colors.grey.shade100,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 8),
                                    child: Column(
                                      children: [
                                        Image(
                                          image: NetworkImage(
                                              "https://shotanalysis.000webhostapp.com/players/${players[items].src}"),
                                          width: 150,
                                          height: 150,
                                          fit: BoxFit.fill,
                                        ),
                                        heightSpace(10),
                                        Container(
                                          width: 140,
                                          height: 40,
                                          alignment: Alignment.center,
                                          child: Text(
                                            players[items].name,
                                            style: const TextStyle(
                                              fontFamily: "OpenSans",
                                              fontSize: 15,
                                              color: kPrimaryColor,
                                            ),
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Dialog showdialog() {
  //   return Dialog(
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  //       child: Padding(
  //         padding: const EdgeInsets.all(20.0),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             InkWell(
  //               child: Padding(
  //                 padding: const EdgeInsets.all(8.0),
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     const Icon(
  //                       FontAwesomeIcons.image,
  //                       size: 25,
  //                     ),
  //                     widthSpace(30),
  //                     Text(
  //                       "Image",
  //                       style: textStyleTitle,
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               onTap: () {
  //                 imagePicker(ImageSource.camera, context);
  //               },
  //             ),
  //             heightSpace(10),
  //             InkWell(
  //               child: Padding(
  //                 padding: const EdgeInsets.all(8.0),
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     const Icon(
  //                       FontAwesomeIcons.video,
  //                       size: 25,
  //                     ),
  //                     widthSpace(33),
  //                     Text(
  //                       "Video",
  //                       style: textStyleTitle,
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               onTap: () {
  //                 videoPicker(ImageSource.camera, context);
  //               },
  //             )
  //           ],
  //         ),
  //       ));
  // }

}
