// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/results_provider.dart';

// ignore: must_be_immutable
class DatabaseWidget extends StatelessWidget{
  DatabaseWidget({Key? key}) : super(key: key);

  late ResultsProvider _resultsProvider;

  @override
  Widget build(BuildContext context) {
    _resultsProvider = Provider.of<ResultsProvider>(context);

    return ListView.builder(
                    itemCount: _resultsProvider.currentMap.length,
                    itemBuilder: (BuildContext context, int index) {
                      String key = _resultsProvider.currentMap.keys.elementAt(index);
                      return Column(
                        children: <Widget>[
                          ListTile(
                              tileColor: Colors.white,
                              title: Text(key),
                              subtitle: Text("${_resultsProvider.currentMap[key]}"),
                              onTap: () async {
                                await _showPopup(key, context);

                                // ignore: invalid_use_of_protected_member
                                _resultsProvider.notifyListeners();
                              }),
                          const Divider(
                            height: 2.0,
                          ),
                        ],
                      );
                    },
                  );
    }

 Future<void> _showPopup(String key, BuildContext context) async {
    final controller = TextEditingController(text: _resultsProvider.currentMap[key].toString());

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change Value'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(key),
                const Divider(),
                TextField(
                  controller: controller,
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Approve'),
              onPressed: () {
                if (_resultsProvider.currentMap[key].runtimeType == int) {
                  _resultsProvider.currentMap[key] = int.parse(controller.text);
                } else if (_resultsProvider.currentMap[key].runtimeType == double) {
                  _resultsProvider.currentMap[key] = double.parse(controller.text);
                } else {
                  _resultsProvider.currentMap[key] = controller.text;
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

