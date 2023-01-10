import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class QueryDatabase{

  String jwt = "";
  String table = "test_ChartData";

  getChartDataAll()async{
      // get all chart data.
      var res = await http.get(
        Uri.https('tolerant-condor-98.hasura.app', '/api/rest/GetChartData'),
        headers: _getAuthHeaders(jwt),
      );
      return jsonDecode(res.body)[table];
  }

  getChartData(int? id) async {
    http.Response res;
    if(id == null){
      // get all chart data.
      res = await http.get(
        Uri.https('tolerant-condor-98.hasura.app', '/api/rest/GetChartData'),
        headers: _getAuthHeaders(jwt),
      );
    }
    else if(id == 0){
      res = await http.get(
        Uri.https('tolerant-condor-98.hasura.app', '/api/rest/GetLatestTest'),
        headers: _getAuthHeaders(jwt),
      );
    }
    else{
      // get chart data by id
      res =  await http.get(
        Uri.https('tolerant-condor-98.hasura.app', '/api/rest/GetChartDataID/$id'),
        headers: _getAuthHeaders(jwt),
      );
    }
    var decoded = jsonDecode(res.body); 
    return decoded[table];
  }

  updateChartData(String dataJson, int id){
    return http.post(
        Uri.https('tolerant-condor-98.hasura.app', '/api/rest/UpdateChartData/$id'),
        headers: _getAuthHeaders(jwt),
        body: '{"_set":$dataJson}'
      );
  }

  insertChartData(String dataJson){
      return http.post(
        Uri.https('tolerant-condor-98.hasura.app', '/api/rest/InsertChartData'),
        headers: _getAuthHeaders(jwt),
        body: dataJson
      );
  }

  _getAuthHeaders(jwt){
    if(jwt == ""){
      return null;
    }else{
      return {HttpHeaders.authorizationHeader: "Bearer $jwt"};
    }

  }

}