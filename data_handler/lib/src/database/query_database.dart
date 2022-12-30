import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class QueryDatabase{

  String jwt = "";

  getChartData(int? id) async {
    http.Response res;
    if(id == null){
      // get all chart data.
      res = await http.get(
        Uri.https('tolerant-condor-98.hasura.app', '/api/rest/GetChartData'),
        headers: {HttpHeaders.authorizationHeader: "Bearer $jwt"},
      );
    }
    else if(id == 0){
      res = await http.get(
        Uri.https('tolerant-condor-98.hasura.app', '/api/rest/GetLatestTest'),
        headers: {HttpHeaders.authorizationHeader: "Bearer $jwt"},
      );
    }
    else{
      // get chart data by id
      res =  await http.get(
        Uri.https('tolerant-condor-98.hasura.app', '/api/rest/GetChartDataID/$id'),
        headers: {HttpHeaders.authorizationHeader: "Bearer $jwt"},
      );
    }
    var decoded = jsonDecode(res.body); 
    return decoded["ChartData"];
  }

  updateChartData(String dataJson, int id){
    return http.post(
        Uri.https('tolerant-condor-98.hasura.app', '/api/rest/UpdateChartData/$id'),
        headers: {HttpHeaders.authorizationHeader: "Bearer $jwt"},
        body: '{"_set":$dataJson}'
      );
  }

  insertChartData(String dataJson){
      return http.post(
        Uri.https('tolerant-condor-98.hasura.app', '/api/rest/InsertChartData'),
        headers: {HttpHeaders.authorizationHeader: "Bearer $jwt"},
        body: dataJson
      );
  }
}