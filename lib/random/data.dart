import 'package:cricket_shot_analysis/model/newsmodel.dart';
import 'package:cricket_shot_analysis/model/profilemodel.dart';
import 'package:cricket_shot_analysis/model/sampleanalysismodel.dart';
import 'package:cricket_shot_analysis/model/shotmodel.dart';

// List sampleImageList = [
//   "assets/images/analysis/cut.png",
//   "assets/images/analysis/drive.png",
//   "assets/images/analysis/sweep.png",
//   "assets/images/analysis/cut.png",
//   "assets/images/analysis/drive.png",
//   "assets/images/analysis/sweep.png",
//   "assets/images/analysis/cut.png",
//   "assets/images/analysis/drive.png",
//   "assets/images/analysis/sweep.png"
// ];
List<SampleAnalysis> sampleAnalysis = [];
List<NewsModel> news = [];
List<ProfileModel> players = [
  // {"name": "Paras khadka", "url": "assets/images/players/paras.png"},
  // {"name": "Sandeep lamichanee", "url": "assets/images/players/sandip.png"},
  // {"name": "Sompal kami", "url": "assets/images/players/sompal.png"},
  // {"name": "Paras khadka", "url": "assets/images/players/paras.png"},
  // {"name": "Sandeep lamichanee", "url": "assets/images/players/sandip.png"},
  // {"name": "Sompal kami", "url": "assets/images/players/sompal.png"},
  // {"name": "Paras khadka", "url": "assets/images/players/paras.png"},
  // {"name": "Sandeep lamichanee", "url": "assets/images/players/sandip.png"},
  // {"name": "Sompal kami", "url": "assets/images/players/sompal.png"},
  // {"name": "Paras khadka", "url": "assets/images/players/paras.png"},
  // {"name": "Sandeep lamichanee", "url": "assets/images/players/sandip.png"},
  // {"name": "Sompal kami", "url": "assets/images/players/sompal.png"}
];
// Map profileDetails = {
//   "AGE": 25,
//   "BATTING STYLE": "Right hand bat",
//   "BOWLING STYLE": "Right arm offbreak",
//   "PLAYING ROLE": "Batter",
//   "TEAMS": ["NEPAL", "THAPATHALI"],
//   "MOSTPLAYSHOT": "Sweep",
//   "Times": 10
// };
List shot_profile = [
  {
    "id": 1,
    "name": "CutShot",
  },
  {
    "id": 2,
    "name": "CoverDrive",
  },
  {
    "id": 3,
    "name": "StraightDrive",
  },
  {
    "id": 4,
    "name": "PullShot",
  },
  {
    "id": 5,
    "name": "LegGlance",
  },
  {
    "id": 6,
    "name": "Scoop",
  }
];
List<ShotModel> shotmodel = [];
