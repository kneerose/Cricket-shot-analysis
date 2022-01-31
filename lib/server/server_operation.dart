import 'dart:convert';
import 'package:cricket_shot_analysis/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ServerOperation {
  final String _apiKey = "35a0e66686msh0132bd26a0c4c52p19b51bjsn87c08e9f9fbb";
  final String _website = "https://shotanalysis.000webhostapp.com";
  Future<List> fetchNewsList() async {
    try {
      Uri url =
          Uri.parse("https://unofficial-cricbuzz.p.rapidapi.com/news/list");
      var headers = {
        'accept': 'application/json',
        'x-rapidapi-key': _apiKey,
        'x-rapidapi-host': 'unofficial-cricbuzz.p.rapidapi.com'
      };
      var response = await http.get(
        url,
        headers: headers,
      );
      var outputdata = jsonDecode(response.body)['newsList'];
      // print(outputdata);
      List story = [];
      for (int i = 0; i < outputdata.length; i++) {
        story.add(outputdata[i]['story']);
      }
      print(story);
      return story;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future fetchplayerProfile() async {
    try {
      final uri = Uri.parse("$_website/getplayers.php");
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        print(response.body);
        return jsonDecode(response.body);
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e);
    }
  }

  Future fetchSampleAnalysis() async {
    try {
      final uri = Uri.parse("$_website/get_sample_analysis.php");
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        print(response.body);
        return jsonDecode(response.body);
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e);
    }
  }

  Future setProfile(
      {required String name,
      required String src,
      required BuildContext context}) async {
    try {
      final uri = Uri.parse("$_website/players_upload.php");
      var request = http.MultipartRequest('POST', uri);
      request.fields["name"] = name;
      var picture = await http.MultipartFile.fromPath("src", src);
      request.files.add(picture);
      var response = await request.send();
      print(response.statusCode);
      if (response.statusCode == 200) {
        SnackBar snackBar = SnackBar(
            content: Text(
          "Uploaded Successfully",
          style: textStyle,
        ));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        SnackBar snackBar = SnackBar(
            content: Text(
          "Failed to upload",
          style: textStyle,
        ));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      print(e);
    }
  }
}
