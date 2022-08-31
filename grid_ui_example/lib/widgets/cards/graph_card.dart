import 'package:flutter/material.dart';
import 'package:grid_ui_example/settings/theme.dart';
import 'package:grid_ui_example/settings/ui_constants.dart';


class GraphCard extends StatefulWidget {
  final Widget graph;
  final Color color;
  final String title;
  final String subtitle;

  const GraphCard({Key? key,
   required this.graph, required this.color, required this.title, required this.subtitle})
    : super(key: key);

  @override
  State<StatefulWidget> createState() => GraphCardState();
}

class GraphCardState extends State<GraphCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(18)),
          color: cardBackgroundColor,
          boxShadow: [BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 5,
            offset: const Offset(5, 5), // changes position of shadow
          )],
        ),
        child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(
                  height: defaultPadding,
                ),
               Text(
                  widget.title,
                  style: TextStyle(
                    color: widget.color,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              widget.subtitle,
              style: TextStyle(
                color: Colors.blueGrey,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: defaultPadding,
            ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: 16.0, left: 6.0),
                    child: widget.graph,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
      ),
    );
  }
}