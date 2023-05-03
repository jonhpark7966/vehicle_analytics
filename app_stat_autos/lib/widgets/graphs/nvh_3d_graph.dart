import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:grid_ui_example/widgets/popups/todo.dart';
import 'package:provider/provider.dart';

import '../../../../data/nvh_data.dart';
import '../../../pages/test/test_data_models.dart';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../settings/theme.dart';
import '../../settings/ui_constants.dart';
import '../../utils/nvh_utils.dart';
import '../cards/graph_card.dart';
import 'nvh_3d_graph_settings.dart';

class NVH3DGraph extends StatefulWidget {
  final GlobalKey webViewKey = GlobalKey();
  NVHColormap data;
  NVH3DSettings settings;
  bool fullSize = false;

  NVH3DGraph(
      {Key? key,
      required this.data,
      required this.settings,
      this.fullSize = false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _NVH3DGraphState();
}

class _NVH3DGraphState extends State<NVH3DGraph> {
  InAppWebViewController? webViewController;

  _getWebview(){
    return InAppWebView(
            key: widget.webViewKey,
            initialData: InAppWebViewInitialData(
              data: _getPlotlyJsScript(widget.data),
            ),
            onWebViewCreated: (controller) {
              webViewController = controller;
            },
          );
  }

  @override
  Widget build(BuildContext context) {
      return widget.fullSize? _getWebview()
      : SizedBox(
          width: (graph3DWidth + 30),
            height: (graph3DHeight + 30),
            child: _getWebview(),
          );
  }

  _filterData(Map<String, dynamic> ret, NVHColormap data, NVH3DSettings settings){

    double xDelta = double.parse(data.xAxisDelta);
    double minX = settings.minX ?? 0;
    minX = max(minX, 0);
    double maxX = settings.maxX ?? (data.values.first.length * xDelta);
    maxX = min(maxX, (data.values.first.length * xDelta));

    List<double> x =
        List.generate((maxX-minX) ~/ xDelta, (index) => index * xDelta);
    ret["x"] = x;

    double yDelta = double.parse(data.yAxisDelta);
    double minY = settings.minY ?? 0;
    minY = max(minY, 0);
    double maxY = settings.maxY ?? (data.values.length * yDelta);
    maxY = min(maxY, (data.values.length * yDelta));


    List<double> y =
        List.generate((maxY-minY) ~/ yDelta, (index) => index * yDelta);
    ret["y"] = y;

    List<List<double>> filteredValue = [];
    for (List<double> line in data.values) {
      var weightedList = NVHUtils.weightingList(
          line.sublist(minX ~/ xDelta, maxX ~/ xDelta),
          double.parse(data.xAxisDelta),
          settings.weighting,
          minX
          );
      
      int i = 0;
      while(minX + i*xDelta < 2){ // freq < 2Hz.
        weightedList[i] = 0.0; // make it null?
        ++i;
      } 

      filteredValue.add(weightedList);
    }
    ret["z"] = filteredValue;
  }

  String _getData(Map<String, dynamic> ret, NVHColormap data) {
    

    // SET color min/max,
    // TODO: min shoulbe be over 0 because of "-" char error.
    if(widget.settings.cmax !=null){
      ret['cmax'] = widget.settings.cmax!;
    }
    if(widget.settings.cmin !=null){
      ret['cmin'] = widget.settings.cmin!;
    }

    // Filterring values
    _filterData(ret, data, widget.settings);

    String s = jsonEncode(ret);
    return s;
  }

  _getMax(List<List<double>> data){
    double ret = data.first.first;
    for(List<double> row in data){
      double rowMax = row.reduce(max);
      ret = max(ret,rowMax);
    }
  }

  String _getSceneOptions(Map<String,dynamic> ret, NVHColormap data){

    double xDelta = double.parse(data.xAxisDelta);
    double minX = widget.settings.minX ?? 0;
    double maxX = widget.settings.maxX ?? (data.values.first.length * xDelta);

    double yDelta = double.parse(data.yAxisDelta);
    double minY = widget.settings.minY ?? 0;
    double maxY = widget.settings.maxY ?? (data.values.length * yDelta);

    double minZ = widget.settings.minZ ?? 0;
    double maxZ = widget.settings.maxZ ?? _getMax(ret["z"]);


    return """scene: {
		xaxis:{title: 'Frequency (Hz)',
    range:[$minX, $maxX]
    },
		yaxis:{title: 'Time (s)',
    range:[$minY, $maxY]
    },
		zaxis:{
      title: 'Level (${widget.settings.weighting.unit})',
      range:[$minZ, $maxZ]
    },
	  },""";
  }

  String _getSizeLayout(){
    if(widget.fullSize){
      return "height: ${MediaQuery.of(context).size.height - 150},";
    }else{
      return """
         autosize:false,
         width: ${graph3DWidth},
         height: ${graph3DHeight},
         """;
    }
  }

  _getPlotlyJsScript(data) {
    Map<String, dynamic> ret = {
      'type': "surface",
      'contours': {
        'z': {
          'show': true,
          'usecolormap': true,
          'project': {'z': true}
        }
      },
      'colorscale': widget.settings.palette.name,
    };

    String dataString = _getData(ret, data);

    return """
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <script src="https://cdn.plot.ly/plotly-2.18.2.min.js"></script>
</head>
<body>
  <div class="container" id="plotly"></div>
</div>
<script>

var data = [$dataString,
];

var layout = {
  ${_getSizeLayout()}
  paper_bgcolor:'rgba(0,0,0,0)',
  plot_bgcolor:'rgba(0,0,0,0)',
  ${_getSceneOptions(ret, data)}
    font: {
    family: 'Arial, sans-serif'
  },
  margin: {
	 l: 0,
	 r: 0,
	 b: 0,
	 t: 0,
	 pad: 4
	},
};

Plotly.newPlot(document.getElementById("plotly"), data, layout);

</script>
</body>
</html>
""";
  }
}

