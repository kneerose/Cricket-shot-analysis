class ProfileModel {
  final int id;
  final String name;
  final String src;
  final int age;
  final String battingstyle;
  final String bowlingstyle;
  final String playingrole;
  final String teams;
  final int cut;
  final int coverdrive;
  final int straightdrive;
  final int pullshot;
  final int legglance;
  final int scoop;
  ProfileModel(
      {required this.id,
      required this.name,
      required this.src,
      required this.age,
      required this.battingstyle,
      required this.bowlingstyle,
      required this.playingrole,
      required this.teams,
      required this.cut,
      required this.coverdrive,
      required this.straightdrive,
      required this.pullshot,
      required this.legglance,
      required this.scoop});
  factory ProfileModel.fromMap(Map<String, dynamic> map) => ProfileModel(
        id: int.parse(map['id']),
        name: map['name'],
        src: map['src'],
        age: int.parse(map['age']),
        battingstyle: map['battingstyle'],
        bowlingstyle: map['bowlingstyle'],
        playingrole: map['playingrole'],
        teams: map['teams'],
        cut: int.parse(map['Cut']),
        coverdrive: int.parse(map['CoverDrive']),
        straightdrive: int.parse(map['StraightDrive']),
        pullshot: int.parse(map['PullShot']),
        legglance: int.parse(map['LegGlance']),
        scoop: int.parse(map['scoop']),
      );
  Map<String, dynamic> map() => {
        'name': name,
        'imageSrc': src,
        'age': age,
        "batting style": battingstyle,
        "bowling style": bowlingstyle,
        "playing role": playingrole,
        "teams": teams,
      };
}
