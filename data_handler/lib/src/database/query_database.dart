import 'dart:io';

import 'package:http/http.dart' as http;

class QueryDatabase{

  String jwt = "";

  getChartData(id) async {
      return http.get(
        Uri.https('tolerant-condor-98.hasura.app', '/api/rest/getChartData'),
        headers: {HttpHeaders.authorizationHeader: "Bearer $jwt"},
      );
  }

}