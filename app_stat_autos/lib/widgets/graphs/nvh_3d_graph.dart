import 'dart:convert';
import 'dart:html';

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

class NVH3DSettings{
  Weight weighting;

  NVH3DSettings({this.weighting = Weight.none});
  NVH3DSettings.clone(NVH3DSettings object): this(weighting: object.weighting);
}



class NVH3DGraph extends StatefulWidget{

  final GlobalKey webViewKey = GlobalKey();
  NVHColormap data;

  double maxX;
  double minY;
  double maxY;
  Color color;
 
  NVH3DGraph({Key? key, required this.data, required this.color,
    required this.maxX, required this.minY, required this.maxY}) : super(key:key);
    
      @override
      State<StatefulWidget> createState()=>_NVH3DGraphState();
}

class _NVH3DGraphState extends State<NVH3DGraph> {
  InAppWebViewController? webViewController;

  NVH3DSettings settings = NVH3DSettings();  

  _showSettingsPopup(context) async {
    NVH3DSettings tmpSettings = NVH3DSettings.clone(settings);
    await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: cardBackgroundColor,
            content: NVH3DGraphSettings(tmpSettings),
            actions: [
              ElevatedButton(
                child: const Text("OK"),
                onPressed: () {
                  settings = tmpSettings;
                  setState(() {
                    webViewController?.loadData(data: _getPlotlyJsScript(widget.data),);
                    //webViewController?.reload(); 
                  });
                  Navigator.pop(context);
                },
              ),
              ElevatedButton(
                child: const Text("Cancel"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
            );
        });
    return;
  }


  @override
  Widget build(BuildContext context) {
    return 
    Row(
      children:[
      SizedBox(
        width:graph3DWidth+30, height:graph3DHeight+30,
        child:
        InAppWebView(
          key: widget.webViewKey,
          initialData: InAppWebViewInitialData(
            data: _getPlotlyJsScript(widget.data),
          ),
          onWebViewCreated: (controller) {
            webViewController = controller;
          },
        )),
      Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
      FloatingActionButton.small(
        backgroundColor: widget.color,
        child: Icon(Icons.settings),
        onPressed: (){
          _showSettingsPopup(context);
      }),
      SizedBox(height:8),
      FloatingActionButton.small(
        backgroundColor: widget.color,
        child: Icon(Icons.open_in_new),
        onPressed: (){
        showTodoPopup(context);
      }),

      ],),
        ]
        );
  }

  String _getData(NVHColormap data){

    Map<String, dynamic> ret = {
      'type' : "surface",
      'contours': {'z':{'show':true, 'usecolormap':true, 'project':{'z':true}}}
      };

    double xDelta = double.parse(data.xAxisDelta);
    List<double> x = List.generate(widget.maxX~/xDelta, (index) => index*xDelta);
    ret["x"] = x;

    double yDelta = double.parse(data.yAxisDelta);
    List<double> y = List.generate(widget.maxX~/yDelta, (index) => index*yDelta);
    ret["x"] = y;

    List<List<double>> filteredValue = [];
    for(List<double> line in data.values){
      var weightedList = NVHUtils.weightingList(line.sublist(0, widget.maxX~/xDelta), double.parse(data.xAxisDelta), settings.weighting);
      for(int i = 0; i < 4; ++i){
        weightedList[i] = 0.0;  // make it null?
      }
      filteredValue.add( weightedList );
    }
    ret["z"] =filteredValue; 

    String s= jsonEncode(ret);
    return s;
  }
 
  _getPlotlyJsScript(data){

    return """
<!DOCTYPE html>
<html>
<head>
  <script src="https://cdn.plot.ly/plotly-2.18.2.min.js"></script>
</head>
<body>
  <div class="container" id="plotly"></div>
</div>
<script>

var data = [${_getData(data)},];

var layout = {
  autosize: false,
  width: $graph3DWidth,
  height: $graph3DHeight,
  paper_bgcolor:'rgba(0,0,0,0)',
  plot_bgcolor:'rgba(0,0,0,0)',
  scene: {
		xaxis:{title: 'Frequency (Hz)'},
		yaxis:{title: 'Time (s)'},
		zaxis:{
      title: 'Level (dB)',
      range:[0,150]
    },
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



class NVH3DGraphSettings extends StatefulWidget{
  NVH3DSettings settings;

  NVH3DGraphSettings(this.settings, {Key? key}) : super(key:key);
    
      @override
      State<StatefulWidget> createState()=>_NVH3DGraphSettingsState();
}

class _NVH3DGraphSettingsState extends State<NVH3DGraphSettings> {

  
  @override
  Widget build(BuildContext context) {
        return SizedBox(
            width: 500,
            child: Column(
              children: [
  const SizedBox(
                  height: defaultPadding,
                ),
               const Text(
                  "3D Graph Settings",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text("Weighting"),
                    ListTile(
                      title: const Text('A'),
                      leading: Radio<Weight>(
                        value: Weight.A,
                        groupValue: widget.settings.weighting,
                        onChanged: (Weight? value) {
                          setState(() {
                            if(value == null){return;}
                            widget.settings.weighting = value;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('C'),
                      leading: Radio<Weight>(
                        value: Weight.C,
                        groupValue: widget.settings.weighting,
                        onChanged: (Weight? value) {
                          setState(() {
                            if(value == null){return;}
                            widget.settings.weighting = value;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('None'),
                      leading: Radio<Weight>(
                        value: Weight.none,
                        groupValue: widget.settings.weighting,
                        onChanged: (Weight? value) {
                          setState(() {
                            if(value == null){return;}
                            widget.settings.weighting = value;
                          });
                        },
                      ),
                    ),
                  const Divider(),
                  Text("Color Palette"),
                  ],),
                  );
  }
  }

