import 'package:flutter/material.dart';
import 'package:grid_ui_example/settings/theme.dart';
import 'package:grid_ui_example/settings/ui_constants.dart';


class MultiValueCard extends StatelessWidget {
  const MultiValueCard({
    Key? key,
    required this.title,
    required this.color,
    required this.dataList,
  }) : super(key: key);

  final String title;
  final Color color;
  // [key, value, unit]
  // ex) [Kr, 1.44, kph]
  final List<List<String>> dataList;

  @override
  Widget build(BuildContext context) {
    return Container(
      height:120+dataList.length*50,
      child: Card(
            color: cardBackgroundColor,
            elevation: 20,
            shadowColor: Colors.black,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: EdgeInsets.all(defaultPadding),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: const EdgeInsets.all(defaultPadding),
                      child: Text(title,
                       style: TextStyle(fontSize: 20, color: color, fontWeight: FontWeight.bold),)),
                  Expanded(child:ListView.separated(
                    padding: const EdgeInsets.all(5),
                    itemCount: dataList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                            height: 35,
                            child: (Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(dataList[index][0],
                                 style: TextStyle(fontWeight: FontWeight.bold, color:Colors.blueGrey),),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children:[
                                    Text(dataList[index][1], style: TextStyle(fontWeight: FontWeight.bold),),
                                    Text(" ${dataList[index][2]}", style: TextStyle(fontWeight: FontWeight.bold, color:Colors.black54),)]),
                              ],
                            )
                      ));
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(
                          thickness: 1,
                          color: color.withOpacity(0.5),
                          indent: 10,
                          endIndent: 10,
                        ),
                  ),),
                ])));
  }
}
