
import 'package:grid_ui_example/data/coastdown_data.dart';

class LoadedDataModel {
  bool loaded = false;
}

class CoastdownRawLoadedDataModel extends LoadedDataModel{
  List<CoastdownRawData> runs = [];
  CoastdownLogData log = CoastdownLogData("","","","");
}