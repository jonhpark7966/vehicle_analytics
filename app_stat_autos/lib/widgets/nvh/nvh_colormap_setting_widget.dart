import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:grid_ui_example/pages/test/nvh/test_nvh_summary_tab.dart';
import 'package:grid_ui_example/widgets/graphs/nvh_3d_graph_settings.dart';
import 'package:provider/provider.dart';
import '../../../loader/loader.dart';
import '../../../loader/models.dart';
import '../../../settings/ui_constants.dart';
import '../../../utils/nvh_files.dart';
import '../../../widgets/appbar.dart';
import '../../../widgets/buttons/test_download_button.dart';
import '../../../widgets/graphs/nvh_3d_graph.dart';
import '../../../widgets/test_title.dart';
import '../../../data/nvh_data.dart';
import '../../utils/nvh_utils.dart';


class NVHColormapSettingWidget extends StatefulWidget {
  NVHColormap colormap;
  Color mainColor;
  NVHType type;
  String channel;


  NVHColormapSettingWidget(this.colormap, this.mainColor,
  this.type, this.channel,
    {Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _NVHColormapSettingWidgetState();
}

class _NVHColormapSettingWidgetState extends State<NVHColormapSettingWidget> {

  late NVH3DSettings settings;

  @override
  initState(){
    super.initState();
    settings =  _createNVH3DSettings();
  }

  _createNVH3DSettings() {
    var ret =  NVH3DSettings.fromTypeChannel(
      widget.type, NVHUtils.getPosition(widget.channel),
      update3DGraphCallback: setState,
    );
    return ret;
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.all(defaultPadding),
          decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: NVH3DSettingsWidget(settings, widget.mainColor),
        ),
        Expanded(
            child: Container(
                    padding: const EdgeInsets.all(15),
                    child: NVH3DGraph(
                      data: widget.colormap,
                      settings: settings,
                      fullSize: true,
                    )))
          ],
    );
  }
}



