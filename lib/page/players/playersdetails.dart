import 'package:cricket_shot_analysis/model/profilemodel.dart';
import 'package:cricket_shot_analysis/page/analysis/image.dart';
import 'package:cricket_shot_analysis/random/data.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pie_chart/pie_chart.dart';

import '../../constant.dart';

class PlayersDetails extends StatefulWidget {
  final ProfileModel profileModel;
  const PlayersDetails({Key? key, required this.profileModel})
      : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  _PlayersDetailsState createState() => _PlayersDetailsState(profileModel);
}

class _PlayersDetailsState extends State<PlayersDetails> {
  ProfileModel _profileModel;
  _PlayersDetailsState(this._profileModel);
  String? _mostPlayedShot;
  int? _times;
  late List shot;
  List<Color> colorList = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.blueGrey,
    Colors.yellow,
    Colors.teal
  ];
  late Map<String, double> dataMap;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dataMap = {
      "CUT": _profileModel.cut.toDouble(),
      "COVER DRIVE": _profileModel.coverdrive.toDouble(),
      "STRAIGHT DRIVE": _profileModel.straightdrive.toDouble(),
      "PULL SHOT": _profileModel.pullshot.toDouble(),
      "LEG GLANCE": _profileModel.legglance.toDouble(),
      "SCOOP": _profileModel.scoop.toDouble(),
    };
    shot = [
      {
        "Shot Name": "CUT",
        "Times": _profileModel.cut,
      },
      {
        "Shot Name": "COVER DRIVE",
        "Times": _profileModel.coverdrive,
      },
      {
        "Shot Name": "STRAIGHT DRIVE",
        "Times": _profileModel.straightdrive,
      },
      {
        "Shot Name": "PULL SHOT",
        "Times": _profileModel.pullshot,
      },
      {
        "Shot Name": "LEG GLANCE",
        "Times": _profileModel.legglance,
      },
      {
        "Shot Name": "SCOOP",
        "Times": _profileModel.scoop,
      }
    ];
  }

  Map checkMostPlayedShot() {
    List _shotTimes = [];
    Map shotSelected = {};
    for (int i = 0; i < shot.length; i++) {
      _shotTimes.add(shot[i]['Times']);
    }
    _shotTimes.sort();

    for (int i = 0; i < shot.length; i++) {
      if (shot[i]['Times'] == _shotTimes.last) {
        shotSelected = shot[i];
      }
    }
    return shotSelected;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
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
                child: CircleAvatar(
                  radius: 50,

                  foregroundImage: NetworkImage(
                      "https://shotanalysis.000webhostapp.com/players/${_profileModel.src}"),
                  // backgroundImage: const AssetImage("assets/images/user.png"),
                ),
              ),
              heightSpace(20),
              Text(
                _profileModel.name,
                style: textStyle,
                textAlign: TextAlign.center,
              ),
              heightSpace(30),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        heightSpace(5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("AGE "),
                            Text(_profileModel.age.toString())
                          ],
                        ),
                        heightSpace(10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("BATTING STYLE "),
                            Text(_profileModel.battingstyle)
                          ],
                        ),
                        heightSpace(10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("BOWLING STYLE "),
                            Text(_profileModel.bowlingstyle)
                          ],
                        ),
                        heightSpace(10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("PLAYING ROLE "),
                            Text(_profileModel.playingrole)
                          ],
                        ),
                        heightSpace(10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("TEAMS "),
                            widthSpace(80),
                            Expanded(
                                child: Text(
                              _profileModel.teams,
                              textDirection: TextDirection.rtl,
                            ))
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 20,
                        ),
                        child: Column(
                          children: [
                            Text(
                              "List of Analysed Shot ",
                              style: textStyle,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Shot",
                                  style: textStyle,
                                ),
                                Text(
                                  "Times",
                                  style: textStyle,
                                )
                              ],
                            ),
                            heightSpace(5),
                            ListView.builder(
                                itemCount: shot.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(shot[index]['Shot Name']),
                                        Text(shot[index]['Times'].toString())
                                      ],
                                    ),
                                  );
                                }),
                          ],
                        ),
                      ))),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 20,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("MOST PLAY SHOT "),
                            Text(checkMostPlayedShot()['Shot Name'])
                          ],
                        ),
                        heightSpace(10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("TIMES "),
                            Text(checkMostPlayedShot()['Times'].toString())
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              heightSpace(30),
              PieChart(
                dataMap: dataMap,
                animationDuration: const Duration(milliseconds: 800),
                chartLegendSpacing: 32,
                chartRadius: MediaQuery.of(context).size.width / 2.5,
                colorList: colorList,
                initialAngleInDegree: 0,
                chartType: ChartType.disc,
                ringStrokeWidth: 32,

                legendOptions: const LegendOptions(
                  showLegendsInRow: false,
                  legendPosition: LegendPosition.right,
                  showLegends: true,
                  legendShape: BoxShape.circle,
                  legendTextStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                chartValuesOptions: const ChartValuesOptions(
                  showChartValueBackground: true,
                  showChartValues: true,
                  showChartValuesInPercentage: true,
                  showChartValuesOutside: false,
                  decimalPlaces: 0,
                ),
                // gradientList: ---To add gradient colors---
                // emptyColorGradient: ---Empty Color gradient---
              ),
              heightSpace(20),
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const Analysis(from: "Camera")));
                  },
                  icon: const Icon(
                    FontAwesomeIcons.camera,
                    size: 50,
                  )),
              heightSpace(50),
            ],
          ),
        ),
      ),
    );
  }
}
