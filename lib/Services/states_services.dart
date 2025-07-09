import 'dart:convert';
import 'package:covid_app/Models/WorldStatesModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:covid_app/Services/Utilities/app_uri.dart';

class StatesServices {
  //World's covid records
  Future<WorldStatesModel> fetchWorldStatesRecords() async {
    final response = await http.get(Uri.parse(AppUrl.worldStatesApi));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return WorldStatesModel.fromJson(data);
    } else {
      debugPrint('Failed to fetch data. Status code: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');
      throw Exception('Failed to load data, status: ${response.statusCode}');
    }
  }

  //Countries list
  Future<List<dynamic>> countriesListApi() async {
    final response = await http.get(Uri.parse(AppUrl.countriesList));
    var data;

    if (response.statusCode == 200) {
      data = jsonDecode(response.body);
      return data;
    } else {
      debugPrint('Failed to fetch data. Status code: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');
      throw Exception('Failed to load data, status: ${response.statusCode}');
    }
  }
}
