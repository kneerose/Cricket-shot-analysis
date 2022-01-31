import 'package:cricket_shot_analysis/model/profilemodel.dart';
import 'package:cricket_shot_analysis/page/players/playersdetails.dart';
import 'package:cricket_shot_analysis/random/data.dart';
import 'package:cricket_shot_analysis/server/server_operation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../constant.dart';

class Players extends StatefulWidget {
  const Players({Key? key}) : super(key: key);

  @override
  State<Players> createState() => _PlayersState();
}

class _PlayersState extends State<Players> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  List playerId = [];
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

  void sync() {
    setState(() {
      playerId = players.map((e) => e.id).toList();
      // equipmentcategoryid = equipmentcategory.map((e) => e.id).toList();
    });
    fetchPlayer();
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Text(
          "Players",
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
      body: players.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SmartRefresher(
              onRefresh: sync,
              controller: _refreshController,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 20.0,
                    ),
                    itemCount: players.length,
                    itemBuilder: (context, items) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PlayersDetails(
                                      profileModel: players[items]))) ;
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
                                  // width: 150,
                                  // height: 150,
                                  fit: BoxFit.fill,
                                ),
                                heightSpace(10),
                                Container(
                                  // width: 140,
                                  // height: 40,
                                  alignment: Alignment.center,
                                  child: Text(
                                    players[items].name,
                                    style: const TextStyle(
                                      fontFamily: "OpenSans",
                                      fontSize: 15,
                                      color: kPrimaryColor,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
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
            ),
    );
  }
}
