import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grid_ui_example/widgets/popups/todo.dart';
import 'package:provider/provider.dart';

import '../../../../data/nvh_data.dart';
import '../../../pages/test/test_data_models.dart';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../settings/theme.dart';
import '../../settings/ui_constants.dart';
import '../../utils/nvh_utils.dart';
import '../cards/graph_card.dart';
import '../nvh/nvh_constants.dart';

class NVH3DSettings{
  Weight weighting;
  ColorMapPalette palette;
  // null means using min/max value of source data.
  double? minX;
  double? maxX;
  double? minY;
  double? maxY;
  double? minZ;
  double? maxZ;
  double? cmin;
  double? cmax;

  Function? update3DGraphCallback;

  NVH3DSettings({
    this.minX = 0,
    required this.maxX,
    this.minY,
    this.maxY,
    required this.minZ,
    required this.maxZ,
    this.cmin,
    this.cmax,
    this.update3DGraphCallback,
    this.weighting = Weight.none, this.palette = ColorMapPalette.Jet}){
      cmin??=minZ;
      cmax??=maxZ;
    }

  NVH3DSettings.clone(NVH3DSettings object)
      : this(
            minX: object.minX,
            maxX: object.maxX,
            minY: object.minY,
            maxY: object.maxY,
            minZ: object.minZ,
            maxZ: object.maxZ,
            cmin: object.cmin,
            cmax: object.cmax,
            weighting: object.weighting,
            palette: object.palette);

  factory NVH3DSettings.fromTypeChannel(NVHType type, Position position, {Function? update3DGraphCallback}){

    double maxX = 1000;
    double minZ = 0;
    double maxZ = 0;
    Weight weight = Weight.none;

    switch (type) {
      case NVHType.Idle:
        maxX = NVHConstants.idleHighFreq;
        minZ = (position == Position.Noise) ? NVHConstants.idleNoiseMinY : ((position==Position.VibrationBody)? NVHConstants.idleVibBodyMinY:NVHConstants.idleVibSrcMinY);
        maxZ = (position == Position.Noise) ? NVHConstants.idledBANoiseMaxY : ((position==Position.VibrationBody)? NVHConstants.idleVibSrcMaxY:NVHConstants.idleVibSrcMaxY);
        weight = (position == Position.Noise) ? Weight.A: Weight.none;
        break;
      default:
        assert(false);
    }

    return NVH3DSettings(maxX: maxX, minZ: minZ, maxZ: maxZ, weighting: weight);
  }

  update3dGraph(Map<String, TextEditingController> axisController){
    if(update3DGraphCallback == null){
      return;
    }

    // check axis values.
    axisController.forEach((key, value){
      if(value.text == "" || value.text =="null"){
        setValueByKey(key, null);
      }else{
        int val = int.parse(value.text);
        setValueByKey(key, val);
      }
    });

    update3DGraphCallback!((){});
  }

  getValueByKey(key){
    if(key == "minX"){ return minX;}
    else if(key == "minY"){ return minY;}
    else if(key == "minZ"){ return minZ;}
    else if(key == "cmin"){ return cmin;}
    else if(key == "maxX"){ return maxX;}
    else if(key == "maxY"){ return maxY;}
    else if(key == "maxZ"){ return maxZ;}
    else if(key == "cmax"){ return cmax;}
    else{ assert(false);}
  }

 setValueByKey(key, value){
    if(key == "minX"){ minX = value;}
    else if(key == "minY"){ minY = value;}
    else if(key == "minZ"){ minZ = value;}
    else if(key == "cmin"){ cmin = value;}
    else if(key == "maxX"){ maxX = value;}
    else if(key == "maxY"){ maxY = value;}
    else if(key == "maxZ"){ maxZ = value;}
    else if(key == "cmax"){ cmax = value;}
    else{ assert(false);}
  }
}

class NVH3DSettingsWidget extends StatefulWidget {
  NVH3DSettings settings;
  Color mainColor;

  NVH3DSettingsWidget(this.settings, this.mainColor,  {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NVH3DGraphState();
}

class _NVH3DGraphState extends State<NVH3DSettingsWidget> {

  late Timer _timer;


  Map<String, TextEditingController> axisController = {
    "minX": TextEditingController(), 
    "maxX": TextEditingController(), 
    "minY": TextEditingController(), 
    "maxY": TextEditingController(), 
    "minZ": TextEditingController(), 
    "maxZ": TextEditingController(), 
    "cmin": TextEditingController(), 
    "cmax": TextEditingController(), 
  };


  List<Widget> _getWeightingTiles() {
  List<Widget> ret = <Widget>[];
    for (Weight weight in Weight.values) {
        ret.add(ListTile(
          title: Text(weight.name),
          leading: Radio<Weight>(
            value: weight,
            groupValue: widget.settings.weighting,
            onChanged: (Weight? value) {
              setState(() {
                if (value == null) {
                  return;
                }
                widget.settings.weighting = value;
              });
            },
            fillColor:
                MaterialStateColor.resolveWith((states) => widget.mainColor),
          ),
        ));
    }
    return ret;
  }

List<Widget> _getColorPaletteTiles(){
  List<Widget> ret = <Widget>[];
  for (ColorMapPalette palette in ColorMapPalette.values) {
      ret.add(ListTile(
        title: Text(palette.name),
        leading: Radio<ColorMapPalette>(
          value: palette,
          groupValue: widget.settings.palette,
          onChanged: (ColorMapPalette? value) {
            setState(() {
              if (value == null) {
                return;
              }
              widget.settings.palette = value;
            });
          },
          fillColor:
              MaterialStateColor.resolveWith((states) => widget.mainColor),
        ),
      ));
  }
  return ret;
 }

 List<Widget> _getAxisTiles(){
    List<Widget> ret = <Widget>[];
    axisController.forEach((key, controller) {
      controller.text = widget.settings.getValueByKey(key).toString();
      ret.add(Padding(
        padding: const EdgeInsets.fromLTRB(defaultPadding, 8.0, defaultPadding, 8.0,),
        child:
        TextField(
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            border: const OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                    color: widget.mainColor,
                    width: 1.0,
                  ),
                ),
            labelText: 'Enter $key Value',
            labelStyle: TextStyle(color:widget.mainColor),
          ),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'^-?[0-9]*'))
              ])));
    });

    return ret;
 }
     

  @override
  Widget build(BuildContext context) {

    return 
      SizedBox(
      width: 300,
      child: SingleChildScrollView(child:Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
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
          const Divider(),
const Text("Weighting"),
          ]+
          _getWeightingTiles()
          +[const Divider(),
          const Text("Axis"),]
          +_getAxisTiles()
          +[const Divider(),
          const Text("Color Palette"),]
          +_getColorPaletteTiles()
          +[
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: widget.mainColor),
              onPressed: () async {
                try{
                widget.settings.update3dGraph(axisController);
                }catch(_){
                  await showDialog(
                  context: context,
                  barrierDismissible: true, 
                  builder: (BuildContext context) {
                          _timer = Timer(const Duration(seconds: 3), () {
                            Navigator.of(context).pop();
                          });
                    return const AlertDialog(content:SizedBox(
                      width: 500,
                      child: Text("Axis Value is not valid!")));
                  }).then((val){
                      if (_timer.isActive) {
                        _timer.cancel();
                      }
                    });
                  return;
                }
            }, child:
                const Text("Apply"),
             ),
             const SizedBox(height:defaultPadding),
          ]
      ),
    ));
  }
}
