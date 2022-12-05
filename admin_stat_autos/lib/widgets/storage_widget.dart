// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/results_provider.dart';

// ignore: must_be_immutable
class StorageWidget extends StatelessWidget{
  StorageWidget({Key? key}) : super(key: key);

  late ResultsProvider _resultsProvider;

  @override
  Widget build(BuildContext context) {
    _resultsProvider = Provider.of<ResultsProvider>(context);

    return ListView.builder(
                    itemCount: _resultsProvider.currentFiles.length,
                    itemBuilder: (BuildContext context, int index) {
                      String key = _resultsProvider.currentFiles.keys.elementAt(index);
                      return Column(
                        children: <Widget>[
                          ListTile(
                              tileColor: Colors.white,
                              title: Text(key),
                              subtitle: Text("${_resultsProvider.currentFiles[key]}"),
                              onTap: () async {
                                //TODO, select file?
                                //await _showPopup(key, context);

                                // ignore: invalid_use_of_protected_member
                                //_resultsProvider.notifyListeners();
                              }),
                          const Divider(
                            height: 2.0,
                          ),
                        ],
                      );
                    },
                  );
    }
 }

