import 'package:flutter/material.dart';
import '../../settings/theme.dart';
import '../../settings/ui_constants.dart';


class MultiValueCardHorizontal extends StatelessWidget {
  const MultiValueCardHorizontal({
    Key? key,
    required this.title,
    required this.color,
    required this.dataList,
    this.help = "",
  }) : super(key: key);

  final String title;
  final Color color;
  // [key, value, unit]
  // ex) [Kr, 1.44, kph]
  final List<List<String>> dataList;
  final String help;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: (title=="")?150:170,
      child: Card(
            color: cardBackgroundColor,
            elevation: 20,
            shadowColor: Colors.black,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.all(defaultPadding),
          child:
          Column(children: [
           (title=="")? const SizedBox(height: 1,)
           :Padding(padding: const EdgeInsets.only(top:8.0), child:Text(title, style: TextStyle(fontSize:25, fontWeight: FontWeight.bold, color: color),),),
           Expanded(child:ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(15),
            itemCount: dataList.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: (Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  dataList[index][1],
                                  style: const TextStyle(fontSize:25, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  " ${dataList[index][2]}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54),
                                )
                              ]),
                          Text(
                            dataList[index][0],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey),
                          ),
                        ],
                  )));
            },
            separatorBuilder: (BuildContext context, int index) => VerticalDivider(
              thickness: 1,
              color: color.withOpacity(0.5),
              indent: 10,
              endIndent: 10,
            ),
          ),),
          ],)
      ),
        );
  }
}
